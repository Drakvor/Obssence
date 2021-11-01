import 'package:flutter/material.dart';
import 'package:luxury_app_pre/Management/Utils.dart';

class AgentManager {
  String searchString = "";
  List<String> searchTags = [];

  void act (BuildContext context, String action) {
    switch (action) {
      case "cart":
        utils.appManager.toShoppingPage(context, utils.pageNav);
        break;
      default:
        //utils.appManager.getSearchTags(context);
        utils.appManager.toSearchPage(context, utils.pageNav);
    }
  }

  void notify () {
    //do nothing
  }

  void setSearchString (String data) {
    searchString = data;
  }

  void setSearchTags (List<String> data) {
    searchTags = data;
  }

  void getAction (BuildContext context) {
    for (int i = 0; i < utils.dataManager.tags!.serviceTagsFinal!.length; i++) {
      if (searchString.contains(utils.dataManager.tags!.serviceTagsFinal![i])) {
        utils.agentManager.act(context, utils.dataManager.tags!.serviceTagsFinal![i]);
      }
    }
    utils.agentManager.act(context, "search");
  }

  void getSearchTags (BuildContext context) {
    //do nothing
    for (int i = 0; i < utils.dataManager.tags!.itemTagsFinal!.length; i++) {

    }
    searchTags = ["Gucci", "New"];
  }
}