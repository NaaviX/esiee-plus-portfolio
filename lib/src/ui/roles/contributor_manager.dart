import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ContributorManager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContributorManagerState();
  }
}

class ContributorManagerState extends State<ContributorManager> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.person),
                    text: "Cotisants",
                  ),
                  Tab(
                      icon: Icon(Icons.person_add),
                      text: "Ajouts"
                  ),
                ],
              ),
              title: Text("Droits des utilisateurs"),
            ),
            body: Container(
              child: TabBarView(
                children: [
                  Container(),
                  Wrap(
                    children: <Widget> [
                      Text(barcode),
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(20.0),
                          ),
                          color: Theme.of(context).primaryColor,
                          child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                'scan'.toUpperCase(),
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              )),
                          splashColor: Colors.white,
                          onPressed: () {
                            scan();
                          }
                      ),
                    ]),
                ],
              ),
            )
        )
    );
  }

  String barcode = "";
  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}