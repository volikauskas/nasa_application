import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

import 'gmap.dart';

const myApiKey = "AIzaSyDLWD1z3zGbJ6qv3njHqCG_grtxMEMTm_o";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;
  static final kInitialPosition = LatLng(-33.8567844, 151.213108);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickResult selectedPlace = PickResult();

  @override
  Widget build(BuildContext context) {
    return PlacePicker(
      apiKey: myApiKey,
      initialPosition: HomePage.kInitialPosition,
      useCurrentLocation: true,
      selectInitialPosition: true,
      hintText: 'Pick a location',
      automaticallyImplyAppBarLeading: false,

      //usePlaceDetailSearch: true,
      onPlacePicked: (result) {
        // Navigator.of(context).pop();
        // print(selectedPlace.geometry!.location.lat.toString() +
        //     ' ' +
        //     selectedPlace.geometry!.location.lat.toString());
        setState(() {
          selectedPlace = result;
        });
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
      // pinBuilder: (context, state) {
      //   if (state == PinState.Idle) {
      //     return Icon(Icons.favorite_border);
      //   } else {
      //     return Icon(Icons.favorite);
      //   }
      // },

      // Text(selectedPlace.formattedAddress ?? ""),
    );
  }
}
