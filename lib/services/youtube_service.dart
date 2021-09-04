import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:uta/components/loading_dialog.dart';
import 'package:uta/components/show_storage_permmission.dart';
import 'package:uta/controllers/downloader_controller.dart';
import 'package:uta/controllers/videos_cotroller.dart';
import 'package:wakelock/wakelock.dart';
import 'db_service.dart';
import 'notification_service.dart';


class YoutubeService{

  NotificationService notification = NotificationService();

  final DownloaderController controller = Get.put(DownloaderController());
  final VideosController vController = Get.put(VideosController());
  final dbService = DbService();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();



  Map<String, String> headers = {
    "X-Requested-With": "XMLHttpRequest",
  };


   void downloadVideo(videoURL,artist,type,context)async{


     if(notification.flutterLocalNotificationsPlugin == null){
       notification.init();
     }

     Map<String, dynamic> result = {
       'isSuccess': false,
       'filePath': null,
       'error': null,
     };

     Map<String, String?> body = {"url": videoURL, "ajax": "1"};

     try {

       controller.toggleConverting(true);
       LoadingDialog().showProgressDialogue(context);
       Wakelock.enable();
       var response = await http.post(Uri.parse("https://www.y2mate.com/mates/en80/analyze/ajax"),
           body: body, headers:headers);

       var data = jsonDecode(response.body)['result'];

       var reg = RegExp(r'k__id = \"(.*?)\";').firstMatch(data);
       var id = reg!.group(1);
       var title = RegExp(r'k_data_vtitle = \"(.*?)\";').firstMatch(data)!.group(1);
       var videoImage = RegExp(r'<img src=\"(.*?)\"').firstMatch(data)!.group(1);

       final regex = RegExp(r'.*\?v=(.+?)($|[\&])', caseSensitive: false, multiLine: false);

       var format = type == "video" ? "mp4" : "mp3";
       body = {
         "type": "youtube",
         "_id": id,
         "v_id": regex.firstMatch(videoURL)!.group(1),
         "ajax": "1",
         "ftype": format,
         "fquality": type == "video" ? "480" : "128",
         "token":""
       };
       var response2 =
       await http.post(Uri.parse("https://www.y2mate.com/mates/convert"),
       body: body);

         var directURL = RegExp(r'<a href=\\"(.*?)\\"').firstMatch(response2.body)!.group(1)!.replaceAll("\\", "");


         var path = await _createFolder("Uta",format, context);

         controller.toggleConverting(false);
         controller.toggleDownloading(true);
         var downloadResponse = await Dio().download(directURL, "${path}/${title}.${format}",
           onReceiveProgress: (rec, total) {
             controller.increaseProgress(((rec / total) * 100).toStringAsFixed(0) + "%");
           }
         );

       result['isSuccess'] = downloadResponse.statusCode == 200;
       result['filePath'] = "${path}/${title}.${format}";


       Map<String, String?> song = {
         'song_title': title,
         'song_artist': artist,
         'song_image':videoImage,
         'song_path':"${path}/${title}.${format}"
       };
       await dbService.initDb();
       await dbService.insertSong(song);
       await dbService.getSongs();

       Fluttertoast.showToast(
             msg: "Song Downloaded to ${path}/${title}.${format}",
             toastLength: Toast.LENGTH_SHORT,
             gravity: ToastGravity.BOTTOM,
             timeInSecForIosWeb: 1,
             backgroundColor: Colors.black87,
             textColor: Colors.white,
             fontSize: 16.0
         );

       Navigator.pop(context);
     } catch (e) {
       print(e);
       Navigator.pop(context);
       result['error'] = e.toString();
       var found = result['error'].contains('(OS Error: Operation not permitted, errno = 1)') || result['error'].contains('(OS Error: Permission denied, errno = 13)');
       //print(found);
       if(found){
         showPermissionDialog(context);
       }

       Fluttertoast.showToast(
           msg: "Failed grabbing song, try again later",
           toastLength: Toast.LENGTH_SHORT,
           gravity: ToastGravity.BOTTOM,
           timeInSecForIosWeb: 1,
           backgroundColor: Colors.black87,
           textColor: Colors.white,
           fontSize: 16.0
       );
     }finally{
       await notification.showNotification(result);
       controller.toggleConverting(false);
       controller.toggleDownloading(false);
       controller.toggleDownloadFinish(false);
       //Navigator.pop(context);
       Wakelock.disable();
       controller.increaseProgress("0%");
     }

   }

   searchSongFromDeezer(search)async{

     try{
       var response = await http.get(Uri.parse('https://api.deezer.com/search?q=${search}'));
      var results = jsonDecode(response.body)['data'];
      if(results == null){
        vController.setSuggestedSongs([]);
      }else{
        vController.setSuggestedSongs(results);
      }
       vController.setSearchedSongs([]);
     }catch(e){

     }
   }

  searchSongFromYoutube(search)async{
    try{
      vController.setSuggestedSongs([]);
      vController.toggleSearchingSong();
      var response = await http.get(Uri.parse('https://www.googleapis.com/youtube/v3/search?maxResults=10&&part=snippet&q=${search}&key=AIzaSyAxFtcPs75wsY75sxfgMbHRNdf3hh7RNY4'));
      vController.toggleSearchingSong();
      var results = jsonDecode(response.body)['items'];
      if(search.length < 1){
        vController.setSearchedSongs([]);
      }else{
        vController.setSearchedSongs(results);
      }
    }catch(e){
      vController.setSearchedSongs([]);
      vController.toggleSearchingSong();
      Fluttertoast.showToast(
          msg: "Failed searching songs, try again later",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  _createFolder(folderName, format,context)async {
       var path = format == "mp3" ? "/storage/emulated/0/$folderName/Songs" : "/storage/emulated/0/$folderName/Videos";
       final directory = Directory(path);
       if ((await directory.exists())) {
         // TODO:
         return directory.path;
       } else {
         // TODO:
         directory.create(recursive: true);
         return directory.path;
       }

  }
}