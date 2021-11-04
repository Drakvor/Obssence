import 'dart:io';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/OrderEditState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomImage.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:path_provider/path_provider.dart';

class ItemSelectionList extends StatefulWidget {
  final OrderData order;
  final OrderEditState state;
  ItemSelectionList(this.order, this.state);

  @override
  _ItemSelectionListState createState() => _ItemSelectionListState(order, state);
}

class _ItemSelectionListState extends State<ItemSelectionList> {
  final OrderData order;
  final OrderEditState state;
  _ItemSelectionListState(this.order, this.state);

  @override
  Widget build (BuildContext context) {
    return ListView.builder(
      itemCount: order.selections!.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            buildSelection(order.selections![index]),
            CustomThinDivider(),
          ],
        );
      },
    );
  }

  Widget buildSelection (OrderItem selection) {
    Future<File> thisImage = getImage(selection);
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: MediaQuery.of(context).size.width,
      height: 72,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            width: 72,
            height: 72,
            child: FutureBuilder(
              future: thisImage,
              builder: (context, AsyncSnapshot<File> snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return CustomImage(snapshot.data!);
                }
                else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(selection.item!.brand, style: utils.resourceManager.textStyles.base12_100U,),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  child: Text(selection.item!.name, style: utils.resourceManager.textStyles.base12_100,),
                ),
                Container(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("갯수: " + selection.quantity.toString(), style: utils.resourceManager.textStyles.base10,),
                      Text("사이즈: " + selection.size, style: utils.resourceManager.textStyles.base10,),
                      Container(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: 60,
            height: 72,
            child: Container(
              child: CustomRoundButton(
                whenPressed: () {
                  state.nextStage(data: selection);
                  state.changeState!();
                },
                image: utils.resourceManager.images.frontButton,
                imagePressed: utils.resourceManager.images.frontButton,
                h: 40,
                w: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<File> getImage (OrderItem selection) async {
    Directory appImgDir = await getApplicationDocumentsDirectory();
    File image = File('${appImgDir.path}/' + selection.item!.id + "0");
    if (!image.existsSync()) {
      await FirebaseStorage.instance
          .ref("Items/" + selection.item!.id + "/0.png")
          .writeToFile(image);
    }
    return image;
  }
}
