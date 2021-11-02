import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomImage.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:luxury_app_pre/Pages/Home/ItemScreen/SizeButtons.dart';
import 'package:luxury_app_pre/Pages/Home/ItemScreen/SelectionState.dart';
import 'dart:io';
import 'package:luxury_app_pre/Pages/Home/ItemScreen/QuantityButtons.dart';
import 'package:luxury_app_pre/Widget/CustomRoundTextButton.dart';

class ItemScreen extends StatefulWidget {
  final ItemData item;
  final List<File> images;
  final bool editing;
  ItemScreen(this.item, this.images, {this.editing=false});

  @override
  _ItemScreenState createState() => _ItemScreenState(item, images, editing);
}

class _ItemScreenState extends State<ItemScreen> with SingleTickerProviderStateMixin {
  final ItemData item;
  final List<File> images;
  late AnimationController overlayCont;
  final ScrollController scrollCont = new ScrollController();
  bool _scrolling = false;
  final bool editing;
  SelectionState selState = new SelectionState(1, -1);
  _ItemScreenState(this.item, this.images, this.editing);

  Future<void> listen () async {
    if(scrollCont.offset <= (MediaQuery.of(context).size.height - utils.totalPadding - 188)/2 && scrollCont.offset > 0 && scrollCont.position.isScrollingNotifier.value && _scrolling == false) {
      _scrolling = true;
      await scrollCont.animateTo(MediaQuery.of(context).size.height - utils.totalPadding - 188, duration: Duration(milliseconds: 500), curve: Curves.ease).then((_) {_scrolling = false;});
    }
    if(scrollCont.offset > (MediaQuery.of(context).size.height - utils.totalPadding - 188)/2 && scrollCont.offset < (MediaQuery.of(context).size.height - utils.totalPadding - 188) && scrollCont.position.isScrollingNotifier.value && _scrolling == false) {
      _scrolling = true;
      scrollCont.animateTo(0, duration: Duration(milliseconds: 500), curve: Curves.ease).then((_) {_scrolling = false;});
    }
  }

  void changeState () {
    setState(() {
      //do nothing
    });
  }

  @override
  void initState () {
    super.initState();
    overlayCont = new AnimationController.unbounded(vsync: this, value: editing ? 100 : 600);
    scrollCont.addListener(listen);
  }

  void dispose () {
    scrollCont.removeListener(listen);
    overlayCont.dispose();
    super.dispose();
  }

  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: buildStack(context),
    );
  }

  Widget buildStack (BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          child: buildMainColumn(),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: buildButtons(context),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              //do nothing (for real though)
            },
            child: buildCoverScreen(),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 400,
          child: Container(
            height: 400,
            child: buildOverlay(),
          ),
        ),
      ],
    );
  }

  Widget buildMainColumn () {
    return ListView(
      controller: scrollCont,
      padding: EdgeInsets.zero,
      physics: AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      children: [
        getImages(),
        Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height - utils.totalPadding),
          child: getDetails(),
        ),
      ],
    );
  }

  Widget getImages () {
    return Container(
      height: MediaQuery.of(context).size.height - utils.totalPadding - 188,
      child: Stack(
        children: [
          Container(
              child: PageView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: getPages(),
              )
          ),
          Positioned(
            right: 5,
            child: buildScrollIndicator(),
          ),
        ],
      ),
    );
  }

  List<Widget> getPages () {
    List<Widget> pages = [];
    for (int i = 0; i < images.length; i++) {
      pages.add(CustomImage(images[i]));
      //pages.add(Container(color: Color(0xffff9999),));
    }
    return pages;
  }

  Widget getDetails () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(80, 20, 80, 5),
          child: Text(item.brand, style: utils.resourceManager.textStyles.base13_700U,),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(80, 5, 80, 5),
          child: Text(item.name, style: utils.resourceManager.textStyles.base13_100,),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(80, 5, 80, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("₩" + item.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base13,),
              Text(item.sale!.value.toString() + "%", style: utils.resourceManager.textStyles.base13,),
            ],
          ),
        ),
        getLikeAndCartButtons(),
        CustomThinDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Text("아이템 설명", style: utils.resourceManager.textStyles.base14_700,),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Text(item.description, style: utils.resourceManager.textStyles.base14_100,),
        ),
        CustomThinDivider(),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          child: Text("아이템 디테일", style: utils.resourceManager.textStyles.base14_700,),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getMaterials(),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text("Made In: " + item.madeIn, style: utils.resourceManager.textStyles.base14,),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text("SKU: " + item.sku, style: utils.resourceManager.textStyles.base14,),
        ),
      ],
    );
  }

  Widget buildScrollIndicator () {
    return Container();
  }

  Widget buildOverlay () {
    return GestureDetector(
      onVerticalDragUpdate: (DragUpdateDetails details) {
        overlayCont.animateTo((overlayCont.value + details.delta.dy > 100) ? overlayCont.value+details.delta.dy : 100, duration: Duration(seconds: 0), curve: Curves.linear);
      },
      onVerticalDragEnd: (DragEndDetails details) {
        if (overlayCont.value > 200) {
          overlayCont.animateTo(600, duration: Duration(milliseconds: 200), curve: Curves.linear);
        }
        if (overlayCont.value <= 200) {
          overlayCont.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.linear);
        }
      },
      onVerticalDragCancel: () {
        overlayCont.animateTo(100, duration: Duration(milliseconds: 200), curve: Curves.linear);
      },
      child: getOverlay(),
    );
  }

  Widget getOverlay() {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, overlayCont.value, 0, 1,
          ),
          child: child,
        );
      },
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          color: utils.resourceManager.colours.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 5,
              offset: Offset(0, -2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: getOverlayContent(),
      ),
    );
  }

  Widget getOverlayContent () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 20,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Image.asset(utils.resourceManager.images.downIndicator),
          ),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text("사이즈", style: utils.resourceManager.textStyles.base14_700U),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: MediaQuery.of(context).size.width,
            child: SizeButtons(selState, item.availableSizes!, item),
          ),
        ),
        CustomThinDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text("갯 수", style: utils.resourceManager.textStyles.base14_700U),
        ),
        Expanded(
          flex: 1,
          child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
            width: MediaQuery.of(context).size.width,
            child: QuantityButtons(selState, item),
          ),
        ),
        CustomThinDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: CustomButton(
              whenPressed: () async {

                if (selState.size == -1 || selState.quantity < 1) {
                  utils.appManager.buildAlertDialog(context, "사이즈와 갯수를 정해주세요.");
                  //show error
                }
                else {
                  CollectionReference selections = FirebaseFirestore.instance.collection("selections");
                  DocumentReference selection = await selections.add({
                    "size": item.availableSizes![selState.size],
                    "quantity": selState.quantity,
                    "item": item.id,
                    "parent": utils.dataManager.user!.id,
                  });
                  await selections.doc(selection.id).update({
                    "id": selection.id,
                  });
                  OrderItem newSelection = new OrderItem(
                    id: selection.id,
                    quantity: selState.quantity,
                    size: item.availableSizes![selState.size],
                    itemId: item.id,
                    item: item,
                  );
                  await newSelection.getItemData();
                  utils.dataManager.user!.cart.addSelection(newSelection);
                  await overlayCont.animateTo(600, duration: Duration(milliseconds: 200), curve: Curves.linear);
                  setState(() {});
                  utils.appManager.buildAlertDialog(context, "상품을 쇼핑백에 담았습니다.");
                }
              },
              text: "확인",
              style: utils.resourceManager.textStyles.base14,
              h: 33,
              w: 102,
            ),
          ),
        ),
        Container(
          height: 100,
        ),
      ],
    );
  }


  Widget buildButtons (BuildContext context) {
    String _updatedCount = (utils.appManager.loggedIn) ? utils.dataManager.user!.cart.listSelections.length.toString() : "0";
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomRoundButton(
            whenPressed: () {
              utils.appManager.previousPage(utils.pageNav);
            },
            image: utils.resourceManager.images.backButton,
            imagePressed: utils.resourceManager.images.backButton,
            h: 40,
            w: 40,
          ),
          (utils.appManager.loggedIn) ? Container(
            key: Key("CartButton" + _updatedCount),
            child: CustomRoundTextButton(
              whenPressed: () {
                utils.appManager.toShoppingPage(context, utils.pageNav);
              },
              text: _updatedCount,
              style: utils.resourceManager.textStyles.dots,
              h: 40,
              w: 40,
            ),
          ) : Container(),
        ],
      ),
    );
  }

  Widget getLikeAndCartButtons () {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: CustomButton(
              whenPressed: () {
                overlayCont.animateTo(100, duration: Duration(milliseconds: 300), curve: Curves.linear);
              },
              text: "쇼핑백 담기",
              style: utils.resourceManager.textStyles.base14,
              h: 33,
              w: 102,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getMaterials () {
    List<Widget> elements = [];
    List listKeys = item.materials!.keys.toList();
    for (int i = 0; i < listKeys.length; i++) {
      String text = listKeys[i] + ": ";
      List listSubKeys = item.materials![listKeys[i]].keys.toList();
      for (int j = 0; j < listSubKeys.length; j++) {
        if (j == 0) {
          text = text + item.materials![listKeys[i]][listSubKeys[j]] + " " + listSubKeys[j];
        }
        else {
          text = text + " / " + item.materials![listKeys[i]][listSubKeys[j]] + " " + listSubKeys[j];
        }
      }
      elements.add(
        Container(
          margin: EdgeInsets.fromLTRB(0, 2, 0, 2),
          child: Text(text, style: utils.resourceManager.textStyles.base14_100,),
        ),
      );
    }
    return elements;
  }

  Widget buildCoverScreen () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (overlayCont.value < 600) ? 0 : MediaQuery.of(context).size.height, 0, 1,
          ),
          child: Opacity(
            opacity: (1-(overlayCont.value-100)/500)/2,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff000000),
            ),
          ),
        );
      },
    );
  }
}
