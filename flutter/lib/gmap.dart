import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  GMap({Key key}) : super(key: key);

  @override
  _GMapState createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Set<Circle> _circles = HashSet<Circle>();

  GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    _setCircles();
  }

  void _setCircles() {
    _circles.add(
      Circle(
          circleId: CircleId("0"),
          center: LatLng(42.76493, 25.42432),
          radius: 25000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );
    _circles.add(
      Circle(
          circleId: CircleId("0"),
          center: LatLng(41.76493, 25.42432),
          radius: 25000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );
    _circles.add(
      Circle(
          circleId: CircleId("0"),
          center: LatLng(42.76493, 24.42432),
          radius: 25000,
          strokeWidth: 2,
          fillColor: Color.fromRGBO(102, 51, 153, .5)),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Map')),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(42.660668, 25.332699),
              zoom: 6,
            ),
            circles: _circles,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ],
      ),
    );
  }
}
