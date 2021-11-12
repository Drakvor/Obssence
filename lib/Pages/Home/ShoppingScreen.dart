import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen/ShoppingCartItem.dart';
import 'package:luxury_app_pre/Pages/Home/ShoppingScreen/ShoppingCartState.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class ShoppingScreen extends StatefulWidget {

  @override
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> with SingleTickerProviderStateMixin {
  late AnimationController overlayCont;
  late ShoppingCartState state = ShoppingCartState();
  double price = 0;
  double discount = 0;

  void setPageState (Function f) {
    setState(() {f();});
  }

  Future<void> finishDataAccess () async {
    for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
      await utils.dataManager.user!.cart.listSelections[i].getItemData();
      await utils.dataManager.user!.cart.listSelections[i].item!.getSale();
    }
  }

  @override
  void initState () {
    super.initState();
    overlayCont = new AnimationController.unbounded(vsync: this, value: 0);
  }

  void dispose () {
    overlayCont.dispose();
    super.dispose();
  }

  Widget build (BuildContext context) {
    if (utils.appManager.loadCart == false) {
      price = 0;
      for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
        price += utils.dataManager.user!.cart.listSelections[i].quantity * utils.dataManager.user!.cart.listSelections[i].item!.price;
      }
      discount = 0;
      for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
        discount += utils.dataManager.user!.cart.listSelections[i].quantity * utils.dataManager.user!.cart.listSelections[i].item!.price * 0.01 * utils.dataManager.user!.cart.listSelections[i].item!.sale!.value;
      }
      return buildScaffold(context);
    }

    utils.appManager.setLoadCartToFalse();

    CollectionReference selections = FirebaseFirestore.instance.collection('selections');

    return FutureBuilder(
      future: selections.where('parent', isEqualTo: utils.dataManager.user!.id).get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Error1");
        }
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          List<OrderItem> selectionList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            OrderItem newSelection = OrderItem(
              id: snapshot.data!.docs[i].id,
              itemId: snapshot.data!.docs[i]["item"],
              size: snapshot.data!.docs[i]["size"],
              quantity: snapshot.data!.docs[i]["quantity"],
            );
            selectionList.add(newSelection);
          }
          utils.dataManager.user!.cart.getData(selectionList);
          return FutureBuilder(
            future: finishDataAccess(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("Error2: " + snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.done) {
                price = 0;
                for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
                  price += utils.dataManager.user!.cart.listSelections[i].quantity * utils.dataManager.user!.cart.listSelections[i].item!.price;
                }
                discount = 0;
                for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
                  discount += utils.dataManager.user!.cart.listSelections[i].quantity * utils.dataManager.user!.cart.listSelections[i].item!.price * 0.01 * utils.dataManager.user!.cart.listSelections[i].item!.sale!.value;
                }
                return buildScaffold(context);
              }
              else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          );
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildScaffold(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: buildStack(),
    );
  }

  Widget buildStack () {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          bottom: 100,
          child: Column(
            children: [
              buildHeader(),
              buildList(),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 100,
          child: Container(
            height: 100,
            child: buildOverlay(),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 98,
          child: buildPaymentButtons(),
        ),
        Positioned(
          bottom: 90,
          height: 10,
          left: (MediaQuery.of(context).size.width/2) - 5,
          right: (MediaQuery.of(context).size.width/2) - 5,
          child: Center(
            child: Container(
              height: 10,
              width: 10,
              child: overlayIndicator(),
            ),
          ),
        ),
        Positioned(
          bottom: 100,
          left: 0,
          right: 0,
          height: 100,
          child: GestureDetector(
            onVerticalDragStart: (DragStartDetails details) {
              if (overlayCont.value == 1) {
                overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
              }
            },
            onTap: () {
              if (overlayCont.value == 1) {
                overlayCont.animateTo(0, duration: Duration(milliseconds: 200), curve: Curves.linear);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget buildHeader() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Stack(
        children: [
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("총 갯수: ", style: utils.resourceManager.textStyles.base15,),
                Text(utils.dataManager.user!.cart.listSelections.length.toString(), style: utils.resourceManager.textStyles.dots15,),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            height: 50,
            width: 50,
            child: CustomRoundButton(
              whenPressed: () {
                utils.appManager.previousPage(utils.pageNav);
              },
              image: utils.resourceManager.images.backButton,
              imagePressed: utils.resourceManager.images.backButton,
              h: 50,
              w: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList () {
    if (utils.dataManager.user!.cart.listSelections.length > 0) {
      return Expanded(
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: utils.dataManager.user!.cart.listSelections.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  key: new UniqueKey(),
                  child: ShoppingCartItem(state, setPageState, utils.dataManager.user!.cart.listSelections[index]),
                ),
                CustomThinDivider(),
              ],
            );
          },
        ),
      );
    }
    else {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomThinDivider(),
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text("상품이 담겨있지 않습니다.", style: utils.resourceManager.textStyles.base14_700,),
            ),
          ],
        ),
      );
    }
  }

  Widget buildOverlay () {
    return getOverlay();
  }

  Widget getOverlay () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, -overlayCont.value*100, 0, 1,
          ),
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: utils.resourceManager.colours.background,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomDivider(),
                Opacity(
                  opacity: overlayCont.value,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(80, 30, 80, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("총 상품 가격: ", style: utils.resourceManager.textStyles.base12),
                            Text("￦" + price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base13),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("배송비: ", style: utils.resourceManager.textStyles.base12),
                            Text("￦0", style: utils.resourceManager.textStyles.base13),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("할인: ", style: utils.resourceManager.textStyles.base12),
                            Text("- ￦" + discount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base13_700gold),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
                  child: CustomDottedDivider(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPaymentButtons () {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (DragStartDetails details) {
        if (overlayCont.value == 0) {
          overlayCont.animateTo(1, duration: Duration(milliseconds: 200), curve: Curves.linear);
        }
      },
      onTap: () {
        if (overlayCont.value == 0) {
          overlayCont.animateTo(1, duration: Duration(milliseconds: 200), curve: Curves.linear);
        }
      },
      child: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        color: utils.resourceManager.colours.background,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              child: Text("합계: ￦" + (price - discount).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base14_700),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: overlayButtons(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> overlayButtons () {
    List<Widget> buttons = [];
    buttons.add(
        Container(
          margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
          child: CustomButton(
            whenPressed: () {
              if (utils.dataManager.user!.cart.listSelections.isEmpty) {
                utils.appManager.buildAlertDialog(context, "쇼핑백이 비어 있습니다");
                return;
              }
              utils.appManager.toPaymentPage(context, utils.pageNav, price, discount);
            },
            text: "결제",
            style: utils.resourceManager.textStyles.base14,
            h: 30,
            w: 70,
          ),
        )
    );
    return buttons;
  }

  Widget overlayIndicator () {
    return AnimatedBuilder(
      animation: overlayCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, -overlayCont.value*100, 0, 1,
          ),
          child: Opacity(
            opacity: (-(overlayCont.value*100) + 50).abs()/50,
            child: Container(
              height: 10,
              width: 10,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: (overlayCont.value < 0.5) ? Image.asset(utils.resourceManager.images.upIndicator) : Image.asset(utils.resourceManager.images.downIndicator),
              ),
            ),
          ),
        );
      },
    );
  }
}
