
import 'package:get/get.dart';


class VideosController extends GetxController{
  var suggestedSongs = [].obs;
  var searchedSongs = [].obs;
  var mySongs = [].obs;
  var searchingSongs = false.obs;

  setSuggestedSongs(songs){
    suggestedSongs.value = songs;
  }
  setSearchedSongs(songs){
    searchedSongs.value = songs;
  }
  setMySongs(songs){
    mySongs.value = songs;
  }
  toggleSearchingSong()=> searchingSongs.value = !searchingSongs.value;

}