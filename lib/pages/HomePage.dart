import 'package:animator/animator.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:uta/components/my_songs.dart';
import 'package:uta/components/searchedSongs.dart';
import 'package:uta/components/suggested_songs.dart';
import  'package:uta/controllers/home_controller.dart';
import 'package:uta/controllers/videos_cotroller.dart';
import 'package:uta/services/youtube_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xff141c20),
      statusBarBrightness: Brightness.dark,
    ));
    //create controller
    final HomeController controller = Get.put(HomeController(context));
    final VideosController vController = Get.put(VideosController());
    PanelController _pc = Get.put(PanelController());
    TextEditingController search = Get.put(TextEditingController());
    YoutubeService yt = YoutubeService();

    return WillPopScope(
      onWillPop: ()async{
        if(controller.searchOpen.value){
          _pc.close();
          return false;
        }else{
          return true;
        }
      },
      child: Scaffold(
        body: Obx(()=>SlidingUpPanel(
          onPanelClosed: (){
            FocusScope.of(context).unfocus();
            controller.toggleSearchOpen(false);
          },
          onPanelOpened: (){
            controller.toggleSearchOpen(true);
          },
          controller: _pc,
          maxHeight: MediaQuery.of(context).size.height - 50,
          minHeight: 100,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
          color: Color(0xff1f2a30),
            panel:  Container(
              padding: EdgeInsets.all(0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top:20.0),
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                          color: Color(0xff414b50)
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:20.0,right:20),
                  child: TextField(
                    onTap: (){
                      _pc.open();
                    },
                    onChanged: (value){
                        controller.setSearch(value);
                    },
                    onSubmitted: (value){
                      yt.searchSongFromYoutube(value);
                    },
                    controller: search,
                    style: TextStyle(color:Colors.white),
                    decoration: InputDecoration(
                        prefixIcon: Icon(CupertinoIcons.search, color:Colors.white70),
                        suffixIcon: controller.searchValue.value.isBlank == true ? null : IconButton(icon: Icon(CupertinoIcons.multiply_circle_fill, color:Colors.white70) , onPressed: (){
                          search.text = "";
                          controller.setSearch("");
                          vController.setSuggestedSongs([]);
                          vController.setSearchedSongs([]);
                        },),
                        contentPadding: EdgeInsets.all(15),
                        fillColor: Colors.black12,
                        filled: true,
                        hintText: "Search for songs, lyrics & artists",
                        hintStyle: TextStyle(color: Colors.white24),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            )
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent, width: 0),
                            borderRadius: const BorderRadius.all(
                              const Radius.circular(10.0),
                            )
                        )
                    ),
                  ),
                ),
                Expanded(
                  child: vController.suggestedSongs.value.length > 0 ? SuggestedSongs(songs: vController.suggestedSongs) : vController.searchingSongs.value == true ? Center(child: CircularProgressIndicator(color:Colors.white,)) : vController.searchedSongs.value.length > 0 ? SearchedSongs(songs: vController.searchedSongs,loading: vController.searchingSongs.value,) : MySongs(songs: vController.mySongs.value),
                )
              ],
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xff141C20)
            ),
            child: Center(
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                       Padding(
                         padding: const EdgeInsets.only(bottom: 20.0),
                         child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                           children: !controller.listening.value  ? [
                           Icon(CupertinoIcons.mic_fill,color: Colors.white,),
                           Text("Tap to Listen",
                             style: GoogleFonts.poppins(
                                 color: Colors.white,
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold
                             ),
                           )
                           ] : [
                            Text("Listening",
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold
                              ),
                            )
                            ],
                         ),
                       ),
                      AvatarGlow(
                        endRadius: 150.0,
                        showTwoGlows: true,
                        animate: controller.listening.value,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        duration: Duration(milliseconds: 1500),
                        child: Material(
                          shape: CircleBorder(),
                          child: InkWell(
                            focusColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: ()async{
                              if(!controller.listening.value) {
                                controller.listen();
                                if(controller.listening.value) await _pc.hide();
                              }
                            },
                            child: Container(
                                width: 150,
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(150),
                                  color: Color(0xff374850),
                                  image: DecorationImage(
                                      image: AssetImage("assets/images/logo.png"),
                                      fit: BoxFit.cover
                                  ),
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Positioned(
                    top:60,
                    right:20,
                    child: !controller.listening.value ? Container() : TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0x141C20FF)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.transparent)
                              )
                          )
                      ),
                      onPressed: (){
                        controller.stopListening();
                        _pc.show();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right:5),
                            child: FaIcon(FontAwesomeIcons.times,size: 18, color: Colors.white,),
                          ),
                          Text("", style: GoogleFonts.poppins(color: Colors.white, fontSize: 15,fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
