import 'package:devjoon/designer_page.dart';
import 'package:devjoon/handcraft_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DevJoon',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text('DevJoon'),
          ),
          body: Center(child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [                  Text("Pick the application"),
              SizedBox(height: 16,),
                    MaterialButton(
                      minWidth: double.infinity,
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        'Handcraft Application',
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandcraftPage(),
                        ),
                      ),
                    ),
                                SizedBox(height: 16,),
                                        MaterialButton(
                                                              minWidth: double.infinity,

                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      child: Text(
                        'Desginer Application',
                      ),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DesignerPage(),
                        ),
                      ),
                    ),

              ],
            ),
          ))),
    );
  }
}
