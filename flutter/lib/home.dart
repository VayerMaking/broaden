import 'dart:convert';

import 'package:broaden/leaderboard.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'article_screen.dart';

import 'services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String url = "http://192.168.88.244:5000/news";
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
    return SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          onTap: () => Navigator.of(context).push<void>(
            MaterialPageRoute(
              builder: (context) => Article(
                title: data[index]["title"],
                image: data[index]["image"],
                description:
                    "Nullam dictum consectetur porttitor. Phasellus cursus, justo quis sagittis luctus, tellus erat laoreet arcu, quis condimentum lorem mi at orci.",
              ),
            ),
          ),
          child: Center(
            child: Padding(
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
                          image: NetworkImage(
                              "http://192.168.88.244:5000/img/" +
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
            ),
          ),
        ));
  }

  Widget _buildHomepage() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: data == null ? 0 : data.length,
        itemBuilder: (context, index) {
          return _buildArticle(index);
        },
      ),
    );
  }

  Widget _buildLeaderBoard() {
    return data == null
        ? null
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () => {
                Navigator.of(context).push<void>(
                  MaterialPageRoute(builder: (context) => LeaderBoard()),
                ),
              },
              child: Container(
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.lightBlue[800],
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 400,
                      child: Stack(
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            child: Text(
                              "Leaderboard",
                              style: TextStyle(
                                  color: Colors.white,
                                  //fontWeight: FontWeight.bold,
                                  fontSize: 30),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.leaderboard,
                              size: 80,
                              color: Colors.white,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                "compete with other people\nand win prizes!",
                                style: TextStyle(
                                    color: Colors.white,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: data == null
          ? Center(child: Text("Loading.."))
          : ListView(
              children: [
                _buildLeaderBoard(),
                _buildHomepage(),
              ],
            ),
    );
  }
}
