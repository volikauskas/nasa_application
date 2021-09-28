// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nasa_app/Widgets/expandableTile.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: _buildPanel(),
          ),
        ));
  }

  // final _expanded = [false, false, false];

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          // widget.data[index].isExpanded = !isExpanded;
        });
      },
      children: widget.data.map<ExpansionPanel>((item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.toString()),
            );
          },
          body: ListTile(
              title: Text(item.toString()),
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                setState(() {
                  widget.data.removeWhere((currentItem) => item == currentItem);
                });
              }),
          isExpanded: true,
        );
      }).toList(),
    );
  }
}
