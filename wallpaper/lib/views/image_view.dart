
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';


class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({@required this.imgUrl});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  var filePath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Hero(
            tag: widget.imgUrl,
                      child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,            
              child: Image.network(widget.imgUrl,fit: BoxFit.cover)),
          ),

            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,  
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: (){
                      _save();
                    },
                    child: Stack(
                        children: <Widget>[
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width/2.5,
                            
                            decoration: BoxDecoration(
                              color: Color(0xff1c1b1b).withOpacity(0.8),
                              borderRadius: BorderRadius.circular(80),
                            ),
                          ),
                          Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width/2.5,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38,width: 1),
                          borderRadius: BorderRadius.circular(80),
                          gradient: LinearGradient(
                            colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ]
                          )
                        ),
                        child: Column(
                          
                          children: <Widget>[
                            Text("Save Wallpaper",style: TextStyle(fontSize: 20, color: Colors.white60),)
                          ],
                        ) ,
                      ),
 
                        ],
                     ),
                  ),
                  SizedBox(height: 16,),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);
                    },
                    child: Text("cancel", style:TextStyle(color: Colors.white70, fontSize: 20),)),
                  SizedBox(height: 50,)
                ],
              ),
            )
        ],
      ),
    );
  }
   _save() async {
    if (Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(widget.imgUrl,
        options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    // Navigator.pop(context);
  }




  _askPermission() async {
    if (Platform.isIOS) {
      /*Map<PermissionGroup, PermissionStatus> permissions =
          */await PermissionHandler()
              .requestPermissions([PermissionGroup.photos]);
    } else {
     /* PermissionStatus permission = */await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
    }
  }
}

class PermissionsService {


  final PermissionHandler _permissionHandler = PermissionHandler();

   Future<bool> _requestPermission(PermissionGroup permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      print('innnn');
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission({Function onPermissionDenied} ) async {
    // return _requestPermission(PermissionGroup.locationWhenInUse);
    var granted = await _requestPermission(PermissionGroup.location );
    if(!granted){
      onPermissionDenied();
    }
    return granted;
  }
}


