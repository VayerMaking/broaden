import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// TODO: Change font

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String url = "http://192.168.88.246:5000/news";
  List data;

  @override
  void initState() {
    super.initState();

    getJSONData();
  }

  Future<String> getJSONData() async {
    var response = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    print(response.body);
    debugPrint(response.body);

    setState(() {
      var convertDataToJson = json.decode(response.body);
      data = convertDataToJson;
    });

    return "Success";
  }

  Widget _buildArticle(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        height: 100,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Image(
                  width: 150,
                  height: 100,
                  fit: BoxFit.cover,
                  image: NetworkImage("http://192.168.88.246:5000/img/" +
                      data[index]["image"])),
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: Container(
                width: 130,
                child: Text(data[index]["title"]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomepage() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return _buildArticle(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: data == null ? Center(child: Text("Loading..")) : _buildHomepage(),
    );
  }
}
