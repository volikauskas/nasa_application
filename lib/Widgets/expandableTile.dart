// ignore_for_file: file_names

import 'package:flutter/material.dart';

class ExpandableTile extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final title;

  const ExpandableTile({Key? key, required this.title}) : super(key: key);
  @override
  State<StatefulWidget> createState() => ExpandableTileState();
}

class ExpandableTileState extends State<ExpandableTile> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(widget.title.toString()),
      initiallyExpanded: false,
      children: [
        SizedBox(
          height: 500,
          child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(index.toString()),
                  );
                }),
          ),
        )
      ],
    );
  }
}
