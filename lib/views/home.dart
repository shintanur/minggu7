import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:minggu7/data/data.dart';
import 'package:http/http.dart' as http;
import 'package:minggu7/views/search.dart';
import '../model/categories_model.dart';
import '../model/photo_model.dart';
import '../widgets/widget.dart';
import 'categorie.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = new TextEditingController();

  ScrollController _scrollController = new ScrollController();

  List<CategorieModel> categories = [];
  List<photoModel> photo = [];

  void initState() {
    getTrendingWallpaper();
    categories = getCategories();
    super.initState();
  }

  getTrendingWallpaper() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=15&page=1"),
        headers: {"Authorization": apiKEY}).then((value) {
      Map<String, dynamic> jsonData = jsonDecode(value.body);
      jsonData["photos"].forEach((element) {
        photoModel wallpaperModel = new photoModel();
        wallpaperModel = photoModel.fromMap(element);
        photo.add(wallpaperModel);
      });

      setState(() {});
    });
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
            child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 224, 230, 241),
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                          hintText: "Search", border: InputBorder.none),
                    ),
                  ),
                  GestureDetector(
                      onTap: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Search(
                                      search: _searchController.text,
                                    )));
                      }),
                      child: Container(child: Icon(Icons.search))),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 80,
              child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return CategoriesTile(
                      title: categories[index].categorieName.toString(),
                      imgUrl: categories[index].imgUrl.toString(),
                    );
                  }),
            ),
            SizedBox(
              height: 16,
            ),
            WallpapersList(wallpapers: photo, context: context),
          ],
        )),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  final String imgUrl, title;

  CategoriesTile({required this.imgUrl, required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(
                      categorieName: title.toLowerCase(),
                    )));
      }),
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imgUrl,
                height: 50,
                width: 100,
                fit: BoxFit.cover,
              )),
          Container(
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            height: 50,
            width: 100,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16),
            ), // Gejlas
          )
        ]),
      ),
    );
  }
}