import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:luxury_app_pre/Widget/CustomScrollIndicator.dart';

class ItemScreen extends StatefulWidget {
  final ItemData item;
  final List<File> images;
  final bool editing;
  ItemScreen(this.item, this.images, {this.editing=false});

  @override
  _ItemScreenState createState() => _ItemScreenState(item, images, editing);
}

class _ItemScreenState extends State<ItemScreen> {
  final ItemData item;
  final List<File> images;
  final ScrollController scrollCont = new ScrollController();
  final PageController pageControl = new PageController();
  bool _scrolling = false;
  final bool editing;
  int index = 0;
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

  void listenPage () {
    if (pageControl.page != null) {
      setState(() {
        index = (pageControl.page! + 0.5).toInt();
      });
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
    scrollCont.addListener(listen);
    pageControl.addListener(listenPage);
  }

  void dispose () {
    scrollCont.removeListener(listen);
    pageControl.removeListener(listenPage);
    scrollCont.dispose();
    pageControl.dispose();
    super.dispose();
  }

  Widget build (BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
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
              controller: pageControl,
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: getPages(),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 2,
            child: Center(
              child: CustomScrollIndicator(index, images.length.toDouble()),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getPages () {
    List<Widget> pages = [];
    for (int i = 0; i < images.length; i++) {
      pages.add(
        GestureDetector(
          onTap: () {
            utils.appManager.toImagePage(context, utils.pageNav, images[i]);
          },
          child: CustomImage(images[i]),
        ),
      );
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
          child: Text("Made In: " + item.madeIn, style: utils.resourceManager.textStyles.base14,),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Text("SKU: " + item.sku, style: utils.resourceManager.textStyles.base14,),
        ),
      ],
    );
  }

  Widget getOverlayContent () {
    return Container(
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Text("사이즈", style: utils.resourceManager.textStyles.base14_700U),
          ),
          Expanded(
            flex: 4,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: MediaQuery.of(context).size.width,
              child: SizeButtons(selState, item.availableSizes!, item),
            ),
          ),
          CustomThinDivider(),
          Container(
            margin: EdgeInsets.fromLTRB(20, 10, 20, 5),
            child: Text("갯 수", style: utils.resourceManager.textStyles.base14_700U),
          ),
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              width: MediaQuery.of(context).size.width,
              child: QuantityButtons(selState, item),
            ),
          ),
          CustomThinDivider(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: CustomButton(
                whenPressed: () async {

                  if (selState.size == -1 || selState.quantity < 1) {
                    utils.appManager.buildAlertDialog(context, "사이즈와 갯수를 정해주세요.");
                    return;
                    //show error
                  }
                  else {
                    CollectionReference selections = FirebaseFirestore.instance.collection("selections");
                    for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
                      if (utils.dataManager.user!.cart.listSelections[i].itemId == item.id && utils.dataManager.user!.cart.listSelections[i].size == item.availableSizes![selState.size]) {
                        if (utils.dataManager.user!.cart.listSelections[i].quantity + selState.quantity > item.availableNumber){
                          utils.appManager.buildAlertDialog(context, "너무 많이 주문하십니다.");
                          return;
                        }
                        utils.dataManager.user!.cart.listSelections[i].quantity = utils.dataManager.user!.cart.listSelections[i].quantity + selState.quantity;
                        await selections.doc(utils.dataManager.user!.cart.listSelections[i].id).update(
                            {
                              "quantity": utils.dataManager.user!.cart.listSelections[i].quantity
                            }
                        );
                        await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
                        setState(() {});
                        utils.appManager.buildAlertDialog(context, "상품을 쇼핑백에 담았습니다.");
                        return;
                      }
                    }
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
                    await utils.appManager.overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
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
        ],
      ),
    );
  }


  Widget buildButtons (BuildContext context) {
    String _updatedCount = (utils.appManager.loggedIn) ? utils.dataManager.user!.cart.listSelections.length.toString() : "0";
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
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
            h: 50,
            w: 50,
          ),
          (utils.appManager.loggedIn) ? Container(
            key: Key("CartButton" + _updatedCount),
            child: CustomRoundTextButton(
              whenPressed: () {
                utils.appManager.toShoppingPage(context, utils.pageNav);
              },
              text: _updatedCount,
              style: utils.resourceManager.textStyles.dots,
              h: 50,
              w: 50,
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
                utils.appManager.loadOverlay!(400, getOverlayContent());
                utils.appManager.overlayCont.animateTo(1, duration: Duration(milliseconds: 250), curve: Curves.linear);
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
}
