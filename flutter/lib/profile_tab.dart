import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';

import 'services/authentication_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:http/http.dart' as http;

final FirebaseAuth auth = FirebaseAuth.instance;
final User user = auth.currentUser;

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String url = "http://192.168.88.244:5000/user/?user_id=${user.uid}";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text(
            "Profile",
            //style: TextStyle(color: Colors.black38),
          ),
          backgroundColor: Colors.lightBlue[800],
          elevation: 0.0,
        ),
        body: data == null
            ? Center(child: Text("Loading.."))
            : Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://i.imgur.com/OqH4GUk.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Colors.black26,
                  child: Stack(
                    children: <Widget>[
                      ClipPath(
                        child: Container(color: Colors.black.withOpacity(0.5)),
                        clipper: GetClipper(),
                      ),
                      Positioned(
                          width: MediaQuery.of(context).size.width,
                          top: MediaQuery.of(context).size.height / 5,
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: 150.0,
                                  height: 150.0,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              'https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.all(Radius.circular(75.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 7.0,
                                            color: Colors.black)
                                      ])),
                              SizedBox(height: 40.0),
                              Text(
                                data[0]["name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat'),
                              ),
                              Container(
                                height: 30,
                              ),
                              Text.rich(
                                TextSpan(
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: data[0]["points"].toString(),
                                    ),
                                    WidgetSpan(
                                      child: FaIcon(
                                        FontAwesomeIcons.paw,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 25.0),
                              SizedBox(height: 25.0),
                              Container(
                                height: 30.0,
                                width: 95.0,
                                child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.redAccent,
                                  color: Colors.red,
                                  elevation: 7.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      context
                                          .read<AuthenticationService>()
                                          .signOut();
                                      Navigator.pop(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Log out',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat'),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ));
  }
}

class GetClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
