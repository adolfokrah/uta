import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uta/pages/HomePage.dart';

void main() => runApp(
    GetMaterialApp(
      theme: ThemeData(
          primaryColor: Color(0xff1f2a30),
          secondaryHeaderColor:  Color(0xff1f2a30),
          accentColor: Color(0xff1f2a30),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    )
);