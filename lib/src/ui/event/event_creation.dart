import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class EventCreation extends StatelessWidget {

  @override Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
            title: Text("Nouvel Evenement")
        ),
        body: createEventForm()
    );
  }
}

// Create a Form widget.
class createEventForm extends StatefulWidget {

  @override
  createEventFormState createState() {
    return createEventFormState();
  }

}

class createEventFormState extends State<createEventForm> {
  final _formKey = GlobalKey<FormState>();
  //String _date = "Enter date";
  String _time = "Enter time";
  String _start = "Event Start At";
  String _end = "Event End At";

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              newTextInput('Intitulé de l\'évenement','Please enter some text',Icon(Icons.calendar_today)),
              newLongTextInput('Description','Please enter some text'),
              datetimeButton(Colors.teal, this._start),
              datetimeButton(Colors.redAccent, _end),
              newTextInput('Lieu','Please enter some text',Icon(Icons.person)),
              newNumberInput('Prix','Please enter some text',Icon(Icons.attach_money)),
              SizedBox(height: 20.0),
              newTextInput('Lien Vente','Please enter some text',Icon(Icons.payment)),
              SizedBox(height: 20.0),
              newTextInput('Lien Event Facebook','Please enter some text',Icon(Icons.link)),
              SizedBox(height: 20.0),
              newTextInput('id club','Please enter some text',Icon(Icons.person)),
              SizedBox(height: 20.0),
              newTextInput('Background url','Please enter some text',Icon(Icons.image)),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    color: Colors.teal,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                      'CREER',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
                    splashColor: Colors.white,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Processing Data')));
                      }
                    },
                  ),
                ))
            ],
          ))),
    );
  }

  Widget newTextInput(String hintText, String ifEmpty, Icon icon){
    return new Padding(
        padding: EdgeInsets.all(4.0),
        child: TextFormField(
            decoration: new InputDecoration(
              icon: icon,
              labelText: hintText,
              fillColor: Colors.white70,
              //fillColor: Colors.green
            ),
          validator: (value) {
            if (value.isEmpty) {
              return ifEmpty;
            }
            return null;
          }
    ));
  }

  Widget newLongTextInput(String hintText, String ifEmpty){
    return new TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
            hintText: hintText
        ),
        validator: (value) {
          if (value.isEmpty) {
            return ifEmpty;
          }
          return null;
        }
    );
  }

  Widget newNumberInput(String hintText, String ifEmpty, Icon icon){
    return new TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        decoration: InputDecoration(
            icon: icon,
            hintText: hintText
        ),
        validator: (value) {
          if (value.isEmpty) {
            return ifEmpty;
          }
          return null;
        }
    );
  }

  Widget newDatePickerInput(String value){
    addLeadingZero(int number) => (number < 10 ? '0' : '') + number.toString();
    dateFormatter(int year, int month, int day) => '${addLeadingZero(day)} ${addLeadingZero(month)} ${year.toString()}';

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DatePickerTimeline(
          DateTime.now(),
          onDateChange: (date) {
            // New date selected
            print(date.toString());
            _start = value == _start ? dateFormatter(date.year, date.month, date.day) : _start;
            _end = value == _end ? dateFormatter(date.year, date.month, date.day) : _end;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget newTimePickerInput(){

    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)),
      elevation: 4.0,
      onPressed: () {
        DatePicker.showTimePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (time) {
              print('confirm $time');
              _time = '${time.hour} : ${time.minute} : ${time.second}';
            }, currentTime: DateTime.now(), locale: LocaleType.en);
        setState(() {});
      },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.access_time,
                        size: 18.0,
                        color: Colors.teal,
                      ),
                      Text(
                        " $_time",
                        style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Text(
              "  Change",
              style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ],
        ),
      ),
      color: Colors.white,
    );
  }

  Widget datetimeButton(Color color, String value){
    // user defined function
    void _showDialog() {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    newDatePickerInput(value)
                  ],
                ),
              ),
            ),
          );
        },
      );
    }

    return new Padding(
        padding: EdgeInsets.all(5.0),
        child: Center(
          child: new RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 4.0,
            onPressed: _showDialog,
            child: Container(
              alignment: Alignment.center,
              height: 50.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.access_time,
                              size: 18.0,
                              color: color,
                            ),
                            Text(
                              " $value",
                              style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            color: Colors.white,
          )
        ));
  }


}