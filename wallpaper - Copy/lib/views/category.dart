import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/widget/widget.dart';

class Categories extends StatefulWidget {

  final String categoryname;
  Categories({this.categoryname});

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {

  List<WallpaperModel> wallpapers = new List();
 TextEditingController searchcontroller = new TextEditingController();


  getSearchWallpaers(String query) async{
    var response = await http.get("https://api.pexels.com/v1/search?query=$query" , 
      headers: {
        "Authorization" : apiKey
      }
    );

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      WallpaperModel wallpaperModel = new WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpapers.add(wallpaperModel);
    });

    setState(() {});

  }

  @override
  void initState() {
    getSearchWallpaers(widget.categoryname);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: brandName(),
        elevation: 0.0,
      ),

      body: SingleChildScrollView(
        child: Container(
          child : Column(
            children: <Widget>[
              SizedBox(height: 16,),  
              wallpapersList(wallpapers : wallpapers , context: context),
            ],
          )
        ),
      ),
      
    );

  }
}