import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/sockerst_services.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Band> bands = [
    // Band(id: '1',name: 'Kurt',          votes: 6),
    // Band(id: '2',name: 'amilo',         votes: 7),
    // Band(id: '3',name: 'Andres cepeda', votes: 10),
    // Band(id: '4',name: 'morat',         votes: 5),
];

  @override
void initState() { 

   final socketServices = Provider.of<SocketServices>(context, listen: false);
   socketServices.socket.on('active-bands', (payload){
     this.bands = (payload as List)
     .map((band) => Band.fromMap(band))
     .toList();

      setState(() {});
   });
  super.initState();
}

@override
  void dispose() {
   final socketServices = Provider.of<SocketServices>(context, listen: false);
   socketServices.socket.off('active-bands');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    final socketServices = Provider.of<SocketServices>(context);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('BandasNmaes', style: TextStyle(color: Colors.black87,))),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketServices.servicesStatus == ServicesStatus.Online) 
            ? Icon(Icons.check_circle, color: Colors.blue[300],)
            : Icon(Icons.offline_bolt, color: Colors.red,),
            //,
          )
        ],
      ),
      body: Column(
        children: [
          _grafica(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTitle(bands[i])
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),  
   );
  }

  Widget _bandTitle(Band band) {
    final socketService = Provider.of<SocketServices>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_){
        socketService.socket.emit('delete-band', {'id': band.id});
     
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: Colors.redAccent,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text('Eliminar Banda', style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
             leading: CircleAvatar(
               child: Text(band.name.substring(0,2)),
               backgroundColor: Colors.blue[100],
             ),
             title: Text(band.name),
             trailing: Text('${band.votes}',style: TextStyle(fontSize: 20),),
             onTap: (){
                 socketService.socket.emit('vote', {'id': band.id});
                //  setState(() {
                   
                //  });
             },
          ),
    );
  }

  addNewBand()
  {

    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      showDialog(
      context: context, 
      builder: (context)
      {
         return AlertDialog(
           title: Text('Nueva Banda'),
           content: TextField(
             controller: textController,
           ),
           actions: [
             MaterialButton(
               onPressed: () => addBandtoList(textController.text),
               child: Text('Add'),
               elevation: 5,
               textColor: Colors.blue,
               )
           ],
         );
      }
    );
    }
    
   
  }

  void addBandtoList( String name)
  {
    
    if (name.length > 1) {
        bands.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
        final socketServices = Provider.of<SocketServices>(context, listen: false);
        socketServices.socket.emit('add-band', {'name': name});
         
    }
     Navigator.pop(context);
  }

  _grafica()
  {
    Map<String, double> dataMap = new Map();
    // "Flutter": 5,
    bands.forEach((data) { 
      dataMap.putIfAbsent(data.name, () => data.votes.toDouble());
    });

  return Container(
    padding: EdgeInsets.only(top: 20),
    width: double.infinity,
    height: 200,
    child: PieChart(
      chartType: ChartType.ring,
      dataMap: dataMap
      )
    ) ;
  }
}