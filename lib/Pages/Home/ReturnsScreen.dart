import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';
import 'package:luxury_app_pre/Data/Order.dart';
import 'package:luxury_app_pre/Pages/Home/ReturnsScreen/ReturnsListItem.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class ReturnsScreen extends StatefulWidget {

  @override
  _ReturnsScreenState createState() => _ReturnsScreenState();
}

class _ReturnsScreenState extends State<ReturnsScreen> {
  late Future initialised;

  void setPageState () {
    setState(() {
      //do nothing
    });
  }

  @override
  void initState () {
    super.initState();
    initialised = Future.wait([utils.dataManager.getOrderData(), utils.dataManager.getReturnData()]);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initialised,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return buildFramework();
        }
        else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildFramework () {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.transparent,
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: mainHeader(),
                ),
                Expanded(
                  child: mainColumn(),
                ),
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mainHeader () {
    return Container(
      height: 50,
      child: Stack(
        children: [
          Container(
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("취소, 교환, 반품 목록", style: utils.resourceManager.textStyles.base15_700,),
                //plus button
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            width: 50,
            height: 50,
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

  Widget mainColumn () {
    return ListView.builder(
      physics: BouncingScrollPhysics(),
      itemCount: utils.dataManager.user!.returns.listReturns.length,
      itemBuilder: (context, index) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getSelections(utils.dataManager.user!.returns.listReturns[index]),
          ),
        );
      },
    );
  }

  List<Widget> getSelections (ReturnData returns) {
    List<Widget> elements = [];
    elements.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Text("교환일자: " + returns.returnDate.toString().substring(6, 8) + "." + returns.returnDate.toString().substring(4, 6) + "." + returns.returnDate.toString().substring(2, 4), style: utils.resourceManager.textStyles.base14_700,),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: CustomButton(
              whenPressed: () {
                for (int i = 0; i < utils.dataManager.user!.orders.listOrders.length; i++) {
                  if (utils.dataManager.user!.orders.listOrders[i].oid == returns.oid) {
                    utils.appManager.toOrderDetailsPage(context, utils.pageNav, utils.dataManager.user!.orders.listOrders[i]);
                    return;
                  }
                }
              },
              text: "주문번호: " + returns.oid,
              style: utils.resourceManager.textStyles.base12_100,
              w: 130,
              h: 20,
            ),
          ),
        ],
      )
    ); //header with date and stuff
    elements.add(ReturnsListItem(setPageState, returns));
    elements.add(CustomDivider());
    return elements;
  }

  Widget mainFooter () {
    return Container();
  }
}
