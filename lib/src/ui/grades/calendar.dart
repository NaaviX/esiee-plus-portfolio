import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Calendar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CalendarState();
  }
}

class CalendarState extends State<Calendar> {
  // ignore: non_constant_identifier_names
  final log = Logger('Calendar');

  // ignore: non_constant_identifier_names
  Map<String, bool> GradesUnits = {
    'foo': true,
    'bar': false,
  };

  @override
  void initState() {
    super.initState();
    if (getGradesUnit() != null) {
      log.log(Level.INFO, "OK2");
    }
    else {
      log.log(Level.INFO, "OK1");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('CheckboxListTile demo')),
      body: new ListView(
        children: GradesUnits.keys.map((String key) {
          return new CheckboxListTile(
            title: new Text(key),
            value: GradesUnits[key],
            onChanged: (bool value) {
              setState(() {
                GradesUnits[key] = value;
              });
            },
          );
        }).toList(),
      ),
    );
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getGradesUnit(),
        initialData: "Loading text..",
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Scaffold(
            body: Text(text.data??"Can't find text")
          );
        }),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GradesList()),
      );
      },
      child: Icon(Icons.settings),
      backgroundColor: Colors.blue,
      )
    );
  }
}*/

  Future<String> getGradesUnit() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // ignore: non_constant_identifier_names
    String GradesUnitID = prefs.getString('GradesUnit_ID');
    return GradesUnitID;
  }


}