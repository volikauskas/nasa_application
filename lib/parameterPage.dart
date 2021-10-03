// ignore_for_file: file_names

import 'dart:convert';

import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'resultsPage.dart';
import 'searchres.dart';
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
    // _btnController = RoundedLoadingButtonController();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toString()),
      ),
      body: SingleChildScrollView(
        child: Form(
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
                child: RoundedLoadingButton(
                  color: Colors.yellow[400],
                  child: const Text('Search',
                      style: TextStyle(color: Colors.black87)),
                  controller: _btnController,
                  onPressed: _search,
                ),
              ),
              Visibility(
                visible: _loadingTextVisible,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'You have requested $_noOfEntries entries. This may take some time to complete.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red[500],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _loadingTextVisible = false;

  var _noOfEntries = 0;

  RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  int _getEntries() {
    Duration _dur = _endDate.difference(_startDate);
    int _noOfParameters = 4;
    if (_selectedTimeDrop == 'hourly') {
      return _dur.inHours * _noOfParameters;
    } else if (_selectedTimeDrop == 'daily') {
      return _dur.inDays * _noOfParameters;
    } else if (_selectedTimeDrop == 'monthly') {
      return (_endDate.year - _startDate.year + 1) * 13 * _noOfParameters;
    }
    return 1253;
  }

  void _search() async {
    // _loadingTextVisible = true;

    // change the number of entries

    if (_formKey.currentState!.validate() &&
        _formKey.currentState?.validate() != null) {
      _noOfEntries = _getEntries();
      if (_noOfEntries > 500) {
        setState(() {
          _noOfEntries = _getEntries();
          _loadingTextVisible = true;
        });
      }

      var url =
          "http://sunshine-hackathon.eu.ngrok.io/api/freq=$_selectedTimeDrop&start_year=${_startDate.year}${_startDate.month.toString().padLeft(2, '0')}${_startDate.day.toString().padLeft(2, '0')}&end_year=${_endDate.year}${_endDate.month.toString().padLeft(2, '0')}${_endDate.day.toString().padLeft(2, '0')}&long=${widget.locationLon}&lat=${widget.locationLat}";
      final response = await http.get(Uri.parse(url));
      SearchRes data = SearchRes.fromJson(jsonDecode(response.body));
      setState(() {
        _loadingTextVisible = false;
        _btnController.stop();
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsPage(
            title: widget.title.toString(),
            data: data,
            freq: _selectedTimeDrop,
          ),
        ),
      );
    }
    _btnController.stop();
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

  final _firstDate = DateTime(1981, 1, 2);
  final _lastDate = DateTime.now();

  var _startDate = DateTime(
      DateTime.now().year - 2, DateTime.now().month, DateTime.now().day);
  var _endDate = DateTime(2020, 12, 31);

  Widget _datePickers() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateTimeFormField(
            firstDate: _firstDate,
            lastDate: _lastDate,
            initialValue: _startDate,
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
            firstDate: _firstDate,
            lastDate: _lastDate,
            initialValue: _endDate,
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
        color: Colors.yellow[500],
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
