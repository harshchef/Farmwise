//screens/screen2.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/farmer.dart';
import 'package:flutter_application_1/utils/location_helper.dart';
import 'package:flutter_application_1/utils/weather_api.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class Screen2 extends StatefulWidget {
  final List<Farmer> farmers;

  Screen2({required this.farmers});

  @override
  _Screen2State createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double currentTemperature = 0.0;
  String currentCity = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    Position? coordinates = await LocationHelper.getCurrentLocation();
    if (coordinates != null) {
      setState(() {
        currentLatitude = coordinates.latitude;
        currentLongitude = coordinates.longitude;
      });

      // Fetch weather data using specific latitude and longitude
      _fetchWeatherData(coordinates.latitude, coordinates.longitude);
    }
  }

  void _fetchWeatherData(double latitude, double longitude) async {
    WeatherData? weatherData =
        await WeatherApi.getWeatherData(latitude, longitude);
    if (weatherData != null) {
      setState(() {
        currentTemperature = weatherData.temperature;
        currentCity = weatherData.city;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Data Display'),
      ),
      body: Column(
        children: [
          Text('Current Temperature: $currentTemperature'),
          Text('Current City: $currentCity'),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('DOB')),
                DataColumn(label: Text('Gender')),
                DataColumn(label: Text('Farm Land Area')),
                DataColumn(label: Text('Latitude')),
                DataColumn(label: Text('Longitude')),
                DataColumn(label: Text('Image 1')),
                DataColumn(label: Text('Image 2')),
                DataColumn(label: Text('Video')),
              ],
              rows: widget.farmers.map((farmer) {
                return DataRow(
                  cells: [
                    DataCell(Text(farmer.name)),
                    DataCell(Text(farmer.address)),
                    DataCell(Text(farmer.dob.toString())),
                    DataCell(Text(farmer.gender)),
                    DataCell(Text(farmer.farmLandArea.toString())),
                    DataCell(Text(farmer.latitude.toString())),
                    DataCell(Text(farmer.longitude.toString())),
                    DataCell(Image.file(File(farmer.image1Path))),
                    DataCell(Image.file(File(farmer.image2Path))),
                    DataCell(Text(farmer.videoPath)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
