import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CustomImage extends StatelessWidget {
  final File image;
  CustomImage(this.image);

  @override
  Widget build (BuildContext context) {
    return Container(
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.fitHeight,
          child: Image.file(image),
        ),
      ),
    );
  }
}