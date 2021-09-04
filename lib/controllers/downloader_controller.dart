
import 'package:get/get.dart';


class DownloaderController extends GetxController{
  var converting = false.obs;
  var downloading = false.obs;
  var downloadProgress = "".obs;
  var downloadFinished = false.obs;

  toggleDownloading(newValue){
    downloading.value = newValue;
  }

  toggleDownloadFinish(newValue){
    downloadFinished.value = newValue;
  }

  toggleConverting(newValue){
    converting.value = newValue;
  }

  increaseProgress(newValue){
    downloadProgress.value = newValue;
  }
}