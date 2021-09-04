import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> loadAsset(file) async {
  return await rootBundle.loadString('assets/text_files/$file');
}

showPermissionDialog(context)async{

  var privacyPolicy = await loadAsset('androidPermission.txt');

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
                  Text("Android 10 or 11 Detected",style: GoogleFonts.poppins(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),
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
                        onTap: ()async{
                          final AndroidIntent intent = AndroidIntent(
                            action: 'action_application_details_settings',
                            data: 'package:com.uta_music_project', // replace com.example.app with your applicationId
                          );
                          await intent.launch();                          Navigator.pop(context);
                        },
                        child: Center(child: Text("Allow",style: GoogleFonts.poppins(color: Colors.deepOrangeAccent,fontSize: 13,fontWeight: FontWeight.w600,),)),
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