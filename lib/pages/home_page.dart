import 'dart:io';

import 'package:band_names/models/band.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List<Band> bands = [
    Band(id: '1',name: 'Kurt',          votes: 6),
    Band(id: '2',name: 'amilo',         votes: 7),
    Band(id: '3',name: 'Andres cepeda', votes: 10),
    Band(id: '4',name: 'morat',         votes: 5),
];

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BandasNmaes', style: TextStyle(color: Colors.black87,)),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTitle(bands[i])
        ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),  
   );
  }

  Widget _bandTitle(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direccion){
        print('direecion: ${direccion}');
        print('id: ${band.id}');
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
             onTap: (){},
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
          setState(() { });
    }
     Navigator.pop(context);
  }
}