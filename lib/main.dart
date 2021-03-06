import 'package:band_names/pages/home_page.dart';
import 'package:band_names/pages/status_page.dart';
import 'package:band_names/services/sockerst_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SocketServices(),)
      ],
      child: MaterialApp(
        title: 'Material App',
        initialRoute: 'home',
        routes: {
         'home':   (_) => HomePage(),
         'status': (_) => StatusPage(),
        },
      ),
    );
  }
}