import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:helloworld/components/flight_area_info.dart';

LatLng currentLocation = LatLng(37.5651, 126.98955);
final Set<Marker> markers = {};
final Set<Circle> circles = {};

class FlightAreaPage extends StatefulWidget {
  @override
  State<FlightAreaPage> createState() => _FlightAreaPageState();
}

class _FlightAreaPageState extends State<FlightAreaPage> {
  void _updatePosition(CameraPosition position) {
    currentLocation =
        LatLng(position.target.latitude, position.target.longitude);
  }

  void _addMarker() {
    setState(() {
      markers.clear();
      circles.clear();
      markers.add(
        Marker(
          markerId: MarkerId(currentLocation.toString()),
          position: currentLocation,
          icon: BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(
            title: '주소',
            snippet: '비행 반경',
          ),
        ),
      );
      circles.add(
        Circle(
          circleId:
              CircleId('circle_id_${DateTime.now().millisecondsSinceEpoch}'),
          center: currentLocation,
          fillColor: Colors.blue.shade100.withOpacity(0.5),
          strokeColor: Colors.blue.shade100.withOpacity(0.1),
          radius: 200,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: currentLocation,
                    zoom: 16,
                  ),
                  markers: markers,
                  circles: circles,
                  onCameraMove: ((position) => _updatePosition(position)),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 24, right: 12),
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _addMarker,
                        backgroundColor: Colors.deepPurpleAccent,
                        child: const Icon(Icons.add_location, size: 36.0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: FlightAreaInfo(),
          )
        ],
      ),
    );
  }
}
