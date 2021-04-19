import 'package:band_names/services/sockerst_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketServices>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('servicesStatus: ${socketService.servicesStatus}')
          ],
        ),
     ),

     floatingActionButton:  FloatingActionButton(
       child: Icon(Icons.message),
       onPressed: (){
         socketService.socket.emit('emitir-mensaje', {
           'nombre': 'Flutter',
           'mensaje':'Hola desde Flutter'
           });
       },
     ),
   );
  }
}