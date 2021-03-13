import 'package:flutter/material.dart';

class Article extends StatelessWidget {
  const Article({
    this.title,
    this.image,
    this.description,
  });

  final String title;
  final String image;
  final String description;

  Widget _buildBody(context) {
    return Column(
      children: [
        Image.network(
          "http://192.168.88.244:5000/img/" + image,
          height: 220,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(2, 0, 0, 7),
            child: Align(
              alignment: Alignment.bottomRight,
              child:
                  Icon(Icons.favorite_border, size: 30.0, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 7),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontFamily: 'SFNSText',
                      fontWeight: FontWeight.bold,
                      fontSize: 40),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 15, 10),
                  child: Text(description),
                ),
              ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Article",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
      ),
      body: _buildBody(context),
    );
  }
}
