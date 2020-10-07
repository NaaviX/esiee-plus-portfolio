import 'package:bde_esiee_mobile/src/auth/sign_in.dart';
import 'package:bde_esiee_mobile/src/theme.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/Hyperlink.dart';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:flutter/rendering.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorDetect {
  final coverData;
  img.Image photo;

  ColorDetect(this.coverData);

  void setImageBytes(imageBytes) {
    print("setImageBytes");
    List<int> values = imageBytes.buffer.asUint8List();
    photo = null;
    photo = img.decodeImage(values);
  }

  int abgrToArgb(int argbColor) {
    print("abgrToArgb");
    int r = (argbColor >> 16) & 0xFF;
    int b = argbColor & 0xFF;
    return (argbColor & 0xFF00FF00) | (b << 16) | r;
  }

  Future<Color> getColor() async {
    print("getColor");
    Uint8List data;

    try{
      data =
          (await NetworkAssetBundle(
              Uri.parse(coverData)).load(coverData))
              .buffer
              .asUint8List();
    }
    catch(ex){
      print(ex.toString());
    }

    print("setImageBytes....");
    setImageBytes(data);

//FractionalOffset(1.0, 0.0); //represents the top right of the [Size].
    double px = 1.0;
    double py = 0.0;

    int pixel32 = photo.getPixelSafe(px.toInt(), py.toInt());
    int hex = abgrToArgb(pixel32);
    print("Value of int: $hex ");

    return Color(hex);
  }
}

/*class ColorDetectState extends State<ColorDetect> {

  @override
  Widget build(BuildContext context) {
    print("build");

    return Column(
        children: <Widget>[
          Flexible(
            flex: 1,
            child:

            FutureBuilder(
                future: widget._getColor(),
                builder: (_, AsyncSnapshot<Color> data){
                  if (data.connectionState==ConnectionState.done){
                    return Container(
                      color: data.data,
                    );
                  }
                  return CircularProgressIndicator();
                }
            ),
          ),
        ],
    );
  }
}*/