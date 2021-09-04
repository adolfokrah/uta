import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta/services/youtube_service.dart';



void showDownloadOptions(context, videoId, artist){
  YoutubeService yt = YoutubeService();

  showModalBottomSheet(
    context: context,
    builder: (context) => Container(
      height:  200,
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
          Padding(
            padding: const EdgeInsets.only(bottom:8.0, top: 8, left:10),
            child: Text("Download media as",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,fontSize: 15),),
          ),
          InkWell(
            onTap:(){
              //Navigator.of(context).pop();
              var url = "https://www.youtube.com/watch?v="+videoId;
              yt.downloadVideo(url,artist,"audio",context);
            },
            child:ListTile(
              leading: Icon(CupertinoIcons.music_note_2),
              title: Text("Audio",style: GoogleFonts.poppins(),),
            ),
          ),
          Divider(),
          InkWell(
            onTap:(){
              //Navigator.of(context).pop();
              var url = "https://www.youtube.com/watch?v="+videoId;
              yt.downloadVideo(url,artist,"video",context);
            },
            child:ListTile(
              leading: Icon(CupertinoIcons.videocam_fill),
              title: Text("Video",style: GoogleFonts.poppins(),),
            ),
          )
        ],
      ),
    ),
  );
}