import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:uta/services/db_service.dart';

class MySongs extends StatelessWidget {
  final songs;
  const MySongs({Key? key, this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Recent Songs",style: GoogleFonts.poppins(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600),),
          Expanded(
            child: ListView(
              children: [
                Wrap(
                  children: [
                     for(var index=0; index<songs.length; index++)
        Container(
                width: (MediaQuery.of(context).size.width / 2) - 30,
                margin: EdgeInsets.only(right:10, top:20),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xff374850),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      ),
                      image: DecorationImage(
                      image: CachedNetworkImageProvider(songs[index]['song_image'],),
                      fit: BoxFit.cover
                      )
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                          onTap:(){
                            showModal(context,songs[index]['song_path'],songs[index]['id']);
                          },
                          child: Icon(Icons.more_vert, color: Colors.white,)),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: (){
                              OpenFile.open(songs[index]['song_path']);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40, bottom: 40),
                              child: CircleAvatar(
                                child: Icon(Icons.play_arrow, color: Colors.white,size: 40,),
                                radius: 35,
                                backgroundColor: Colors.black54,
                              ),
                            ),
                          ),
                        )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(songs[index]['song_title'], style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),overflow: TextOverflow.ellipsis,
                        maxLines: 2,),
                  ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0,bottom: 10),
                      child: Text(songs[index]['song_artist'], style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 14),overflow: TextOverflow.ellipsis,
                        maxLines: 2,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:8.0,right:8.0,bottom: 10),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 3.0),
                              child: Icon(songs[index]['song_path'].contains('.mp3') ? CupertinoIcons.music_note_2 : CupertinoIcons.videocam_fill, color: Colors.white, size: 15,),
                            ),
                            Text(songs[index]['song_path'].contains('.mp3') ? "Audio" : "Video", style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 11),overflow: TextOverflow.ellipsis,
                              maxLines: 2,)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void showModal(context,path,id){

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height:  80,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(5))
              ),
            ),),
            InkWell(
              onTap:()async{
                await removeFile(path,id);
                Navigator.pop(context);
              },
              child:ListTile(
                leading: Icon(CupertinoIcons.trash),
                title: Text("Remove Media",style: GoogleFonts.poppins(),),
              ),
            )
          ],
        ),
      ),
    );
  }

  removeFile(path,id)async{
    DbService dbService = DbService();
    try {
      final file = File(path);

      await file.delete();
      Fluttertoast.showToast(
          msg: "Song Removed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0
      );
      await dbService.initDb();
      await dbService.removeSong(id);
      await dbService.getSongs();
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
