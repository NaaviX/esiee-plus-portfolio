import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'ui/event_list.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //logs de l'aplication ex: Log.i("titre", "texte");
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });

    //Base de l'application
    final _title = "BDE ESIEE Paris";
    return MaterialApp(title: _title, home: Base());
  }
}



class Base extends StatefulWidget {
  Base({Key key}) : super(key: key);

  @override
  _Base createState() => _Base();
}

class _Base extends State<Base> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    Center(child: Text('Home', style: optionStyle)),
    Center(child: Text('EDT', style: optionStyle)),
    EventList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final _title = "BDE ESIEE Paris";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BDE ESIEE Paris")),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            title: Text('EDT'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            title: Text('Event'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
          child: ListView(children: <Widget>[
        DrawerHeader(
          child: Text("Drawer Header"),
          decoration: BoxDecoration(color: Colors.blueGrey),
        ),
        ListTile(
          title: Text("item 1"),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ])),
    );
  }
}