class SearchTags {
  Map<dynamic, dynamic>? itemTags;
  Map<dynamic, dynamic>? serviceTags;
  List<String>? itemTagsFinal;
  List<String>? serviceTagsFinal;
  SearchTags({this.itemTags, this.serviceTags, this.itemTagsFinal, this.serviceTagsFinal});

  void setItemTags (Map<dynamic, dynamic> data) {
    itemTags = data;
  }

  void setServiceTags (Map<dynamic, dynamic> data) {
    serviceTags = data;
  }

  void setItemTagsFinal (List<String> data) {
    itemTagsFinal = data;
  }

  void setServiceTagsFinal (List<String> data) {
    serviceTagsFinal = data;
  }
}