// screens/screen1.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/screen2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../models/farmer.dart';
import '../utils/location_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class Screen1 extends StatefulWidget {
  @override
  _Screen1State createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  DateTime? selectedDate;
  String selectedGender = 'Male';
  String image1Path = '';
  String image2Path = '';
  String videoPath = '';
  double latitude = 0.0;
  double longitude = 0.0;
  VideoPlayerController? _videoController;

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _pickImage(int imageNumber) async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        if (imageNumber == 1) {
          image1Path = pickedFile.path;
        } else {
          image2Path = pickedFile.path;
        }
      });
    }
  }

  void _recordVideo() async {
    final pickedFile = await ImagePicker().getVideo(
      source: ImageSource.camera,
      maxDuration: Duration(seconds: 30),
    );

    if (pickedFile != null) {
      _videoController = VideoPlayerController.file(File(pickedFile.path))
        ..initialize().then((_) {
          setState(() {
            videoPath = pickedFile.path;
          });
        });
    }
  }

  // void _getLocation() async {
  //   Position? position = await LocationHelper.getCurrentLocation();
  //   if (position != null) {
  //     setState(() {
  // latitude = position.latitude;
  // longitude = position.longitude;
  //     });
  //   }
  // }
  void _getLocation() async {
    Position? position = await LocationHelper.getCurrentLocation();
    var status = await Permission.location.request();

    if (status == PermissionStatus.granted && position != null) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    } else {
      // Handle the case where location permission is denied
      print("Error: Location permission denied or location not available");
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Farmer farmer = Farmer(
        name: nameController.text,
        address: addressController.text,
        farmLandArea: double.parse(areaController.text),
        dob: selectedDate!,
        gender: selectedGender,
        image1Path: image1Path,
        image2Path: image2Path,
        videoPath: videoPath,
        latitude: latitude,
        longitude: longitude,
      );

      // TODO: Save farmer data or navigate to the next screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Screen2(
            farmers: [farmer],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Farmer Data Collection'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Farmer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farmer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: areaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Farm Land Area'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter farm land area';
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Date of Birth: ${selectedDate ?? 'Not selected'}'),
                  TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              DropdownButton<String>(
                value: selectedGender,
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                items: ['Male', 'Female', 'Other']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () => _getLocation(),
                child: Text('Get Location'),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(1),
                    child: Text('Pick Image 1'),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () => _pickImage(2),
                    child: Text('Pick Image 2'),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => _recordVideo(),
                child: Text('Record Video'),
              ),
              if (_videoController != null) VideoPlayer(_videoController!),
              ElevatedButton(
                onPressed: () => _submitForm(),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
