class WallpaperModel{
  String photographer;
  String photographerurl;
  int photographerid;
  SrcModel src;

  WallpaperModel({this.src,this.photographerid,this.photographer,this.photographerurl});
  factory WallpaperModel.fromMap(Map<String,dynamic>jsonData){
    return WallpaperModel(
      src: SrcModel.fromMap(jsonData["src"]),
      photographerurl: jsonData["photographer_url"],
      photographerid: jsonData["photographer_id"],
      photographer: jsonData["photographer"],
    );
}
}

class SrcModel{

  String original,small,portrait;

  SrcModel({this.original,this.portrait,this.small});
  factory SrcModel.fromMap(Map<String,dynamic>jsonData){
    return SrcModel(
      portrait: jsonData["portrait"],
      original: jsonData["original"],
      small: jsonData["small"]
    );
  }
}
