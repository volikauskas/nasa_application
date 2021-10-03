// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nasa_app/plant.dart';
import 'package:nasa_app/searchres.dart';

// ignore: must_be_immutable
class ResultsPage extends StatefulWidget {
  ResultsPage(
      {Key? key, required this.data, required this.title, required this.freq})
      : super(key: key);

  SearchRes data;
  final dataLabels = ["Light", "Temperature", "Humidity", "Soil Wetness"];
  final String title;
  // ignore: prefer_typing_uninitialized_variables
  final freq;

  @override
  State<StatefulWidget> createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  @override
  // ignore: must_call_super
  void initState() {
    convertData();
    getPlants();
    sortPlants();
  }

  void sortPlants() {
    plantList.plants.sort((Plants a, Plants b) {
      int _diffA = _totalDiffernce(a);
      int _diffB = _totalDiffernce(b);
      if (_diffA < _diffB) {
        return -1;
      } else if (_diffA > _diffB) {
        return 1;
      }
      return a.CommonName.compareTo(b.CommonName);
    });
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
      // ignore: prefer_typing_uninitialized_variables
      var value;
      if (i < data.length - 2) {
        value = data[i].split('[')[1].split(']')[0];
      } else {
        value = data[i].split('[')[1].split(']')[0];
      }
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
          const Image(image: AssetImage('lib/data/nasa_app_icon.png')),
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
        title: const Text(
          'Parameters',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        children: <Widget>[
          SizedBox(
            height: 500,
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _graph(
                          widget.dataLabels[index],
                          widget.data.results[index],
                          widget.data.averagesPerDay,
                          index));
                }),
          ),
        ],
      ),
    );
  }

  Widget _graph(
      String title, Results results, AveragesPerDay averagesPerDay, index) {
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
        Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Daily average: " +
                    _getAverageValue(averagesPerDay, index) +
                    " " +
                    results.values[results.values.length - 2],
                style: const TextStyle(
                  fontSize: 18,
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
                      dotData: (widget.freq == 'monthly'
                          ? FlDotData(show: true)
                          : FlDotData(show: false)),
                    ),
                  ]),
              // swapAnimationDuration: Duration(milliseconds: 150), // Optional
              // swapAnimationCurve: Curves.linear,
            ),
          ),
        ),
      ],
    );
  }

  _getAverageValue(averagesPerDay, index) {
    if (index == 0) {
      return averagesPerDay.L.toStringAsFixed(3);
    }
    if (index == 1) {
      return averagesPerDay.T.toStringAsFixed(3);
    }
    if (index == 2) {
      return averagesPerDay.H.toStringAsFixed(3);
    }
    if (index == 3) {
      return averagesPerDay.W.toStringAsFixed(3);
    }
  }

  FlTitlesData get titlesData => FlTitlesData(
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
      );

  FlAxisTitleData axisTitles(List<String> values, String title) =>
      FlAxisTitleData(
        show: true,
        bottomTitle: AxisTitle(
          showTitle: true,
          margin: 15,
          titleText: 'Time, ' + widget.freq,
        ),
        leftTitle: AxisTitle(
            showTitle: true,
            margin: -5,
            titleText: title + ', ' + values[values.length - 2]),
      );

  List<FlSpot> _getSpots(List<String> values, index) {
    var _length = (index == 3 ? values.length - 4 : values.length - 2);
    return List.generate(_length, (i) {
      return FlSpot(i * 1.0, double.parse(values[i]));
    });
  }

  Widget _plantsPanel() {
    sortPlants();
    return Card(
      color: Colors.lightGreen[50],
      elevation: 5,
      child: ExpansionTile(
        collapsedTextColor: Colors.black87,
        textColor: Colors.black87,
        title: const Text(
          'Suggested plants',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                  plantList.plants[index].CommonName +
                      ' ' +
                      _totalDiffernce(plantList.plants[index]).toString(),
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
                  // _dataBoxes(
                  //     widget.data.userValues.L,
                  //     widget.data.userValues.T,
                  //     widget.data.userValues.H,
                  //     widget.data.userValues.W,
                  //     index,
                  //     false),
                  // _dataBoxes(
                  //     plantList.plants[index].L,
                  //     plantList.plants[index].T,
                  //     plantList.plants[index].H,
                  //     plantList.plants[index].W,
                  //     index,
                  //     true),
                  _dataBoxes(
                    plantList.plants[index].L,
                    plantList.plants[index].T,
                    plantList.plants[index].H,
                    plantList.plants[index].W,
                    widget.data.userValues.L,
                    widget.data.userValues.T,
                    widget.data.userValues.H,
                    widget.data.userValues.W,
                    index,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _plantDialogText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: RichText(
          text: const TextSpan(
        style: TextStyle(
          fontSize: 15,
          color: Colors.black87,
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Sunlight\n\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextSpan(
            text:
                '''1 – The plant can grow in the low-light areas: it needs 0.06 – 0.1943 kWh sunlight per hour\n
2. The plant can grow in the medium-light areas: it requires 0.1943 – 0.518 kWh sunlight per hour\n
3. The plant can grow in the high-light areas: it requires 0.518 – 2.59 kWh sunlight per hour\n
4. The plant should grow in the high-light areas: it requires more than 2.59 kWh sunlight per hour.\n\n''',
          ),
          TextSpan(
            text: 'Temperature\n\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextSpan(
            text: '''1.	The plant needs at least 14 °C daily temperature\n
2.	The plant needs 21-25 °C daily temperature\n
3.	The plant needs more than 25 °C daily temperature\n\n''',
          ),
          TextSpan(
            text: 'Relative Humidity\n\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextSpan(
            text: '''1.	The plant requires high humidity (50% or higher)\n
2.	The plant requires average humidity (25% to 49%)\n
3.	The plant requires low humidity (5% to 24%)\n\n''',
          ),
          TextSpan(
            text: 'Soil wetness\n\n',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          TextSpan(
            text: '''1.	Soil has to be moist (50 – 100 %)\n
2.	Soil can be dry before re-watering (<30 %)\n
3.	Soil can be moderately dry before re-watering (30 – 50 %)\n\n''',
          ),
        ],
      )),
    );
  }

  Future<dynamic> _displayInfo(index) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width - 200,
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
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(plantList.plants[index].CommonName,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                      child: Container(
                        height: 2,
                        color: Colors.yellow[500],
                      ),
                    ),
                    _plantDialogText(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  int _totalDiffernce(Plants plant) {
    return _difference(widget.data.userValues.L, plant.L) +
        _difference(widget.data.userValues.T, plant.T) +
        _difference(widget.data.userValues.H, plant.H) +
        _difference(widget.data.userValues.W, plant.W);
  }

  int _difference(int userV, String V) {
    int _minDif = 10;
    if (V.length == 1) {
      int _V = int.parse(V);
      int dif = (_V - userV).abs();
      _minDif = min(_minDif, dif);
    } else if (V.length == 3) {
      var split = V.split('-');
      int _V1 = int.parse(split[0]);
      int dif1 = (_V1 - userV).abs();
      _minDif = min(_minDif, dif1);

      _V1 = int.parse(split[1]);
      dif1 = (_V1 - userV).abs();
      _minDif = min(_minDif, dif1);
    }
    return _minDif;
  }

  Color? _getColor(diff) {
    if (diff == 0) {
      return Colors.green[200];
    }
    if (diff == 1) {
      return Colors.yellow[200];
    }
    return Colors.red[200];
  }

  Widget _dataBoxes(L, T, H, W, userL, userT, userH, userW, index) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                // decoration: const BoxDecoration(color: Colors.green),
                color: _getColor(_difference(userL, L)),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(userL.toString()),
                ),
              ),
              Container(
                // decoration: const BoxDecoration(color: Colors.green),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(L.toString()),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // decoration: const BoxDecoration(color: Colors.green),
                color: _getColor(_difference(userT, T)),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(userT.toString()),
                ),
              ),
              Container(
                // decoration: const BoxDecoration(color: Colors.green),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(T.toString()),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // decoration: const BoxDecoration(color: Colors.green),
                color: _getColor(_difference(userH, H)),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(userH.toString()),
                ),
              ),
              Container(
                // decoration: const BoxDecoration(color: Colors.green),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(H.toString()),
                ),
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // decoration: const BoxDecoration(color: Colors.green),
                color: _getColor(_difference(userW, W)),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(userW.toString()),
                ),
              ),
              Container(
                // decoration: const BoxDecoration(color: Colors.green),

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
                  child: Text(W.toString()),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  // Widget _dataBoxes(L, T, H, W, index, isPlant) {
  //   return Expanded(
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //         Container(
  //           // decoration: const BoxDecoration(color: Colors.green),
  //           color: (isPlant ? null : Colors.green[200]),

  //           child: Text(L.toString()),
  //         ),
  //         Container(
  //           // decoration: const BoxDecoration(color: Colors.green),
  //           child: Text(T.toString()),
  //         ),
  //         Container(
  //           // decoration: const BoxDecoration(color: Colors.green),
  //           child: Text(H.toString()),
  //         ),
  //         Container(
  //           // decoration: const BoxDecoration(color: Colors.green),
  //           child: Text(W.toString()),
  //         ),
  //       ],
  //     ),
  //   );
  // }

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
