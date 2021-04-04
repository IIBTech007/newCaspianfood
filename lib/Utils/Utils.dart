import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:translator/translator.dart';

class Utils{
   static String baseUrl(){
     //return "http://192.236.147.77:9000/api/";
     return "http://rajah786-001-site1.gtempurl.com/api/";
     //     return "http://hiuhcs.com/api/";
   }
   static bool validateStructure(String value){
     RegExp regExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{6,}$');
     return regExp.hasMatch(value);
   }
   static bool validateEmail(String value){
     RegExp regExp=  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
     return regExp.hasMatch(value);
   }
   static Future<bool> check_connectivity () async{
     bool result = await DataConnectionChecker().hasConnection;
     return result;
   }
   static dynamic myEncode(dynamic item){
     if(item is DateTime)
       return item.toIso8601String();
   }
   static void showSuccess(BuildContext context,String message){
     Flushbar(
       backgroundColor: Colors.green,
       duration: Duration(seconds: 3),
       message: message,
     ).show(context);

   }
   static void showError(BuildContext context,String message){
     Flushbar(
       backgroundColor: Colors.red,
       duration: Duration(seconds: 3),
       message: message,
     ).show(context);

   }
   static Map<String, dynamic> parseJwt(String token) {
     final parts = token.split('.');
     if (parts.length != 3) {
       throw Exception('invalid token');
     }

     final payload = _decodeBase64(parts[1]);
     final payloadMap = json.decode(payload);
     if (payloadMap is! Map<String, dynamic>) {
       throw Exception('invalid payload');
     }

     return payloadMap;
   }
   static String _decodeBase64(String str) {
     String output = str.replaceAll('-', '+').replaceAll('_', '/');

     switch (output.length % 4) {
       case 0:
         break;
       case 2:
         output += '==';
         break;
       case 3:
         output += '=';
         break;
       default:
         throw Exception('Illegal base64url string!"');
     }

     return utf8.decode(base64Url.decode(output));
   }

   static Future<String> translate(String input)async{
     final translator=GoogleTranslator();
     var trans=await translator.translate(input,to:"en");
    return trans.text;
   }
   static Future<File> getImage() async {
     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     return image;
   }
   static void shareImage(BuildContext context,Uint8List pngBytes) async{
     try{
       var rng = new Random();

       Directory tempDir = await getTemporaryDirectory();

       String tempPath = tempDir.path;

       File file = new File('$tempPath'+ (rng.nextInt(10000)).toString() +'.png');

       await file.writeAsBytes(pngBytes);
       Share.shareFiles([file.path], text:"Please Scan this qr code to get details");
     }catch(e){
       showError(context,e.toString());
     }
   }
}