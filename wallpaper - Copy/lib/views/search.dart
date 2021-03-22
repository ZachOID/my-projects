import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/widget/widget.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String searchQuery;
  Search({@required this.searchQuery});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
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
    getSearchWallpaers(widget.searchQuery);
    super.initState();
    searchcontroller.text = widget.searchQuery;
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
              Container(
                  decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(40)
                  ),
                  padding: EdgeInsets.symmetric(horizontal : 26),
                  margin: EdgeInsets.symmetric(horizontal : 26),
                  child: Row(children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: searchcontroller,
                        decoration: InputDecoration(
                          hintText: 'search image',
                          border: InputBorder.none
                          ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        getSearchWallpaers(searchcontroller.text);
                        },
                      child: Container(
                        child: Icon(Icons.search)
                        )
                        )
                  ],
                  ),
                ),

              SizedBox(height: 16,),  
              wallpapersList(wallpapers : wallpapers , context: context),
            ],
          )
        ),
      ),
      
    );
  }
}