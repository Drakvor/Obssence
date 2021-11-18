import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Pages/Home/BrowseScreen/BrowseItemTile.dart';
import 'package:luxury_app_pre/Widget/CustomDivider.dart';
import 'package:luxury_app_pre/Widget/CustomRoundButton.dart';

class SearchResultsScreen extends StatefulWidget {

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: utils.resourceManager.colours.background,
      body: Stack(
        children: [
          Column(
            children: [
              buildHeader(),
              CustomDivider(),
              Expanded(
                child: buildGridView(context),
              ),
            ],
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
                Text("검색 결과", style: utils.resourceManager.textStyles.base15,),
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

  Widget buildGridView (BuildContext context) {
    if (utils.dataManager.items!.length == 0) {
      return Container(
        child: Center(
          child: Text("검색 결과가 없습니다.", style: utils.resourceManager.textStyles.base14_700,),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: ((utils.dataManager.items!.length)~/2),
      itemBuilder: (context, index) {
        return Column(
          children: [
            (index == 0) ? Container(height: 20,) : Container(height: 0,),
            CustomThreeCrossDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                  child: BrowseItemTile(utils.dataManager.items![2*index]),
                ),
                (2*index + 1 < utils.dataManager.items!.length) ? Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                  child: BrowseItemTile(utils.dataManager.items![2*index + 1]),
                ) : Container(
                  margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: (MediaQuery.of(context).size.width - 40)/2,
                  height: (MediaQuery.of(context).size.width * 0.6),
                ),
              ],
            ),
            (index == ((utils.dataManager.items!.length)~/2) - 1) ? CustomThreeCrossDivider() : Container(height: 0,),
            (index == ((utils.dataManager.items!.length)~/2) - 1) ? Container(height: 20,) : Container(height: 0,),
          ],
        );
      },
    );
  }
}
