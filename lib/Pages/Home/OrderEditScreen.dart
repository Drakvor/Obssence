import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/OrderEditState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/ItemSelectionList.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/ReasonSelectionList.dart';
import 'package:luxury_app_pre/Pages/Home/OrderEditScreen/MethodSelectionList.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomImage.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:path_provider/path_provider.dart';

class OrderEditScreen extends StatefulWidget {
  final OrderData order;
  OrderEditScreen(this.order);

  @override
  _OrderEditScreenState createState() => _OrderEditScreenState(order);
}

class _OrderEditScreenState extends State<OrderEditScreen> {
  final OrderData order;
  late final TextEditingController textControl;
  OrderEditState state = OrderEditState();
  _OrderEditScreenState(this.order);

  void changeState ({Function? f}) {
    setState(() {
      if (f != null) {
        f();
      }
    });
  }

  void textOn () {
    setState(() {
      state.setTextActive();
    });
  }

  @override
  void initState () {
    super.initState();
    textControl = TextEditingController();
    state.setTextCont(textControl);
    state.setTextFunction(textOn);
    state.changeStateFunction(changeState);
  }

  void dispose () {
    textControl.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        setState(() {
          state.setTextInactive();
        });
      },
      child: Scaffold(
        backgroundColor: utils.resourceManager.colours.transparent,
        body: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    child: buildHeader(),
                  ),
                  CustomDivider(),
                  Expanded(
                    child: buildMain(),
                  ),
                  CustomDivider(),
                  Container(
                    margin: (state.stage == 0) ? EdgeInsets.zero : EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: (state.stage == 0) ? Container() : buildButton(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader () {
    return Container(
      height: 100,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("교환, 반품 신청", style: utils.resourceManager.textStyles.base15_700,),
                //plus button
              ],
            ),
          ),
          Positioned(
            left: 5,
            top: 5,
            width: 40,
            height: 40,
            child: CustomRoundButton(
              whenPressed: () {
                utils.appManager.previousPage(utils.pageNav);
              },
              image: utils.resourceManager.images.backButton,
              imagePressed: utils.resourceManager.images.backButton,
              h: 40,
              w: 40,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 50,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("상품 선택", style: (state.stage >= 0) ? utils.resourceManager.textStyles.base14gold : utils.resourceManager.textStyles.base14),
                  Text("-", style: (state.stage >= 1) ? utils.resourceManager.textStyles.base14gold : utils.resourceManager.textStyles.base14),
                  Text("사유 선택", style: (state.stage >= 1) ? utils.resourceManager.textStyles.base14gold : utils.resourceManager.textStyles.base14),
                  Text("-", style: (state.stage >= 2) ? utils.resourceManager.textStyles.base14gold : utils.resourceManager.textStyles.base14),
                  Text("해결방법 선택", style: (state.stage >= 2) ? utils.resourceManager.textStyles.base14gold : utils.resourceManager.textStyles.base14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMain () {
    if (state.stage == 0) {
      return ItemSelectionList(order, state);
    }
    if (state.stage == 1) {
      return Column(
        children: [
          Container(
            child: buildSelection(state.selection!),
          ),
          CustomDivider(),
          Expanded(
            child: ReasonSelectionList(state),
          ),
        ],
      );
    }
    if (state.stage == 2) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSelection(state.selection!),
          CustomThinDivider(),
          buildReason(),
          MethodSelectionList(state),
        ],
      );
    }
    return Container();
  }

  Widget buildButton () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (state.stage == 0) ?
          Container() :
          Container(
            margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: CustomButton(
              whenPressed: () {
                setState(() {
                  state.previousStage();
                });
              },
              text: "이전단계",
              style: utils.resourceManager.textStyles.base,
              h: 25,
              w: 100,
            ),
          ),
          getRightButton(),
        ],
      ),
    );
  }

  Widget getRightButton () {
    if (state.stage == 2) {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        key: Key("submitButton"),
        child: CustomButton(
          whenPressed: () {

          },
          text: "신청하기",
          style: utils.resourceManager.textStyles.base,
          h: 25,
          w: 100,
        ),
      );
    }
    if (state.stage == 0 || state.stage == 1) {
      return Container(
        margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: CustomButton(
          whenPressed: () {
            setState(() {
              state.nextStage();
            });
          },
          text: "다음단계",
          style: utils.resourceManager.textStyles.base,
          h: 25,
          w: 100,
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget buildSelection (OrderItem selection) {
    Future<File> thisImage = getImage(selection);
    return Container(
      margin: EdgeInsets.fromLTRB(5, 15, 5, 15),
      width: MediaQuery.of(context).size.width,
      height: 72,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            width: 72,
            height: 72,
            //color: Color(0xff99ff99),
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
        ],
      ),
    );
  }

  Widget buildReason () {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Text("선택한 사유", style: utils.resourceManager.textStyles.base12_100),
          ),
          Container(
            height: 10,
          ),
          Container(
            child: Text(state.reason, style: utils.resourceManager.textStyles.base14,),
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
