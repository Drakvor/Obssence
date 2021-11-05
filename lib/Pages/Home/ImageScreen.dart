import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class ImageScreen extends StatefulWidget {
  final File image;
  ImageScreen(this.image);

  @override
  _ImageScreenState createState() => _ImageScreenState(image);
}

class _ImageScreenState extends State<ImageScreen> {
  final File image;
  _ImageScreenState(this.image);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        backgroundDecoration: new BoxDecoration(
            color: utils.resourceManager.colours.background,
        ),
        imageProvider: Image.file(image,).image,
      )
    );
  }
}

