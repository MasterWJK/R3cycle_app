import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:http/http.dart';
import 'package:http/src/base_client.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:vector_math/vector_math.dart' show radians;

import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _currentLocation = LatLng(0, 0); // Default location

  // static const styleUrl =
  //     "https://tiles.stadiamaps.com/tiles/osm_bright/{z}/{x}/{y}.png";
  static const styleUrl =
      "https://tiles.stadiamaps.com/tiles/alidade_smooth/{z}/{x}/{y}.png";
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
        timeLimit: const Duration(seconds: 20),
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
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
                    // TileLayer(
                    //   urlTemplate:
                    //       "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    //   maxZoom: 20,
                    //   maxNativeZoom: 20,
                    // ),

                    TileLayer(
                      urlTemplate: "$styleUrl?api_key={api_key}",
                      additionalOptions: const {"api_key": apiKey},
                      maxZoom: 20,
                      maxNativeZoom: 20,
                      tileProvider: FMTC.instance('mapStore').getTileProvider(
                          // FMTC.instance.settings.defaultTileProviderSettings,
                          // {},
                          // HttpClient()..maxConnectionsPerHost = 3,
                          ),
                    ),

                    // MarkerLayer(
                    //   markers: [
                    //     ...geoPoints.map((LatLng point) {
                    //       return Marker(
                    //         point: point,
                    //         rotate: true,
                    //         builder: (BuildContext context) {
                    //           return Image.asset("assets/pickup.png");
                    //           // return Icon(
                    //           //   Icons.location_pin,
                    //           //   color: Colors.red,
                    //           // );
                    //         },
                    //       );
                    //     }).toList(),
                    //   ],
                    // ),
                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        disableClusteringAtZoom: 14,
                        maxClusterRadius: 120,
                        size: const Size(40, 40),
                        anchor: AnchorPos.align(AnchorAlign.center),
                        fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(20),
                          maxZoom: 20,
                        ),
                        markers: geoPoints.map((LatLng point) {
                          return Marker(
                            width: 38,
                            height: 38,
                            point: point,
                            builder: (BuildContext context) {
                              return Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 3,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                                child:
                                    Image.asset("assets/pickup_drop_green.png"),
                              );
                            },
                          );
                        }).toList(),
                        builder: (context, markers) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF054F46),
                            ),
                            child: Center(
                              child: Text(
                                markers.length.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    CurrentLocationLayer(
                        followOnLocationUpdate: FollowOnLocationUpdate.always,
                        turnOnHeadingUpdate: TurnOnHeadingUpdate.never,
                        style: const LocationMarkerStyle(
                          markerSize: Size(20, 20),
                          markerDirection: MarkerDirection.heading,
                          headingSectorColor: Color(0xFF4185F4),
                          marker: DefaultLocationMarker(
                            color: Color(0xFF4185F4),
                          ),
                        )),
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
      String urlAltkleider = row[2]; // Assuming the column index is 5

      if (urlAltkleider == "awm@muenchen.de") {
        // Extract the coordinates from the "shape" column
        RegExp regex = RegExp(r'POINT \(([-0-9.]+) ([-0-9.]+)\)');
        Match? match = regex.firstMatch(shape);
        if (match != null && match.groupCount == 2) {
          double x =
              double.tryParse(match.group(1)!)!; // X coordinate in EPSG:25832
          double y =
              double.tryParse(match.group(2)!)!; // Y coordinate in EPSG:25832

          // Convert coordinates from EPSG:25832 to WGS84 (latitude and longitude)
          proj4.Projection srcProjection;
          if (proj4.Projection.get('EPSG:25832') == null) {
            srcProjection = proj4.Projection.add('EPSG:25832', wfsProjection);
          } else {
            srcProjection = proj4.Projection.get('EPSG:25832')!;
          }
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
    }
    return geoPoints;
  }
}
