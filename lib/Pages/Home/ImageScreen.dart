import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:luxury_app_pre/Management/Utils.dart';

class ImageScreen extends StatefulWidget {
  final File image;
  ImageScreen(this.image);

  @override
  _ImageScreenState createState() => _ImageScreenState(image);
}

class _ImageScreenState extends State<ImageScreen> {
  final File image;
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;
  _ImageScreenState(this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (ScaleStartDetails scaleStartDetails) {
        _baseScaleFactor = _scaleFactor;
      },
      onScaleUpdate: (ScaleUpdateDetails scaleUpdateDetails) {
        if (scaleUpdateDetails.scale == 1.0){
          return;
        }
        setState((){
          _scaleFactor = _baseScaleFactor * scaleUpdateDetails.scale;
        });
      },
      child: ClipRect(
        child: Align(
          widthFactor: 1.0,
          heightFactor: 1.0,
          child: Image.file(
              image,
              width: MediaQuery.of(context).size.width * _scaleFactor,
              height: MediaQuery.of(context).size.height * _scaleFactor,
          ),
        ),
      ),
    );
  }
}

