import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomImage.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:path_provider/path_provider.dart';

class ReturnsListItem extends StatefulWidget {
  final Function setPageState;
  final ReturnData returns;
  ReturnsListItem(this.setPageState, this.returns);

  @override
  _ReturnsListItemState createState() => _ReturnsListItemState(setPageState, returns);
}

class _ReturnsListItemState extends State<ReturnsListItem> {
  final Function setPageState;
  final ReturnData returns;
  late File image;
  late Directory appImgDir;
  late Future initialised;
  _ReturnsListItemState(this.setPageState, this.returns);

  @override
  void initState () {
    super.initState();
    initialised = getImage();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: MediaQuery.of(context).size.width,
      height: 120,
      child: buildRow(),
    );
  }

  Widget buildRow () {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
          width: 72,
          height: 72,
          //color: Color(0xff99ff99),
          child: FutureBuilder(
            future: initialised,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return CustomImage(image);
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        Expanded(
          child: Container(
            height: 120,
            child: mainColumn(),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: 90,
          height: 120,
          child: priceColumn(),
        ),
      ],
    );
  }

  Widget mainColumn () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(returns.selection!.item!.brand, style: utils.resourceManager.textStyles.base12_100U),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
        Container(
          child: Text(returns.selection!.item!.name, style: utils.resourceManager.textStyles.base12_100),
        ),
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Container(
          child: Text("선택한 사유", style: utils.resourceManager.textStyles.base14_100),
        ),
        Container(
          child: Text(returns.reason, style: utils.resourceManager.textStyles.base14),
        ),
        Expanded(
          flex: 1,
          child: Container(),
        ),
      ],
    );
  }

  Widget priceColumn () {
    return Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          width: 90,
          right: 0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Text("갯수: " + returns.selection!.quantity.toString(), style: utils.resourceManager.textStyles.base10),
              ),
              Container(
                height: 10,
              ),
              Container(
                child: Text("사이즈: " + returns.selection!.size, style: utils.resourceManager.textStyles.base10),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> getImage () async {
    appImgDir = await getApplicationDocumentsDirectory();
    image = File('${appImgDir.path}/' + returns.selection!.item!.id + "0");
    if (!image.existsSync()) {
      await FirebaseStorage.instance
          .ref("Items/" + returns.selection!.item!.id + "/0.png")
          .writeToFile(image);
    }
  }
}
