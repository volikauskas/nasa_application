// ignore_for_file: file_names

import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../resultsPage.dart';
// ignore: import_of_legacy_library_into_null_safe

class ParameterPage extends StatefulWidget {
  ParameterPage(
      {Key? key,
      required this.title,
      required this.locationLat,
      required this.locationLon})
      : super(key: key);

  var locationLon;
  var locationLat;
  final title;

  @override
  State<StatefulWidget> createState() => ParameterPageState();
}

class ParameterPageState extends State<ParameterPage> {
  String _selectedRadio = 'monthly';
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
                  _dropParamList(),
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

  void _search() {
    if (_formKey.currentState!.validate()) {
      var data = <dynamic>['labas', 'rytas', 'jums'];
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

  Widget _datePickers() {
    var now = DateTime.now();
    var _startDate = DateTime(now.year - 1, now.month, now.day, now.hour);
    var _endDate = DateTime.now();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateTimeFormField(
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
                } else if (false) {
                  // add limited date interval
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

  Widget _radioButtons() {
    return Column(
      children: [
        RadioListTile(
            title: const Text('hourly'),
            value: 'hourly',
            groupValue: _selectedRadio,
            onChanged: (_selected) {
              setState(() {
                _selectedRadio = _selected as String;
              });
            }),
        RadioListTile(
            title: const Text('daily'),
            value: 'daily',
            groupValue: _selectedRadio,
            onChanged: (_selected) {
              setState(() {
                _selectedRadio = _selected as String;
              });
            }),
        RadioListTile(
            title: const Text('monthly'),
            value: 'yearly',
            groupValue: _selectedRadio,
            onChanged: (_selected) {
              setState(() {
                _selectedRadio = _selected as String;
              });
            }),
      ],
    );
  }

  var _selectedTimeDrop = 'Monthly';

  Widget _dropTimeList() {
    return DropdownButton<String>(
      value: _selectedTimeDrop,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedTimeDrop = newValue!;
        });
      },
      items: <String>['Hourly', 'Daily', 'Monthly']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  var _selectedParamDrop = 'Energy';
  Widget _dropParamList() {
    return DropdownButton<String>(
      value: _selectedParamDrop,
      icon: const Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selectedParamDrop = newValue!;
        });
      },
      items: <String>['Energy', 'Temperature', 'Humidity', 'Soil']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
