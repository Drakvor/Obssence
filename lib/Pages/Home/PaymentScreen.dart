import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';
import 'package:luxury_app_pre/Pages/Home/PaymentScreen/ReservationCalendar.dart';
import 'package:luxury_app_pre/Pages/Home/PaymentScreen/ReservationState.dart';
import 'package:luxury_app_pre/Pages/Home/PaymentScreen/ReservationTimes.dart';

class PaymentScreen extends StatefulWidget {
  final double price;
  final double discount;
  PaymentScreen(this.price, this.discount);

  @override
  _PaymentScreenState createState() => _PaymentScreenState(price, discount);
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  double price;
  double discount;
  String date = "";
  late AnimationController reserveCont;
  ReservationState resState = ReservationState();
  _PaymentScreenState(this.price, this.discount);

  int chosenOption = -1;
  List<String> options = ["card", "trans", "cash", "store"];

  @override
  void initState () {
    super.initState();
    reserveCont = new AnimationController.unbounded(vsync: this, value: 500);
  }

  void dispose () {
    reserveCont.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
      body: Stack(
        children: [
          Container(
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                buildHeader(),
                buildAddress(),
                CustomDivider(),
                Container(
                  child: buildOptions(),
                ),
                CustomDivider(),
                Container(
                  child: buildSummary(),
                ),
                CustomDivider(),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("개인정보 제공 동의: OBSSENCE 약관 - ", style: utils.resourceManager.textStyles.base12,),
                      CustomButton(
                        whenPressed: () {
                          utils.appManager.toTermsConditionsPage(context, utils.pageNav);
                        },
                        text: "상세보기",
                        style: utils.resourceManager.textStyles.base10,
                        w: 50,
                        h: 20,
                      ),
                    ],
                  ),
                ),
                CustomThinDivider(),
                Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Center(
                    child: Text("주문 내용을 확인하였으며, 정보제공 등에 동의 합니다.", style: utils.resourceManager.textStyles.base14,),
                  ),
                ),
                CustomThinDivider(),
                buildButton(),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () async {
                //do nothing (for real though)
                await reserveCont.animateTo(500, duration: Duration(milliseconds: 200), curve: Curves.linear);
                setState(() {
                  resState.state = 0;
                });
              },
              child: buildCoverScreen(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: (MediaQuery.of(context).size.width > 299) ? MediaQuery.of(context).size.width : 300,
            child: getReservation(),
          ),
        ],
      ),
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
                Text("총 갯수: ", style: utils.resourceManager.textStyles.baseBold,),
                Text(utils.dataManager.user!.cart.listSelections.length.toString(), style: utils.resourceManager.textStyles.dots,),
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

  Widget buildAddress () {
    return Container(
      height: 100,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: 80,
            child: Text("배송지", style: utils.resourceManager.textStyles.base12_100,),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Text(utils.dataManager.user!.firstName + " " + utils.dataManager.user!.lastName, style: utils.resourceManager.textStyles.base12,),
                ),
                Container(
                  child: Text(utils.dataManager.user!.phoneNumber, style: utils.resourceManager.textStyles.base12grey,),
                ),
                Container(
                  child: Text(utils.dataManager.user!.address, style: utils.resourceManager.textStyles.base12,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOptions () {
    return Row(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: 80,
          child: Text("결제수단", style: utils.resourceManager.textStyles.base12_100,),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("신용카드", style: utils.resourceManager.textStyles.base12_700,),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: buttonImage(0),
                    ),
                  ],
                ),
              ),
              CustomThinDivider(),
              Container(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("계좌이체", style: utils.resourceManager.textStyles.base12_700,),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: buttonImage(1),
                    ),
                  ],
                ),
              ),
              CustomThinDivider(),
              Container(
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("현금결제", style: utils.resourceManager.textStyles.base12_700),
                        Container(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text((resState.date == 0) ? "날짜" : "2021년 10월 " + resState.date.toString() + "일", style: utils.resourceManager.textStyles.base12grey,),
                            CustomRoundButton(
                              whenPressed: () {
                                reserveCont.animateTo(50, duration: Duration(milliseconds: 200), curve: Curves.linear);
                              },
                              image: utils.resourceManager.images.moreButton,
                              imagePressed: utils.resourceManager.images.moreButton,
                              w: 20,
                              h: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: buttonImage(2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buttonImage (int index) {
    return GestureDetector(
      onTapDown: (TapDownDetails details) {
        setState(() {
          chosenOption = index;
        });
      },
      child: Container(
        height: 40,
        width: 40,
        child: Stack(
          children: [
            Container(
              height: 40,
              width: 40,
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: (index == chosenOption) ? Image.asset(utils.resourceManager.images.roundButtonPressed) : Image.asset(utils.resourceManager.images.roundButton),
              ),
            ),
            Center(
              child: Container(
                height: 20,
                width: 20,
                child: Center(
                  child: Image.asset(utils.resourceManager.images.downButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSummary () {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 20, 0),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            width: 80,
            child: Text("결제상세", style: utils.resourceManager.textStyles.base12_100,),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("총 상품 가격: ", style: utils.resourceManager.textStyles.base12_100,),
                    Text("￦" + price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base13_100,),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("배송비: ", style: utils.resourceManager.textStyles.base12_100,),
                    Text("￦0", style: utils.resourceManager.textStyles.base13_100,),
                  ],
                ),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("할인: ", style: utils.resourceManager.textStyles.base12_100,),
                    Text("￦" + discount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base13_700gold,),
                  ],
                ),
                Container(
                  height: 10,
                ),
                CustomDottedDividerLong(),
                Container(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("합계: ", style: utils.resourceManager.textStyles.base14_700,),
                    Text("￦" + (price - discount).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'), style: utils.resourceManager.textStyles.base14_700,),
                  ],
                ),
                Container(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton () {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: CustomButton(
        whenPressed: () async {
          /*utils.dataManager.postOrder(utils.dataManager.user!.cart.listSelections); //To E-count
          //And now to Firebase
          CollectionReference orders = FirebaseFirestore.instance.collection('orders');
          CollectionReference selections = FirebaseFirestore.instance.collection('selections');
          List items = [];
          for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
            items.add(utils.dataManager.user!.cart.listSelections[i].id);
          }
          DocumentReference snapshot = await orders.add(
              {
                "user": utils.dataManager.user!.id,
                "orderDate": DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day,
                "orderStatus": "submitted",
                "returns": [],
                "items": items,
                "trackingId": "",
                "oid": "21102101",
              }
          );
          await orders.doc(snapshot.id).update(
              {
                "id": snapshot.id,
              }
          );
          for (int i = 0; i < utils.dataManager.user!.cart.listSelections.length; i++) {
            await selections.doc(utils.dataManager.user!.cart.listSelections[i].id).update(
                {
                  "parent": snapshot.id,
                }
            );
          }
          //And finally, the application code?
          await utils.dataManager.getUserData();*/
          utils.appManager.toProcessPaymentsPage(context, utils.pageNav, options[chosenOption]);
        },
        text: "결제",
        style: utils.resourceManager.textStyles.base,
        w: 120,
        h: 25,
      ),
    );
  }

  Widget buildCoverScreen () {
    return AnimatedBuilder(
      animation: reserveCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, (reserveCont.value < 500) ? 0 : MediaQuery.of(context).size.height, 0, 1,
          ),
          child: Opacity(
            opacity: (1-(reserveCont.value-50)/450)/2,
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

  Widget getReservation () {
    return AnimatedBuilder(
      animation: reserveCont,
      builder: (context, child) {
        return Transform(
          transform: Matrix4(
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, reserveCont.value, 0, 1,
          ),
          child: child,
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 500,
        decoration: BoxDecoration(
          color: utils.resourceManager.colours.background,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Color(0xff555555),
              offset: Offset(-1, -1),
              spreadRadius: 2,
            ),
          ],
        ),
        child: getReservationOption(),
      ),
    );
  }

  Widget getReservationOption () {
    if (resState.state == 0) {
      return getResCalendar();
    }
    if (resState.state == 1) {
      return getResTime();
    }
    if (resState.state == 2) {
      return getResLocation();
    }
    if (resState.state == 3) {
      return getResConfirm();
    }
    else {
      return Container();
    }
  }

  Widget getResCalendar () {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20,
            child: GestureDetector(
              onTap: () async {
                await reserveCont.animateTo(500, duration: Duration(milliseconds: 200), curve: Curves.linear);
                setState(() {
                  resState.state = 0;
                });
              },
              child: Center(
                child: Image.asset(utils.resourceManager.images.downIndicator),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
            child: Text("몇 일이 편하신가요?", style: utils.resourceManager.textStyles.base14_700,),
          ),
          CustomThinDivider(),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ReservationCalendar(() {setState(() {});}, resState),
          ),
        ],
      ),
    );
  }

  Widget getResTime () {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20,
            child: GestureDetector(
              onTap: () async {
                await reserveCont.animateTo(500, duration: Duration(milliseconds: 200), curve: Curves.linear);
                setState(() {
                  resState.state = 0;
                });
              },
              child: Center(
                child: Image.asset(utils.resourceManager.images.downIndicator),
              ),
            ),
          ),
          Container(
            child: Text("몇 시가 편하신가요?", style: utils.resourceManager.textStyles.base14_700,),
          ),
          Container(
            height: 30,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ReservationTimes(() {setState(() {});}, resState),
          ),
        ],
      ),
    );
  }

  Widget getResLocation () {
    return Container();
  }

  Widget getResConfirm () {
    return Container();
  }
}
