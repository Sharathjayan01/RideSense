<<<<<<< HEAD
# RideSense
internship assignment


This Flutter app allows users to either fetch their current location via GPS or manually enter a location. Here's a breakdown:

1.Get Location (GPS): The user can tap the "Get Location" button, which fetches the device's latitude and longitude using the `Geolocator` package. Before fetching, the app checks if location services are enabled and requests location permission (using the `permission_handler` package). If permission is granted, the app gets the current position and displays it.

2.Enter Location Manually: Alternatively, users can input a location (like a city or address) in the text field. The app uses Geoapify’s geocoding API to convert this address into latitude and longitude.

3.Location Display: After obtaining the location (from either GPS or manual entry), the app sends the coordinates to a second screen (`Home`). This screen shows the location on a map using the `flutter_map` package. Users can switch between map styles: Default (OpenStreetMap), Satellite, and Terrain views.

4.Reverse Geocoding: If the user fetches their GPS location, the app uses the Geoapify API to reverse geocode it into an address, which can also be displayed or used.

In summary, it’s an app that handles both manual and automatic location inputs, converts them into coordinates, and displays them on an interactive map.
![IMG-20241005-WA0025](https://github.com/user-attachments/assets/4c250ebe-4eb7-4e79-82b4-219a93e6583d)
![IMG-20241005-WA0024](https://github.com/user-attachments/assets/86464179-054a-4d66-980d-f514165e84ef)
![IMG-20241005-WA0023](https://github.com/user-attachments/assets/352e7858-9160-4730-b09d-50cdb10a3121)
![IMG-20241005-WA0022](https://github.com/user-attachments/assets/9522f251-61f5-4eb0-a0b4-8a877fb13e1a)
![IMG-20241005-WA0021](https://github.com/user-attachments/assets/df301c3e-19d3-4898-b733-1aea6acf9107)
=======
# app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
>>>>>>> 866fae6 (first commit)
