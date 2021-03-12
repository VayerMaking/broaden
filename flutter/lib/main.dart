import 'package:broaden/gmap.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Broaden',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[800],
        accentColor: Colors.cyan[600],
      ),
      home: MyHomePage(title: 'Broaden'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  void _getLocationPermission() async {
    var location = new Location();
    try {
      location.requestPermission();
    } on Exception catch (_) {
      print('There was a problem allowing location permission.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: _buildHomepage(),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.map),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GMap()),
        ),
      ),
    );
  }

  Widget _buildArticle(index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildHomepage() {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildArticle(index);
        },
      ),
    );
  }
}
