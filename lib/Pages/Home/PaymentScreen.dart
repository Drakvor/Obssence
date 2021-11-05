import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class PaymentScreen extends StatefulWidget {
  final double price;
  final double discount;
  PaymentScreen(this.price, this.discount);

  @override
  _PaymentScreenState createState() => _PaymentScreenState(price, discount);
}

class _PaymentScreenState extends State<PaymentScreen> {
  double price;
  double discount;
  String date = "";
  _PaymentScreenState(this.price, this.discount);

  int chosenOption = -1;
  List<String> options = ["card", "trans", "cash", "store"];

  @override
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
                  child: Center(
                    child: Text("주문 내용을 확인하였으며, 정보제공 등에 동의 합니다.", style: utils.resourceManager.textStyles.base14,),
                  ),
                ),
                CustomThinDivider(),
                buildButton(),
              ],
            ),
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
                    Text("계좌이체", style: utils.resourceManager.textStyles.base12_700,),
                    Container(
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: buttonImage(2),
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
                            Text("날짜", style: utils.resourceManager.textStyles.base12grey,),
                            CustomRoundButton(
                              whenPressed: () {},
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
                      child: buttonImage(3),
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
                        Text("매장결제", style: utils.resourceManager.textStyles.base12_700),
                        Container(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("날짜", style: utils.resourceManager.textStyles.base12grey,),
                            CustomRoundButton(
                              whenPressed: () {},
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
                      child: buttonImage(4),
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
                    Text("￦" + price.toInt().toString(), style: utils.resourceManager.textStyles.base13_100,),
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
                    Text("￦" + discount.toInt().toString(), style: utils.resourceManager.textStyles.base13_700gold,),
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
                    Text("￦" + (price - discount).toInt().toString(), style: utils.resourceManager.textStyles.base14_700,),
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
          utils.dataManager.postOrder(utils.dataManager.user!.cart.listSelections); //To E-count
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
          await utils.dataManager.getUserData();
          utils.appManager.toPostPaymentPage(context, utils.pageNav, {"Hi": "Hi"});
        },
        text: "결제",
        style: utils.resourceManager.textStyles.base,
        w: 120,
        h: 25,
      ),
    );
  }

  Widget executePayment () {
    return IamportPayment(
      userCode: "imp00579348",
      data: PaymentData(
        pg: 'html5_inicis',
        payMethod: 'card', // card: 카드, trans: 계좌이체, vbank: 가상계좌, phone: 휴대폰 소액 결제
        amount: 3000,
        merchantUid: 's2f34gh9jd2',
        name: 'Test',
        buyerName: '권가람',
        buyerTel: '010-6580-9860',
        appScheme: 'luxury_app',
      ),
      initialChild: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("결제중..."),
              Container(
                padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Text('잠시만 기다려주세요...', style: TextStyle(fontSize: 20.0)),
              ),
            ],
          ),
        ),
      ),
      callback: (Map<String, String> result) async {
        //do nothing
        if (result["success"] == "true") {
          utils.dataManager.postOrder(utils.dataManager.user!.cart.listSelections); //To E-count
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
          await utils.dataManager.getUserData();
        }
        //move to next page
      },
    );
  }
}
