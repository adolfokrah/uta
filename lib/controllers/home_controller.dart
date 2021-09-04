
import 'dart:convert';
import 'dart:io';

import 'package:acr_cloud_sdk/acr_cloud_sdk.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uta/services/acr_cloud_service.dart';
import 'package:uta/services/db_service.dart';
import 'package:uta/services/youtube_service.dart';
import 'package:record/record.dart';
import 'package:uta/components/disclaimer.dart';

class HomeController extends GetxController{
  var listening = false.obs;
  var searchOpen = false.obs;
  var searchValue = "".obs;
  YoutubeService yt = YoutubeService();
  final AcrCloudSdk arc = AcrCloudSdk();
  final _audioRecorder = Record();
  final AcrCloud acrCloud = AcrCloud();
  final dbService = DbService();
 var _context;
  HomeController(context){
    _context = context;
  }


  @override
  Future<void> onInit()async{
    // TODO: implement onInit
    try{

      Map<Permission, PermissionStatus> statuses = await [
        Permission.microphone,
        Permission.storage,
      ].request();

      await dbService.initDb();
      var results = await dbService.userServiceAgreed();
      if(results.length < 1){
        showDisclaimer(_context);
      }
      await dbService.getSongs();

    }catch(e){
      print(e.toString());
    }
    //super.onInit();
  }



  listen()async{

    PanelController _pc = Get.find();
    TextEditingController search = Get.find();
    try{

      listening.value = true;


      // Start recording
      Directory? appDocDir = await getExternalStorageDirectory();


      // Check and request permission
      bool result = await _audioRecorder.hasPermission();
      //print('${appDocDir?.path}/record.mp3');
      await _audioRecorder.start(
        path: '${appDocDir?.path}/record.mp3', // required
        encoder: AudioEncoder.AAC, // by default
        bitRate: 128000, // by default
        samplingRate: 44100, // by default
      );
      //await arc.start();

      await Future.delayed(Duration(milliseconds: 8000));

      final path = await _audioRecorder.stop();

      var results = await acrCloud.identify(path);
      var data = jsonDecode(results)['metadata'];

      if (data != null && data['music'].length > 0) {
        if(!listening.value) return;
        search.text = data['music'][0]['title'];
        await _pc.show();
        await _pc.open();
        var song = data['music'][0]['title']+" - "+data['music'][0]['artists'][0]['name'];
        yt.searchSongFromYoutube(song);
        searchValue.value = data['music'][0]['title'];
      }else{
        await _pc.show();

        Fluttertoast.showToast(
            msg: "Failed grabbing song, try again later",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black87,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }//
    }catch(e){
      await _pc.show();
      print(e);
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
      stopListening();
    }

  }

  stopListening()async{
    listening.value = false;
    await _audioRecorder.stop();
  }

  setSearch(newValue){
    searchValue.value = newValue;
    yt.searchSongFromDeezer(newValue);
  }
  toggleSearchOpen(newValue)=>searchOpen.value = newValue;
}