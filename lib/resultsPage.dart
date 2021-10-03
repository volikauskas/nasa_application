// ignore_for_file: file_names

import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasa_app/plant.dart';
import 'package:nasa_app/searchres.dart';

class ResultsPage extends StatefulWidget {
  ResultsPage({Key? key, required this.data, required this.title})
      : super(key: key);

  SearchRes data;
  final dataLabels = ["Light", "Temperature", "Humidity", "Soil Wetness"];
  final String title;

  @override
  State<StatefulWidget> createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  @override
  // ignore: must_call_super
  void initState() {
    convertData();
    getPlants();
    // filterPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildPanel(),
    );
  }

  void convertData() {
    for (int i = 0; i < widget.data.results.length; i++) {
      widget.data.results[i].values = noBrackets(widget.data.results[i].values);
    }
  }

  List<String> noBrackets(List<String> data) {
    var newList = <String>[];
    for (int i = 0; i < data.length; i++) {
      var value;
      if (i < data.length - 2) {
        value = data[i].split('[')[1].split(']')[0];
      } else {
        value = data[i].split('[')[1].split(']')[0];
      }
      print(value);
      newList.add(value);
    }
    return newList;
  }

  Widget _buildPanel() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _energyPanel(),
          _plantsPanel(),
        ],
      ),
    );
  }

  Widget _energyPanel() {
    return Card(
      color: Colors.yellow[50],
      elevation: 5,
      child: ExpansionTile(
        collapsedTextColor: Colors.black87,
        textColor: Colors.black87,
        title: const Text('Parameters'),
        children: <Widget>[
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _graph(widget.dataLabels[index],
                          widget.data.results[index], index));
                }),
          ),
        ],
      ),
    );
  }

  Widget _graph(String title, Results results, index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: LineChart(
              LineChartData(
                  backgroundColor: Colors.white,
                  titlesData: titlesData,
                  axisTitleData: axisTitles(results.values, title),
                  lineBarsData: <LineChartBarData>[
                    LineChartBarData(
                      spots: _getSpots(results.values, index),
                    ),
                  ]),
              swapAnimationDuration: Duration(milliseconds: 150), // Optional
              swapAnimationCurve: Curves.linear,
            ),
          ),
        ),
      ],
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      );

  FlAxisTitleData axisTitles(List<String> values, String title) =>
      FlAxisTitleData(
        show: true,
        bottomTitle: AxisTitle(showTitle: true, titleText: 'Time'),
        leftTitle: AxisTitle(
            showTitle: true,
            titleText: title + ', ' + values[values.length - 2]),
      );

  List<FlSpot> _getSpots(List<String> values, index) {
    var _length = (index == 3 ? values.length - 3 : values.length - 2);
    return List.generate(_length, (i) {
      return FlSpot(i * 1.0, double.parse(values[i]));
    });
  }

  Widget _plantsPanel() {
    return Card(
      color: Colors.lightGreen[50],
      elevation: 5,
      child: ExpansionTile(
        collapsedTextColor: Colors.black87,
        textColor: Colors.black87,
        title: const Text('Suggested plants'),
        children: <Widget>[
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: plantList.plants.length,
                itemBuilder: (context, index) {
                  return _platListItem(index);
                }),
          ),
        ],
      ),
    );
  }

  Widget _platListItem(index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  plantList.plants[index].CommonName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
                Text(
                  plantList.plants[index].BotanicalName,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              _displayInfo(index);
            },
            icon: const Icon(Icons.info),
          ),
          Expanded(
            child: SizedBox(
              height: 50,
              child: Column(
                children: [
                  _dataBoxes(
                      plantList.plants[index].L,
                      plantList.plants[index].T,
                      plantList.plants[index].H,
                      plantList.plants[index].W,
                      plantList.plants[index].S,
                      index,
                      false),
                  _dataBoxes(
                      plantList.plants[index].L,
                      plantList.plants[index].T,
                      plantList.plants[index].H,
                      plantList.plants[index].W,
                      plantList.plants[index].S,
                      index,
                      true),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> _displayInfo(index) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Positioned(
                      right: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            radius: 14.0,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.close, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                    Text(plantList.plants[index].CommonName),
                    const Placeholder(
                      fallbackHeight: 100,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget _dataBoxes(L, T, H, W, S, index, isPlant) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            // decoration: const BoxDecoration(color: Colors.green),
            child: isPlant ? Text(L.toString()) : const Text('L'),
          ),
          Container(
            // decoration: const BoxDecoration(color: Colors.green),
            child: isPlant ? Text(T.toString()) : const Text('T'),
          ),
          Container(
            // decoration: const BoxDecoration(color: Colors.green),
            child: isPlant ? Text(L.toString()) : const Text('H'),
          ),
          Container(
            // decoration: const BoxDecoration(color: Colors.green),
            child: isPlant ? Text(L.toString()) : const Text('W'),
          ),
          Container(
            // decoration: const BoxDecoration(color: Colors.green),
            child: isPlant ? Text(L.toString()) : const Text('S'),
          ),
        ],
      ),
    );
  }

  Future<String> getJson() {
    return DefaultAssetBundle.of(context).loadString("lib/data/plants.json");
  }

  var plantList = PlantList(plants: []);

  void getPlants() async {
    // plantList = json.decode(await getJson());
    String json = await getJson();
    Map<String, dynamic> plantMap = jsonDecode(json);
    setState(() {
      plantList = PlantList.fromJson(plantMap);
    });
  }
}
