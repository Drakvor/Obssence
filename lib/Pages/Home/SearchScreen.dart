import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Widget/CustomButton.dart';
import 'package:luxury_app_pre/Widget/CustomSearchBar.dart';

class SearchScreen extends StatefulWidget {

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController textControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: utils.resourceManager.colours.background,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            buildMainColumn(),
          ],  
        ),
      ),
    );
  }

  Widget buildMainColumn () {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Container(
            width: 300,
            child: Text("사라님,", style: utils.resourceManager.textStyles.base18_100,),
          ),
          Container(
            width: 300,
            child: Text("어서오세요. 오늘은 무엇을 도와드릴까요?", style: utils.resourceManager.textStyles.base18_100,),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Center(
              child:  CustomSearchBar(textControl, "검색", onSubmit: () async {
                await utils.dataManager.getSearchData();
                utils.appManager.toSearchResultsPage(context,utils.pageNav);
              }),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            width: 300,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomButton(
                  whenPressed: () {
                    utils.appManager.toBrowsePage(context, utils.pageNav);
                  },
                  text: "그냥 놀러와 봤어",
                  style: utils.resourceManager.textStyles.base14,
                  h: 32,
                  w: 127
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
            width: 300,
            child: Align(
              alignment: Alignment.centerLeft,
              child: CustomButton(
                  whenPressed: () {
                    utils.dataManager.setTextInput("New");
                    utils.appManager.toSearchResultsPage(context, utils.pageNav);
                  },
                  text: "신상품 보여줘",
                  style: utils.resourceManager.textStyles.base14,
                  h: 32,
                  w: 108
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(),
          ),
        ],
      ),
    );
  }
}
