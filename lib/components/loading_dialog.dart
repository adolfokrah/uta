import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uta/controllers/downloader_controller.dart';

class LoadingDialog{

  final DownloaderController controller = Get.find();
  showProgressDialogue(BuildContext context) {
    //set up the AlertDialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: new CircularProgressIndicator(),
                ),
                Container(
                  child: Obx(()=>controller.converting.value ? new Text("Converting file...") : new Text("Downloading... ${controller.downloadProgress}")),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}