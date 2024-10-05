import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Home extends StatefulWidget {
  final double lat;
  final double long;

  const Home({super.key, required this.lat, required this.long});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String mapStyle = 'Default';

  // URL templates for different map views
  Map<String, String> mapUrls = {
    'Default': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    'Satellite': 'https://mt1.google.com/vt/lyrs=s&x={x}&y={y}&z={z}',
    'Terrain': 'https://mt1.google.com/vt/lyrs=p&x={x}&y={y}&z={z}',
  };

  void switchMapStyle(String style) {
    setState(() {
      mapStyle = style;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: LatLng(widget.lat, widget.long),
              initialZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: mapUrls[mapStyle]!,
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(widget.lat, widget.long),
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //  Default view
                FloatingActionButton(
                  heroTag: 'defaultBtn',
                  onPressed: () => switchMapStyle('Default'),
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.map),
                ),
                const SizedBox(height: 10),
                //  Satellite view
                FloatingActionButton(
                  heroTag: 'satelliteBtn',
                  onPressed: () => switchMapStyle('Satellite'),
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.satellite),
                ),
                const SizedBox(height: 10),
                //  Terrain view
                FloatingActionButton(
                  heroTag: 'terrainBtn',
                  onPressed: () => switchMapStyle('Terrain'),
                  backgroundColor: Colors.orange,
                  child: const Icon(Icons.terrain),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
