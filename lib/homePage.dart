// ignore_for_file: avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:nasa_app/parameterPage.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

var myApiKey = DotEnv.env['API_KEY'];

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  // ignore: prefer_const_constructors
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);
  // final routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult selectedPlace = PickResult();

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: myApiKey!,
      initialPosition: HomePage.kInitialPosition,
      useCurrentLocation: true,
      selectInitialPosition: true,
      hintText: 'Pick a location',
      automaticallyImplyAppBarLeading: false,

      //usePlaceDetailSearch: true,
      // ignore: duplicate_ignore
      onPlacePicked: (result) {
        // Navigator.of(context).pop();
        // print(selectedPlace.geometry!.location.lat.toString() +
        //     ' ' +
        //     selectedPlace.geometry!.location.lat.toString());
        openParametersPage(result.formattedAddress,
            result.geometry?.location.lat, result.geometry?.location.lng);
        // setState(() {
        //   selectedPlace = result;
        // });
      },
      //forceSearchOnZoomChanged: true,
      autocompleteLanguage: "en",
      usePlaceDetailSearch: true,

      // selectedPlaceWidgetBuilder:
      //     (_, selectedPlace, state, isSearchBarFocused) {
      //   // print("state: $state, isSearchBarFocused: $isSearchBarFocused");
      //   return isSearchBarFocused
      //       ? Container()
      //       : FloatingCard(
      //           bottomPosition:
      //               0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
      //           leftPosition: 0.0,
      //           rightPosition: 0.0,
      //           width: 500,
      //           borderRadius: BorderRadius.circular(12.0),
      //           child: state == SearchingState.Searching
      //               ? Center(child: CircularProgressIndicator())
      //               : ElevatedButton(
      //                   child: Text("Pick Here"),
      //                   onPressed: () {
      //                     // IMPORTANT: You MUST manage selectedPlace data yourself as using this build will not invoke onPlacePicker as
      //                     //            this will override default 'Select here' Button.
      //                     // print("do something with [selectedPlace] data");
      //                     // Navigator.of(context).pop();
      //                   },
      //                 ),
      //         );
      // },
      pinBuilder: (context, state) {
        if (state == PinState.Idle) {
          return Icon(
            Icons.local_florist,
            color: Colors.amber,
          );
        } else {
          return Icon(
            Icons.local_florist_outlined,
            color: Colors.amber,
          );
        }
      },

      // Text(selectedPlace.formattedAddress ?? ""),
    );
  }

  void openParametersPage(address, lat, lon) {
    // do a request to the server
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParameterPage(
            title: address,
            locationLat: lat,
            locationLon: lon,
          ),
        ));
  }
}
