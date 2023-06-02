import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';
import 'package:csv/csv.dart';
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenStreetMap'),
      ),
      body: FutureBuilder<List<LatLng>>(
        future: getGeoPointsFromCSV(context),
        builder: (BuildContext context, AsyncSnapshot<List<LatLng>> snapshot) {
          if (snapshot.hasData) {
            List<LatLng> geoPoints = snapshot.data!;

            return FlutterMap(
              options: MapOptions(
                center: LatLng(51.509364, -0.128928),
                zoom: 9.2,
              ),
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: geoPoints.map((LatLng point) {
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
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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
}
