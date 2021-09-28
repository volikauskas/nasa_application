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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title.toString()),
      ),
      body: ListView(
        children: [
          _locationFields(),
          _datePickers(),
          _radioButtons(),
          Center(
            child: ElevatedButton(
              onPressed: _search,
              child: const Text('Search'),
            ),
          ),
        ],
      ),
    );
  }

  void _search() {
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

  Widget _datePickers() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.black45),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'Start date',
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) =>
                (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onDateSelected: (DateTime value) {
              print(value);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: DateTimeFormField(
            decoration: const InputDecoration(
              hintStyle: TextStyle(color: Colors.yellowAccent),
              errorStyle: TextStyle(color: Colors.redAccent),
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.event_note),
              labelText: 'End date',
            ),
            mode: DateTimeFieldPickerMode.date,
            autovalidateMode: AutovalidateMode.always,
            validator: (e) =>
                (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
            onDateSelected: (DateTime value) {
              print(value);
            },
          ),
        ),
      ],
    );
  }

  TextEditingController _lonController = TextEditingController();
  TextEditingController _latController = TextEditingController();

  Widget _locationFields() {
    _lonController.text = widget.locationLon.toString();
    _latController.text = widget.locationLat.toString();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _lonController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Longtitude",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
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
}
