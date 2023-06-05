import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:vector_math/vector_math.dart' show radians;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentLocation = LatLng(0, 0); // Default location

  static const styleUrl =
      "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}@2x.png";
  static const apiKey = "c4fea2da-4a39-4b31-8ab8-736e60c3dc2c";

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        return Future.error('Location services are disabled.');
      } else
        print('Location services are enabled.');
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied, next time you could try
          // requesting permissions again (this is also where
          // Android's shouldShowRequestPermissionRationale
          // returned true. According to Android guidelines
          // your App should show an explanatory UI now.
          return Future.error('Location permissions are denied');
        }
      }
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position.heading);
      print(position.latitude);
      setState(() {
        _currentLocation = LatLng(position.latitude,
            position.longitude); // Update the current heading
      });
      // setState(() {
      //   print(position.latitude);
      //   _currentLocation = LatLng(position.latitude, position.longitude);
      // });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<LatLng>>(
            future: getGeoPointsFromCSV(context),
            builder:
                (BuildContext context, AsyncSnapshot<List<LatLng>> snapshot) {
              if (snapshot.hasData) {
                List<LatLng> geoPoints = snapshot.data!;

                return FlutterMap(
                  options: MapOptions(
                    center:
                        _currentLocation, // Use the current location as the center
                    zoom: 16,
                  ),
                  nonRotatedChildren: [
                    RichAttributionWidget(
                      attributions: [
                        TextSourceAttribution(
                          'OpenStreetMap contributors',
                          onTap: () => launchUrl(
                            Uri.parse('https://openstreetmap.org/copyright'),
                          ),
                        ),
                      ],
                    ),
                  ],
                  children: [
                    TileLayer(
                      // urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      urlTemplate: "$styleUrl?api_key={api_key}",
                      additionalOptions: {"api_key": apiKey},
                      maxZoom: 20,
                      maxNativeZoom: 20,
                    ),
                    MarkerLayer(
                      markers: [
                        ...geoPoints.map((LatLng point) {
                          return Marker(
                            point: point,
                            builder: (BuildContext context) {
                              return Icon(
                                Icons.location_pin,
                                color: Colors.red,
                              );
                            },
                          );
                        }).toList(),
                      ],
                    ),
                    CurrentLocationLayer(
                      followOnLocationUpdate: FollowOnLocationUpdate.always,
                      turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                      style: const LocationMarkerStyle(
                        markerSize: Size(20, 20),
                        markerDirection: MarkerDirection.heading,
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Color(0xFF1C292D).withOpacity(0.6),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_rounded, // Material back arrow icon
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pop(); // Go back when the back arrow is pressed
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () {
                      // Handle "How it works" button press
                    },
                    child: const Row(
                      children: [
                        Text(
                          'How it works',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -0.02,
                          ),
                        ),
                        SizedBox(
                            width: 8), // Add spacing between the text and icon
                        Icon(
                          Icons.info_rounded, // Info icon
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<LatLng>> getGeoPointsFromCSV(context) async {
    String csvData = await DefaultAssetBundle.of(context)
        .loadString('assets/awm_container_opendata.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(csvData);

    final String wfsProjection =
        '+proj=utm +zone=32 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs +type=crs';
    final String wgs84Projection =
        '+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs';

    List<LatLng> geoPoints = [];
    for (var row in csvTable) {
      String shape = row[12];

      // Extract the coordinates from the "shape" column
      RegExp regex = RegExp(r'POINT \(([-0-9.]+) ([-0-9.]+)\)');
      Match? match = regex.firstMatch(shape);
      if (match != null && match.groupCount == 2) {
        double x =
            double.tryParse(match.group(1)!)!; // X coordinate in EPSG:25832
        double y =
            double.tryParse(match.group(2)!)!; // Y coordinate in EPSG:25832

        // Convert coordinates from EPSG:25832 to WGS84 (latitude and longitude)
        proj4.Projection srcProjection =
            proj4.Projection.add('EPSG:25832', wfsProjection);
        proj4.Projection dstProjection = proj4.Projection.get('EPSG:4326')!;
        proj4.Point point = proj4.Point(x: x, y: y);
        proj4.Point transformedPoint =
            srcProjection.transform(dstProjection, point);
        double lat = transformedPoint.y;
        double lng = transformedPoint.x;

        LatLng latLng = LatLng(lat, lng);
        geoPoints.add(latLng);
      }
    }

    return geoPoints;
  }

  Marker _buildUserMarker() {
    return Marker(
      width: 40,
      height: 40,
      point: _currentLocation,
      builder: (ctx) => Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            child: Icon(
              Icons.circle,
              color: Colors.blue,
            ),
          ),
          Positioned(
            top: 14,
            child: Container(
              width: 0,
              height: 0,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Transform.rotate(
                angle: -radians(90),
                child: Icon(
                  Icons.near_me_rounded,
                  color: Colors.blue,
                  size: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
