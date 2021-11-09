import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iamport_flutter/iamport_payment.dart';
import 'package:iamport_flutter/model/payment_data.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class ProcessPaymentsScreen extends StatefulWidget {
  final String payMethod;
  ProcessPaymentsScreen(this.payMethod);

  @override
  _ProcessPaymentsScreenState createState() => _ProcessPaymentsScreenState(payMethod);
}

class _ProcessPaymentsScreenState extends State<ProcessPaymentsScreen> {
  final String payMethod;
  _ProcessPaymentsScreenState(this.payMethod);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          getContent(),
        ],
      ),
    );
  }

  Widget getContent () {
    print(payMethod);
    if (payMethod == "card") {
      return getPayment();
    }
    if (payMethod == "trans") {
      return getPayment();
    }
    if (payMethod == "cash") {
      return Container();
    }
    return Container();
  }

  Widget getPayment () {
    return IamportPayment(
      userCode: "imp00579348",
      data: PaymentData(
        pg: 'html5_inicis',
        payMethod: payMethod, // card: 카드, trans: 계좌이체, vbank: 가상계좌, phone: 휴대폰 소액 결제
        amount: 3000,
        merchantUid: UniqueKey().toString(),
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
      callback: (Map<String, String> results) async {
        //do nothing
        if (results["success"] == "true") {
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
        utils.appManager.toPostPaymentPage(context, utils.pageNav, results);
      },
    );
  }
}
