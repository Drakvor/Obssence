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
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class OrderListItem extends StatefulWidget {
  final Function setPageState;
  final OrderItem selection;
  OrderListItem(this.setPageState, this.selection);

  @override
  _OrderListItemState createState() => _OrderListItemState(setPageState, selection);
}

class _OrderListItemState extends State<OrderListItem> {
  final Function setPageState;
  final OrderItem selection;
  late File image;
  late Directory appImgDir;
  late Future initialised;
  _OrderListItemState(this.setPageState, this.selection);

  @override
  void initState () {
    super.initState();
    initialised = getImage();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: MediaQuery.of(context).size.width,
      height: 80,
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
            height: 80,
            child: mainColumn(),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: 120,
          height: 80,
          child: priceColumn(),
        ),
      ],
    );
  }

  Widget mainColumn () {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Text(selection.item!.brand, style: utils.resourceManager.textStyles.base12_100U,),
        ),
        Container(
          child: Text(selection.item!.name, style: utils.resourceManager.textStyles.base12_100),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("??????: " + selection.quantity.toString(), style: utils.resourceManager.textStyles.base10,),
              ),
              Container(
                child: Text("?????????: " + selection.size, style: utils.resourceManager.textStyles.base10,),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget priceColumn () {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 5,
          bottom: 0,
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Text("???" + (selection.item!.price * (1 - selection.item!.sale!.value/100)).toString(), style: utils.resourceManager.textStyles.base12,),
              ),
              Container(
                child: Text("???" + (selection.item!.price).toString(), style: utils.resourceManager.textStyles.base12Sgrey,),
              ),
              Container(
                child: Text((selection.item!.sale!.value).toString() + "% ??????", style: utils.resourceManager.textStyles.base12_700gold,),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> getImage () async {
    appImgDir = await getApplicationDocumentsDirectory();
    image = File('${appImgDir.path}/' + selection.item!.id + "0");
    if (!image.existsSync()) {
      await FirebaseStorage.instance
          .ref("Items/" + selection.item!.id + "/0.png")
          .writeToFile(image);
    }
  }
}
