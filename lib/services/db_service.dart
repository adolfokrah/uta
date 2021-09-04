import 'dart:io';

import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:uta/controllers/videos_cotroller.dart';

class DbService{
  late Database database;
  final VideosController vController = Get.find();

  initDb()async{
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'uta_music.db');

    database = await openDatabase(path, version: 1,
    onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('CREATE TABLE ServiceAgreed (id INTEGER PRIMARY KEY, first_time BOOL)');
      await db.execute('CREATE TABLE MySongs (id INTEGER PRIMARY KEY, song_title TEXT, song_artist TEXT, song_image TEXT, song_path TEXT)');
    });
  }


  userServiceAgreed()async{
    //check if user as agreed to our terms of service
    List<Map> list = await database.rawQuery('SELECT * FROM ServiceAgreed');
    return list;
  }

  agreeToOurService()async{
    await database.transaction((txn) async {
      int id1 = await txn.rawInsert(
          'INSERT INTO ServiceAgreed(first_time) VALUES(1)');
      return id1;
    });
  }

  insertSong(song)async{
    //check if song already exist
    List<Map> foundSong = await database.rawQuery("SELECT * FROM MySongs where song_path = '${song['song_path']}' ");

    if(foundSong.length < 1){
      //insert song
      await database.transaction((txn) async {
        int id1 = await txn.rawInsert(
            'INSERT INTO MySongs(song_title,song_artist,song_image,song_path) VALUES("${song['song_title']}","${song['song_artist']}","${song['song_image']}","${song['song_path']}")');
      });
    }
  }

  getSongs()async{
    List<Map> songs = await database.rawQuery("SELECT * FROM MySongs order by id desc limit 0,8 ");
    var songData = [];
    songs.forEach((song)async{
       final file = File(song['song_path']);
       if(await file.exists() == false){
         await removeSong(song['id']);
       }else{
         songData.add(song);
       }
    });

    vController.setMySongs(songData);
  }
  removeSong(id)async{
    var count = await database.rawDelete("DELETE FROM MySongs WHERE id = ?", [id]);
  }

}