import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Los juanitos', votes: 10),
    Band(id: '2', name: 'Enruquitos', votes: 3),
    Band(id: '3', name: 'Queeeeso', votes: 2),
    Band(id: '4', name: 'Algo', votes: 6)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BandNames", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (BuildContext context, int index) => _bandTIle(bands[index])
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add)
      )
    );
  }

  Widget _bandTIle(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //TODO: LLamar el borrado del server
      },
      background: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Delete band",
              style: TextStyle(color: Colors.white),
            ),
          )
        ),
      ),
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0,2))
        ),
        title: Text(band.name),
        trailing: Text(band.votes.toString(), style: const TextStyle(fontSize: 20)),
        onTap: () { }
      ),
    );
  }

  addNewBand() {
    final textEditingController = TextEditingController();

    // if (Platform.isIOS) {
    //   showCupertinoDialog(
    //     context: context, 
    //     builder: (context) => CupertinoAlertDialog(
    //       title: const Text("New Band Name"),
    //       content: CupertinoTextField(
    //         controller: textEditingController
    //       ),
    //       actions: [
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           onPressed: () { addBandToList(textEditingController.text); },
    //           child: const Text("Add")
    //         ),
    //         CupertinoDialogAction(
    //           isDestructiveAction: true,
    //           onPressed: () { Navigator.pop(context); },
    //           child: const Text("Dismiss")
    //         )
    //       ]
    //     )
    //   );
    // } else {
      showDialog(
        context: context, 
        builder: (context) => AlertDialog(
          title: const Text("New Band Name"),
          content: TextField(
            controller: textEditingController,
          ),
          actions: [
            MaterialButton(
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () { addBandToList(textEditingController.text); },
              child: const Text("Add") 
            )
          ]
        )
      ); 
    //}
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      bands.add( Band(id: DateTime.now().toString(), name: name, votes: 1) );
      setState(() {});
    }
    Navigator.pop(context);
  }
}
