import 'dart:io';
import 'package:dio/dio.dart';

class AcrCloud{

  identify(uri)async{

    var file = File(uri);
    var data = {
      "recording":await MultipartFile.fromFile(file.path, filename:"record.m4a")
    };

    FormData formData = FormData.fromMap(data);

    var response = await Dio().post("https://apis.okuafopa.com/uta/index.php", data: formData);

    return response.data;
  }
}