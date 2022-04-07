import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minggu7/data/data.dart';
import '../model/photo_model.dart';
import '../widgets/widget.dart';


class Search extends StatefulWidget {
  final String search;
  Search({required this.search});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  List<photoModel> photo = [];

  getSearchWallpapers(String query) async {
    var response = await http.get(
        Uri.parse(
            "https://api.pexels.com/v1/search?query=$query&per_page=15&page=1"),
        headers: {"Authorization": apiKEY});

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      photoModel photosModel = new photoModel();
      photosModel = photoModel.fromMap(element);
      photo.add(photosModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getSearchWallpapers(widget.search);
    super.initState();
    search.text = widget.search;
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
              Container(
                decoration: BoxDecoration(
                    color: Color(0xfff5f8fd),
                    borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                margin: EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: search,
                        decoration: InputDecoration(
                            hintText: "Search Wallpaper",
                            border: InputBorder.none),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        getSearchWallpapers(search.text);
                      },
                      child: Container(child: Icon(Icons.search)),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              WallpapersList(wallpapers: photo, context: context),
            ],
          ),
        ),
      ),
    );
  }
}