// ignore_for_file: file_names

import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../resultsPage.dart';
import '../searchres.dart';
// ignore: import_of_legacy_library_into_null_safe

// ignore: must_be_immutable
class ParameterPage extends StatefulWidget {
  ParameterPage({
    Key? key,
    required this.title,
    required this.locationLat,
    required this.locationLon,
  }) : super(key: key);

  var locationLon = 0.0;
  var locationLat = 0.0;
  // ignore: prefer_typing_uninitialized_variables
  final title;

  @override
  State<StatefulWidget> createState() => ParameterPageState();
}

class ParameterPageState extends State<ParameterPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toString()),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _locationFields(),
            _datePickers(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _dropTimeList(),
                  // _dropParamList(),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: _search,
                child: const Text('Search'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _search() async {
    if (_formKey.currentState!.validate()) {
      var url =
          "http://192.168.0.4:5000/api/freq=$_selectedTimeDrop&start_year=${_startDate.year}${_startDate.month.toString().padLeft(2, '0')}${_startDate.day.toString().padLeft(2, '0')}&end_year=${_endDate.year}${_endDate.month.toString().padLeft(2, '0')}${_endDate.day.toString().padLeft(2, '0')}&long=${widget.locationLon}&lat=${widget.locationLat}";
      final response = await http.get(Uri.parse(url));
      // print(response.statusCode);
      SearchRes data = SearchRes.fromJson(jsonDecode(response.body));
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            title: widget.title.toString(),
            data: data,
          ),
        ),
      );
    }
  }

  // var _yearStart = null;
  // var _yearEnd = null;

  // var _yearPickerVisible = true;

  // Widget _yearPickers() {
  //   return Visibility(
  //     visible: _yearPickerVisible,
  //     child: Padding(
  //       padding: const EdgeInsets.all(16.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 const Text("Start date:"),
  //                 DropdownButton<String>(
  //                   hint: const Text("-Start Date-"),
  //                   value: _yearStart,
  //                   icon: const Icon(Icons.arrow_downward),
  //                   iconSize: 24,
  //                   elevation: 16,
  //                   underline: Container(
  //                     height: 2,
  //                     color: Colors.yellow,
  //                   ),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _yearStart = newValue;
  //                     });
  //                   },
  //                   items:
  //                       List.generate(5, (index) => (2000 + index).toString())
  //                           .map<DropdownMenuItem<String>>((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Column(
  //               children: [
  //                 const Text('End Date'),
  //                 DropdownButton<String>(
  //                   hint: const Text("-End Date-"),
  //                   value: _yearEnd,
  //                   icon: const Icon(Icons.arrow_downward),
  //                   iconSize: 24,
  //                   elevation: 16,
  //                   underline: Container(
  //                     height: 2,
  //                     color: Colors.yellow,
  //                   ),
  //                   onChanged: (String? newValue) {
  //                     setState(() {
  //                       _yearEnd = newValue;
  //                     });
  //                   },
  //                   items:
  //                       List.generate(5, (index) => (2000 + index).toString())
  //                           .map<DropdownMenuItem<String>>((String value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value,
  //                       child: Text(value),
  //                     );
  //                   }).toList(),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  final _firstDate = DateTime(1970);
  final _lastDate = DateTime(2021);
  var now = DateTime.now();

  var _startDate = DateTime(2018);
  var _endDate = DateTime(2019);

  Widget _datePickers() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateTimeFormField(
            firstDate: _firstDate,
            lastDate: _lastDate,
            initialDate: _startDate,
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Start date',
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) {
              if (e != null) {
                if (e.isAfter(_endDate)) {
                  return 'Must be before the End date';
                }
              }
              return null;
            },
            onDateSelected: (DateTime value) {
              _startDate = value;
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.blueAccent),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'End date',
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) {
              if (e != null) {
                if (e.isBefore(_startDate)) {
                  return 'Must be after the Start date';
                }
                return null;
              }
            },
            onDateSelected: (DateTime value) {
              _endDate = value;
            },
          ),
        ),
      ],
    );
  }

  final TextEditingController _lonController = TextEditingController();
  final TextEditingController _latController = TextEditingController();

  Widget _locationFields() {
    _lonController.text = widget.locationLon.toStringAsPrecision(8);
    _latController.text = widget.locationLat.toStringAsPrecision(8);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            enabled: false,
            controller: _lonController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Longitude",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            enabled: false,
            controller: _latController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Latitude",
            ),
          ),
        )
      ],
    );
  }

  // Widget _radioButtons() {
  //   return Column(
  //     children: [
  //       RadioListTile(
  //           title: const Text('hourly'),
  //           value: 'hourly',
  //           groupValue: _selectedRadio,
  //           onChanged: (_selected) {
  //             setState(() {
  //               _selectedRadio = _selected as String;
  //             });
  //           }),
  //       RadioListTile(
  //           title: const Text('daily'),
  //           value: 'daily',
  //           groupValue: _selectedRadio,
  //           onChanged: (_selected) {
  //             setState(() {
  //               _selectedRadio = _selected as String;
  //             });
  //           }),
  //       RadioListTile(
  //           title: const Text('monthly'),
  //           value: 'yearly',
  //           groupValue: _selectedRadio,
  //           onChanged: (_selected) {
  //             setState(() {
  //               _selectedRadio = _selected as String;
  //             });
  //           }),
  //     ],
  //   );
  // }

  var _selectedTimeDrop = 'monthly';

  Widget _dropTimeList() {
    return DropdownButton<String>(
      value: _selectedTimeDrop,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.blueAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTimeDrop = newValue!;
        });
      },
      items: <String>['hourly', 'daily', 'monthly']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // var _selectedParamDrop = 'All';
  // Widget _dropParamList() {
  //   return DropdownButton<String>(
  //     value: _selectedParamDrop,
  //     icon: const Icon(Icons.arrow_downward),
  //     iconSize: 24,
  //     elevation: 16,
  //     underline: Container(
  //       height: 2,
  //       color: Colors.deepPurpleAccent,
  //     ),
  //     onChanged: (String? newValue) {
  //       setState(() {
  //         _selectedParamDrop = newValue!;
  //       });
  //     },
  //     items: <String>['All', 'Energy', 'Temperature', 'Humidity', 'Soil']
  //         .map<DropdownMenuItem<String>>((String value) {
  //       return DropdownMenuItem<String>(
  //         value: value,
  //         child: Text(value),
  //       );
  //     }).toList(),
  //   );
  // }
}
