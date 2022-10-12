import 'package:band_names/provider/socket_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage  extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketProvider = Provider.of<SocketProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Status: ${socketProvider.serverStatus}')
          ]
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketProvider.socket.emit('emitir-mensaje', {'nombre': 'Flutter', 'mensaje': 'Hola desde flutter'});
        },
        child: const Icon(Icons.message)
      )
    );
  }
}