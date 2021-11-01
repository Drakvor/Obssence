import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class PostPaymentScreen extends StatelessWidget {
  final Map<String, String> results;
  PostPaymentScreen(this.results);

  @override
  Widget build (BuildContext context) {
    return buildScaffold(context);
  }

  Widget buildScaffold (BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        utils.appManager.toSearchPage(context, utils.pageNav);
        return false;
      },
      child: Scaffold(
        backgroundColor: utils.resourceManager.colours.transparent,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 50,
                  child: mainHeader(context),
                ),
                Expanded(
                  child: mainColumn(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget mainHeader (BuildContext context) {
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
                Text("구매 완료", style: utils.resourceManager.textStyles.base15_700,),
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
                utils.appManager.toSearchPage(context, utils.pageNav);
              },
              image: utils.resourceManager.images.backButton,
              imagePressed: utils.resourceManager.images.backButton,
              h: 40,
              w: 40,
            ),
          ),
        ],
      ),
    );
  }

  Widget mainColumn (BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Text("감사합니다. 구매가 완료 되었습니다. 해당상품은 안전하게 배송하도록 하겠습니다.", style: utils.resourceManager.textStyles.base14,),
        ),
        CustomDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("구매상품", style: utils.resourceManager.textStyles.base12),
              ),
              Container(
                width: MediaQuery.of(context).size.width*(3/4),
                child: Text("구찌 외 5건", style: utils.resourceManager.textStyles.base12, textAlign: TextAlign.end,),
              ),
            ],
          ),
        ),
        CustomThinDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("성명", style: utils.resourceManager.textStyles.base12),
              ),
              Container(
                width: MediaQuery.of(context).size.width*(3/4),
                child: Text("김새라", style: utils.resourceManager.textStyles.base12, textAlign: TextAlign.end,),
              ),
            ],
          ),
        ),
        CustomThinDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text("배송지", style: utils.resourceManager.textStyles.base12),
              ),
              Container(
                width: MediaQuery.of(context).size.width*(3/4),
                child: Text("경기도 성남시 분당구 서현동 91 시번한양 아파트 327동 1309호", style: utils.resourceManager.textStyles.base12, textAlign: TextAlign.end,),
              ),
            ],
          ),
        ),
        CustomThinDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("총 상품 가격: ", style: utils.resourceManager.textStyles.base12),
                    ),
                    Container(
                      child: Text("₩9325000", style: utils.resourceManager.textStyles.base13),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("배송비: ", style: utils.resourceManager.textStyles.base12),
                    ),
                    Container(
                      child: Text("₩9325000", style: utils.resourceManager.textStyles.base13),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("할인: ", style: utils.resourceManager.textStyles.base12),
                    ),
                    Container(
                      child: Text("- ₩4235000", style: utils.resourceManager.textStyles.base13_700gold),
                    ),
                  ],
                ),
              ),
              CustomDottedDividerLong(),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text("합계: "),
                    ),
                    Container(
                      child: Text("₩9325000", style: utils.resourceManager.textStyles.base13_700gold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        CustomDivider(),
        Container(
          margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CustomButton(
                  whenPressed: () {},
                  style: utils.resourceManager.textStyles.base14,
                  text: "주문상세 보기",
                  w: 105,
                  h: 30,
                ),
              ),
              Container(
                width: 20,
              ),
              Container(
                child: CustomButton(
                  whenPressed: () {
                    utils.pageNav.currentState!.pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return BrowseScreen();
                        },
                      )
                    );
                  },
                  style: utils.resourceManager.textStyles.base14,
                  text: "쇼핑 계속하기",
                  w: 105,
                  h: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
