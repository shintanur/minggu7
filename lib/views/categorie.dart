import 'package:flutter/material.dart';
import 'package:minggu7/model/photo_model.dart';
import 'package:http/http.dart' as http;
import 'package:minggu7/widgets/widget.dart';
import 'dart:convert';
import 'package:minggu7/data/data.dart';

class Categorie extends StatefulWidget {
  final String categorieName;
  Categorie({required this.categorieName});
  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  List<photoModel> photo = [];

  getSearchWallpapers(String query) async{
    var response = await http.get(Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=15&page=1"), 
    headers: {"Authorization": apiKEY});

    // print(response.body.toString());

    Map<String,dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element){
      // print(element);
      photoModel wallpaperModel = new photoModel();
      wallpaperModel = photoModel.fromMap(element);
      photo.add(wallpaperModel);
    });

    setState(() {
      
    });
  }
  
  @override
  void initState() {
    getSearchWallpapers(widget.categorieName);
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: brandName(),
          elevation: 0.0,
        ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 16,
                ),
                
              ],
            )
        ),
      )
    );
  }
}