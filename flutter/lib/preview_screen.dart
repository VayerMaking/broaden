import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:async/async.dart';
import 'package:broaden/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

class PreviewScreen extends StatefulWidget {
  final String imgPath;

  PreviewScreen({this.imgPath});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

upload(File imageFile) async {
  Location location = new Location();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser;

  LocationData _locationData;
  // open a bytestream
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  var uri = Uri.parse("http://192.168.88.244:5000/upload");

  // create multipart request
  var request = new http.MultipartRequest("POST", uri);

  // multipart that takes file
  var multipartFile = new http.MultipartFile('image', stream, length,
      filename: basename(imageFile.path));

  _locationData = await location.getLocation();
  // add file to multipart
  request.files.add(multipartFile);
  request.fields['user_id'] = user.uid;
  request.fields['user_email'] = user.email;
  request.fields['lat'] = _locationData.latitude.toString();
  request.fields['log'] = _locationData.longitude.toString();
  // send
  var response = await request.send();
  print(response.statusCode);
  if (response.statusCode == 200) {
    PopUp();
  }

  // listen for response
  response.stream.transform(utf8.decoder).listen((value) {
    print(value);
  });
}

class _PreviewScreenState extends State<PreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Image.file(
                File(widget.imgPath),
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 60.0,
                color: Colors.black,
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      upload(File(widget.imgPath));
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<ByteData> getBytesFromFile() async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
    return ByteData.view(bytes.buffer);
  }
}
