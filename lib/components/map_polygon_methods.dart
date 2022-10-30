import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_utils/google_maps_utils.dart';
import 'package:helloworld/pages/flight_area_page.dart';

List<List<LatLng>> polygonPoints = [
  <LatLng>[
    LatLng(36.6783, 126.4955),
    LatLng(36.7004, 126.5147),
    LatLng(36.7247, 126.5089),
    LatLng(36.7274, 126.4699),
    LatLng(36.7026, 126.4592),
    LatLng(36.6815, 126.467),
    LatLng(36.6783, 126.4955),
  ],
  <LatLng>[
    LatLng(36.7007, 126.5772),
    LatLng(36.6759, 126.5874),
    LatLng(36.645, 126.6181),
    LatLng(36.6605, 126.6584),
    LatLng(36.7125, 126.6629),
    LatLng(36.7257, 126.6107),
  ],
];

List<Point> polygonLatLngtoPoint(List<LatLng> polygonLatLng) {
  List<Point> result = [];
  for (int i = 0; i < polygonLatLng.length; i++) {
    result.add(Point(polygonLatLng[i].latitude, polygonLatLng[i].longitude));
  }
  return result;
}

bool circlePolygonIsOverlapped() {
  Point currentPoint =
      Point(currentLocation.latitude, currentLocation.longitude);

  double distanceToPolygon = 9999999999999;
  for (int p = 0; p < polygonPoints.length; p++) {
    List<LatLng> currentPolygon = polygonPoints[p];
    if (PolyUtils.containsLocationPoly(
        currentPoint, polygonLatLngtoPoint(currentPolygon))) {
      return true;
    }
    for (int i = 0; i < currentPolygon.length - 1; i++) {
      Point from =
          Point(currentPolygon[i].latitude, currentPolygon[i].longitude);
      Point to = Point(
          currentPolygon[i + 1].latitude, currentPolygon[i + 1].longitude);
      if (distanceToPolygon >
          PolyUtils.distanceToLine(currentPoint, from, to)) {
        distanceToPolygon = PolyUtils.distanceToLine(currentPoint, from, to);
      }
    }
  }

  if (double.parse(controllerDistance.text) > distanceToPolygon) {
    return true;
  } else {
    return false;
  }
}
