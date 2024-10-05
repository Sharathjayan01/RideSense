import 'dart:convert';
import 'package:app/home.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController locationController = TextEditingController();
  String lat = '';
  String long = '';
  double lat1 = 0;
  double long1 = 0;
  bool isFetchingLocation = false;
  bool isSubmitting = false;

  Future<void> submit(BuildContext context) async {
    setState(() {
      isSubmitting = true;
    });

    String locationInput = locationController.text;

    if (locationInput.isEmpty && (lat.isEmpty || long.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a location or use "Get Location".'),
        ),
      );
      setState(() {
        isSubmitting = false;
      });
      return;
    }

    String url;
    if (locationInput.isNotEmpty) {
      // Use geocoding API for user-inputted location
      url =
          "https://api.geoapify.com/v1/geocode/search?text=${Uri.encodeComponent(locationInput)}&apiKey=142bc5950e6e484a8e371b494c7e6dfc";
    } else {
      // Use reverse geocoding API for the fetched location
      url =
          "https://api.geoapify.com/v1/geocode/reverse?lat=$lat&lon=$long&apiKey=142bc5950e6e484a8e371b494c7e6dfc";
    }

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        double extractedLat =
            data['features'][0]['geometry']['coordinates'][1]; // Latitude
        double extractedLon =
            data['features'][0]['geometry']['coordinates'][0]; // Longitude

        setState(() {
          lat1 = extractedLat;
          long1 = extractedLon;
        });

        print('Extracted Latitude: $lat1, Longitude: $long1');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Request failed with status: ${response.statusCode}'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error during the API call: $e')),
      );
    }

    setState(() {
      isSubmitting = false;
    });

    if (locationInput.isEmpty) {
      // Use the lat and long obtained from getLocation
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            lat: double.parse(lat),
            long: double.parse(long),
          ),
        ),
      );
    } else {
      // Use the lat and long obtained from reverse geocoding
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(
            lat: lat1,
            long: long1,
          ),
        ),
      );
    }
  }

  void getLocation(BuildContext context) async {
    setState(() {
      isFetchingLocation = true;
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services.')),
      );
      await Geolocator.openLocationSettings();
      setState(() {
        isFetchingLocation = false;
      });
      return;
    }

    PermissionStatus permissionStatus =
        await Permission.locationWhenInUse.status;
    if (permissionStatus.isDenied || permissionStatus.isPermanentlyDenied) {
      permissionStatus = await Permission.locationWhenInUse.request();
      if (permissionStatus.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permission denied.')),
        );
        setState(() {
          isFetchingLocation = false;
        });
        return;
      }
      if (permissionStatus.isPermanentlyDenied) {
        openAppSettings();
        setState(() {
          isFetchingLocation = false;
        });
        return;
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        lat = position.latitude.toString();
        long = position.longitude.toString();
        isFetchingLocation = false;
      });

      print('Latitude: $lat, Longitude: $long');
    } catch (e) {
      setState(() {
        isFetchingLocation = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obtaining location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 230, 230, 230),
        body: SingleChildScrollView(
          child: Builder(
            builder: (BuildContext context) {
              return Column(
                children: [
                  const SizedBox(height: 100),
                  Center(
                    child: Image.asset(
                      'lib/image/Ridesense.png',
                      height: 300,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: locationController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        labelText: "LOCATION",
                        hintText: 'Enter the Location',
                        labelStyle:
                            TextStyle(fontSize: 20, color: Colors.black),
                        prefixIcon: Icon(Icons.location_on),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.black, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          borderSide: BorderSide(color: Colors.black, width: 3),
                        ),
                      ),
                      cursorColor: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'OR',
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => getLocation(context),
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: isFetchingLocation
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              lat == '' ? 'Get Location' : 'Location Obtained',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: () => submit(context),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 100, right: 100, bottom: 40, top: 40),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'SUBMIT',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
