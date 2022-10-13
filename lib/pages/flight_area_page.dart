import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../components/custom_text_field.dart';
import '../styles.dart';

final controllerDistance = TextEditingController();
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

  void _addMarkerCircle() {
    setState(() {
      markers.clear();
      circles.clear();
      markers.add(
        Marker(
          markerId:
              MarkerId('marker_id_${DateTime.now().millisecondsSinceEpoch}'),
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
          radius: controllerDistance.text.isEmpty
              ? double.parse('200')
              : double.parse(controllerDistance.text),
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
                        onPressed: _addMarkerCircle,
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
            child: _buildFlightAreaInfo(),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightAreaInfo() {
    return Column(
      children: [
        _buildRadiusTextField(),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("비행반경 저장"),
        ),
      ],
    );
  }

  Widget _buildRadiusTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '비행 반경(km)',
              style: overLine(),
            ),
          ),
          SizedBox(height: 5),
          TextFormField(
            controller: controllerDistance,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
              hintText: '숫자만 입력',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
