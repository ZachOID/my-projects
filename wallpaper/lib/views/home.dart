import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper/data/data.dart';
import 'package:wallpaper/model/categories_model.dart';
import 'package:wallpaper/model/wallpaper_model.dart';
import 'package:wallpaper/views/category.dart';
import 'package:wallpaper/views/search.dart';
import 'package:wallpaper/widget/widget.dart';
import 'package:http/http.dart' as http;

class HOME extends StatefulWidget {
  @override
  _HOMEState createState() => _HOMEState();
}

class _HOMEState extends State<HOME> {

  List<CategoriesModel> categories = new List();
  List<WallpaperModel> wallpapers = new List();
  TextEditingController searchcontroller = new TextEditingController();

  getTrendingWallpaers() async{
    var response = await http.get("https://api.pexels.com/v1/curated?page=1" , 
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
    getTrendingWallpaers();
    categories = getCategories(); 
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
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> Search(
                          searchQuery: searchcontroller.text,
                        )
                      )
                      );
                      },
                    child: Container(
                      child: Icon(Icons.search)
                      )
                      )
                ],),
              ),

              SizedBox(height: 16,),
              Container( 
                height:80,
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return CategoriesTile(
                      title: categories[index].categoriesName,
                      imgUrl: categories[index].imgUrl
                    );
                  }
                  ),
              ),

            SizedBox(height: 16,),  
            wallpapersList(wallpapers : wallpapers , context: context),
            ],
          )),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final imgUrl,title;
  CategoriesTile({@required this.title, @required this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:(){
          Navigator.push(context, MaterialPageRoute(
                        builder: (context)=> Categories(
                          categoryname: title.toLowerCase(),
                        )
                      )
                      );

        },
          child: Container(
        margin: EdgeInsets.only(right:4),
        child: Stack(children: <Widget>[
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imgUrl,height:50 , width: 100, fit: BoxFit.cover)),
          Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            height:50 , width: 100,
            alignment: Alignment.center,
            child: Text(title, style: TextStyle(color:Colors.white, fontWeight:FontWeight.w600, fontSize: 18),),
          )
        ],),
        
      ),
    );
  }
}