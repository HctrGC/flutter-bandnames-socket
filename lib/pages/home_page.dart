import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/provider/socket_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketProvider = Provider.of<SocketProvider>(context, listen: false); 
    socketProvider.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    bands = (payload as List)
        .map((band) => Band.fromMap(band))
        .toList(); 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("BandNames", style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: (socketProvider.serverStatus == ServerStatus.Online)
            ? Icon(Icons.check_circle, color: Colors.blue[300])
            : const Icon(Icons.offline_bolt, color: Colors.red)
          )
        ]
      ),
      body: Column(
        children: [
          _graph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) => _bandTile(bands[index])
            )
          )
        ]
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add)
      )
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketProvider>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (_) => socketService.socket.emit('delete-band', {'id': band.id}),
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
        onTap: () => socketService.socket.emit('vote-band', {'id': band.id})
      )
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
        builder: (_) => AlertDialog(
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
      final socketProvider = Provider.of<SocketProvider>(context, listen: false);
      socketProvider.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  // Gráfica
  Widget _graph() {
    Map<String, double> dataMap = {};
    for (var band in bands) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    }
    
    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        chartType: ChartType.ring
      )
    );
  }
}
