import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../pages/flight_area_page.dart';
import '../styles.dart';
import 'map_polygon_methods.dart';

late final GoogleMapController requestPageGoogleMapController;

class RequestPageMap extends StatefulWidget {
  _RequestPageMapState createState() => _RequestPageMapState();
}

class _RequestPageMapState extends State<RequestPageMap> {
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < polygonPoints.length; i++) {
      polygons.add(Polygon(
        polygonId:
            PolygonId('polygon_id_${DateTime.now().millisecondsSinceEpoch}'),
        points: polygonPoints[i],
        fillColor: Colors.red.withOpacity(0.3),
        strokeColor: Colors.red,
        geodesic: true,
        strokeWidth: 2,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '비행반경',
              style: overLine(),
            ),
          ),
          SizedBox(height: 5),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                requestPageGoogleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 16,
              ),
              markers: markers,
              circles: circles,
              polygons: polygons,
            ),
          ),
        ],
      ),
    );
  }
}
