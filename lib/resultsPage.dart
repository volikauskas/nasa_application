// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasa_app/plant.dart';

class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key, required this.data, required this.title})
      : super(key: key);

  final List<dynamic> data;
  final String title;

  @override
  State<StatefulWidget> createState() => ResultsPageState();
}

class ResultsPageState extends State<ResultsPage> {
  @override
  void initState() {
    // convertData();
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
      color: Colors.yellowAccent[100],
      elevation: 5,
      child: ExpansionTile(
        collapsedTextColor: Colors.black87,
        textColor: Colors.black87,
        title: const Text('Parameters'),
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _graph("Temperature"),
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget _graph(title) {
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
        const Placeholder(
          fallbackHeight: 200,
        ),
      ],
    );
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
            height: MediaQuery.of(context).size.height,
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
