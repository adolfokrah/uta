import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta/services/youtube_service.dart';

class SuggestedSongs extends StatelessWidget {
  final songs;
  const SuggestedSongs({Key? key, this.songs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    YoutubeService yt = YoutubeService();

    return ListView.separated(
      separatorBuilder: (c,i){
        return Divider();
      },
      itemCount: songs.length,
      itemBuilder: (c,i){
        return InkWell(
          onTap: (){
            yt.searchSongFromYoutube(songs[i]['title']);
            FocusScope.of(context).unfocus();
          },
          child: ListTile(
            title: Text(songs[i]['title'], style: GoogleFonts.poppins(color:Colors.white),), subtitle:Text('By '+songs[i]['artist']['name'], style: GoogleFonts.poppins(color:Colors.white24),),trailing: Icon(Icons.north_west,color:Colors.white) ,),
        );
      },
    );
  }
}
