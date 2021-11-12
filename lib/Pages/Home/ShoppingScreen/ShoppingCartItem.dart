import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen/ShoppingCartState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomImage.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen/QuantityEditButtons.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen/SizeEditButtons.dart';

class ShoppingCartItem extends StatefulWidget {
  final ShoppingCartState state;
  final Function setPageState;
  final OrderItem selection;
  ShoppingCartItem(this.state, this.setPageState, this.selection);

  @override
  _ShoppingCartItemState createState() => _ShoppingCartItemState(state, setPageState, selection);
}

class _ShoppingCartItemState extends State<ShoppingCartItem> {
  final ShoppingCartState state;
  final Function setPageState;
  final OrderItem selection;
  late File image;
  late Directory appImgDir;
  late Future initialised;
  _ShoppingCartItemState(this.state, this.setPageState, this.selection);

  @override
  void initState () {
    super.initState();
    initialised = getImage();
  }

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      width: MediaQuery.of(context).size.width,
      height: 100,
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
          child: mainColumn(),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
          width: 120,
          height: 100,
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
          child: Text(selection.item!.brand, style: utils.resourceManager.textStyles.base12_100U),
        ),
        Container(
          child: Text(selection.item!.name, style: utils.resourceManager.textStyles.base12_100),
        ),
        Container(
          child: Row(),
        ),
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                whenPressed: () {
                  utils.appManager.loadOverlay!(200, getQuantityFields());
                  utils.appManager.overlayCont.animateTo(1, duration: Duration(milliseconds: 150), curve: Curves.linear);
                  setPageState(() {
                    state.setSelection(selection);
                    state.setState(1);
                  });
                },
                text: "갯수: " + selection.quantity.toString(),
                style: utils.resourceManager.textStyles.base10,
                h: 18,
                w: 48
              ),
              CustomButton(
                whenPressed: () {
                  utils.appManager.loadOverlay!(200, getSizeFields());
                  utils.appManager.overlayCont.animateTo(1, duration: Duration(milliseconds: 150), curve: Curves.linear);
                  setPageState(() {
                    state.setSelection(selection);
                    state.setState(2);
                  });
                },
                text: "사이즈: " + selection.size,
                style: utils.resourceManager.textStyles.base10,
                h: 18,
                w: 80
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
          right: 10,
          bottom: 0,
          width: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                height: 20,
              ),
              Container(
                child: Text("₩" + (selection.item!.price * (1 - selection.item!.sale!.value/100)).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base12,),
              ),
              Container(
                child: Text("₩" + (selection.item!.price).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base12Sgrey,),
              ),
              Container(
                child: Text((selection.item!.sale!.value).toString() + "% 할인", style: utils.resourceManager.textStyles.base12_700gold,),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          height: 25,
          width: 25,
          child: CustomRoundButton(
            whenPressed: () async {
              CollectionReference selections = FirebaseFirestore.instance.collection("selections");
              utils.dataManager.user!.cart.removeSelection(selection);
              await selections.doc(selection.id).delete();
              setPageState(() {});
              utils.appManager.buildAlertDialog(context, "상품을 쇼핑백에서 제거했습니다.");
            },
            image: utils.resourceManager.images.closeButton,
            imagePressed: utils.resourceManager.images.closeButton,
            h: 25,
            w: 25,
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

  Widget getQuantityFields () {
    return Container(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("갯 수:"),
          QuantityEditButtons(state),
          CustomButton(
            whenPressed: () async {
              if (state.quantity != state.selection!.quantity) {
                CollectionReference selections = FirebaseFirestore.instance.collection("selections");

                state.selection!.quantity = state.quantity;

                await selections.doc(state.selection!.id).update({
                  "quantity": state.selection!.quantity,
                });
              }
              state.setState(0);
              await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
              utils.pageNav.currentState!.pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => ShoppingScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
            text: "확인",
            style: utils.resourceManager.textStyles.base,
            h: 30,
            w: 70,
          ),
        ],
      ),
    );
  }

  Widget getSizeFields () {
    return Container(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text("사이즈:"),
          SizeEditButtons(state),
          CustomButton(
            whenPressed: () async {
              if (state.size != state.selection!.item!.availableSizes!.indexOf(state.selection!.size)) {
                CollectionReference selections = FirebaseFirestore.instance.collection("selections");

                state.selection!.size = state.selection!.item!.availableSizes![state.size];

                await selections.doc(state.selection!.id).update({
                  "size": state.selection!.size,
                });
              }
              state.setState(0);
              await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
              utils.pageNav.currentState!.pushReplacement(
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) => ShoppingScreen(),
                  transitionDuration: Duration.zero,
                ),
              );
            },
            text: "확인",
            style: utils.resourceManager.textStyles.base,
            h: 30,
            w: 70,
          ),
        ],
      ),
    );
  }
}
