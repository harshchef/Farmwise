Farmer Data Collection App
Overview
This Flutter application aims to efficiently collect and manage farmer data, providing a user-friendly interface for data input and display. The app consists of two screens, each serving distinct purposes – the first for data collection and submission, and the second for displaying stored farmer data along with additional features.

Screens
Screen 1 - Data Collection
This screen facilitates the collection of farmer data with the following fields:

Farmer Name: Textbox (mandatory).
Address: Multiline textbox (optional).
DOB: Date picker.
Gender: Dropdown.
Farm Land Area in Acres: Numeric input (not more than 100).
Latitude and Longitude: Geotag of current location (mandatory).
Images: Capture using the Camera app (mandatory).
Validations and Features:
Basic field validations are implemented for all fields.
The app requests access to location, camera, and storage permissions upon initial launch.
Screen 2 - Data Display
This screen displays stored/collected farmer data in a table/grid format. Each record includes links to images and videos, as well as other collected fields like latitude and longitude. Additionally, a bonus task fetches and displays the current temperature and city of the device location using an open-source API.

Bonus Task Features:
Fetches current temperature and city from an open-source API.
Displays temperature and city information at the top of the screen.
File Hierarchy
lib/
models/
farmer.dart
screens/
screen1.dart
screen2.dart
utils/
location_helper.dart
weather_api.dart
generated_plugin_registrant.dart
main.dart
Packages Used
cupertino_icons: ^1.0.2
location: ^5.0.0
image_picker: ^0.8.7+1
camera: ^0.10.3+2
shared_preferences: ^2.1.1
geolocator: ^10.1.0
video_player: ^2.6.1
permission_handler: ^11.0.1
http: ^0.13.5
