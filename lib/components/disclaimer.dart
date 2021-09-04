import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uta/controllers/disclaimer_controller.dart';
import 'package:uta/services/db_service.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> loadAsset(file) async {
  return await rootBundle.loadString('assets/text_files/$file');
}

void showDisclaimer(context)async{

  var disclaimer = await loadAsset('disclaimer.txt');
  var android10Permission = await loadAsset('androidPermission.txt');
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final dbService = DbService();

  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  int androidSdk = androidInfo.version.sdkInt;
  final _pageViewController = new PageController();
  final _disclaimerController = new DisclaimerController();

  List <Widget> list = <Widget>[];


  List<Widget> slides(){
    list.add(
        Column(
          children: [
            Text("Disclaimer",style: GoogleFonts.poppins(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
            Padding(
              padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
              child: Divider(color: Colors.white24,),
            ),
            Expanded(
              child:  SingleChildScrollView(
                child: Text(disclaimer, style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: ()async{
                  showPrivacyPolicy(context);
                },
                child: Center(child: Text("Privacy Policy",style: GoogleFonts.poppins(color: Colors.deepOrangeAccent,fontSize: 13,fontWeight: FontWeight.w600,),)),
              ),
            ),
          ],
        )
    );

    if(androidSdk > 28){

      _disclaimerController.increaseTabs();

      list.add(
          Column(
            children: [
              Text("Android 10 or 11 Detected",style: GoogleFonts.poppins(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
              Padding(
                padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                child: Divider(color: Colors.white24,),
              ),
              Expanded(
                child:  SingleChildScrollView(
                  child: Text(android10Permission, style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),),
                ),
              ),
              InkWell(
                onTap: ()async{
                 try{
                   await  openAppSettings();
                 }catch(e){
                   print(e);
                 }
                },
                child: Center(child: Text("Allow",style: GoogleFonts.poppins(color: Colors.deepOrangeAccent,fontSize: 13,fontWeight: FontWeight.w600,),)),
              ),
            ],
          )
      );
    }
    return list;
  }
  slides();


  showModalBottomSheet(
    context: context,
    enableDrag: false,
    isDismissible: false,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height:  350,
      decoration: BoxDecoration(
        color: Color(0xff1f2a30),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          topLeft: Radius.circular(20.0),
        )
      ),
      child: Obx(()=>Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (page){
                  _disclaimerController.increasecTabs(page + 1);
                },
                controller: _pageViewController,
                itemCount: list.length,
                itemBuilder: (c,index){
                  return list[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
              child: Divider(color: Colors.white24,),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${_disclaimerController.currentTab.value} / ${_disclaimerController.tabs.value}",style: GoogleFonts.poppins(color: Colors.deepOrangeAccent,fontSize: 13,fontWeight: FontWeight.w600,)),
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: _disclaimerController.currentTab.value == 1 ? Colors.deepOrangeAccent : Colors.black54,
                        borderRadius: BorderRadius.circular(5)
                      ),
                    ),
                    if(_disclaimerController.tabs.value == 2) Container(
                      margin: EdgeInsets.only(left: 5),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          color: _disclaimerController.currentTab.value == 2 ? Colors.deepOrangeAccent : Colors.black54,
                          borderRadius: BorderRadius.circular(5)
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: ()async{
                    //agree to out service
                    if(_disclaimerController.currentTab.value == 2 || _disclaimerController.tabs.value == 1){
                      await dbService.initDb();
                      await dbService.agreeToOurService();
                      Navigator.pop(context);
                    }else{
                      _pageViewController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Center(child: Text(_disclaimerController.tabs.value == 1 ? "I Agree" : _disclaimerController.currentTab.value == 1 ? "Next" : "Agree",style: GoogleFonts.poppins(color: Colors.deepOrangeAccent,fontSize: 13,fontWeight: FontWeight.w600,),)),
                ),
              ],
            )
          ],
        ),
      )),
    ),
  );
}


showPrivacyPolicy(context)async{
  var privacyPolicy = await loadAsset('privacy_policy.txt');

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Color(0xff1f2a30),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height:  400,
            decoration: BoxDecoration(
                color: Color(0xff1f2a30),
                borderRadius: BorderRadius.circular(20)
            ),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Privacy Policy",style: GoogleFonts.poppins(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                    child: Divider(color: Colors.white24,),
                  ),
                  Expanded(
                    child:  SingleChildScrollView(
                      child: Text(privacyPolicy, style: GoogleFonts.poppins(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w400),),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:8.0,bottom: 8.0),
                    child: Divider(color: Colors.white24,),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Center(child: Text("Okay",style: GoogleFonts.poppins(color: Colors.deepOrangeAccent,fontSize: 13,fontWeight: FontWeight.w600,),)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}