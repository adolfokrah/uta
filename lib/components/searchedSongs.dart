import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'download_options.dart';

class SearchedSongs extends StatelessWidget {
  final songs;
  final loading;
  const SearchedSongs({Key? key, this.songs, this.loading}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return ListView.separated(
      separatorBuilder: (c,i){
        return Divider();
      },
      itemCount: songs.length,
      itemBuilder: (c,i){
        return ListTile(
            leading: CircleAvatar(
                backgroundImage:  NetworkImage(songs[i]['snippet']['thumbnails']['medium']['url']),
            ),
            title: Text(songs[i]['snippet']['title'],
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: GoogleFonts.poppins(color:Colors.white),),trailing: IconButton(icon: Icon(Icons.download, color: Colors.white),onPressed: (){

          showDownloadOptions(context,songs[i]['id']['videoId'],songs[i]['snippet']['channelTitle']);

        },),);
      },
    );
  }
}
