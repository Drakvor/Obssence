class ImageRes {
  static String _base = "assets/images/";

  //Search Bars and Text Fields
  late String searchBarImage = _base + "CustomSearchBar.png";
  late String searchBarImageInactive = _base + "CustomSearchBarInactive.png";
  late String phoneNumberField = _base + "PhoneNumberField.png";
  late String phoneNumberFieldInactive = _base + "PhoneNumberFieldInactive.png";

  late String backspace = _base + "Backspace.png";

  late String roundButton = _base + "ButtonRound.png";
  late String roundButtonPressed = _base + "ButtonRoundPressed.png";

  late String horizLine = _base + "LineHoriz.png";
  late String vertLine = _base + "LineVert.png";

  //Buttons
  late String backButton = _base + "BackButton.png";
  late String frontButton = _base + "FrontButton.png";
  late String closeButton = _base + "CloseButton.png";
  late String cartButton = _base + "CartButton.png";
  late String downButton = _base + "DownButton.png";
  late String moreButton = _base + "MoreButton.png";
  late String likeButton = _base + "LikeButton.png";
  late String likeButtonPressed = _base + "LikeButtonPressed.png";

  //Indicators
  late String downIndicator = _base + "DownIndicator.png";
  late String upIndicator = _base + "UpIndicator.png";

  //Colours
  late Map<String, String> colours = {
    "orange": _base + "Orange.png",
    "blue": _base + "Blue.png",
    "green": _base + "Green.png",
    "white": _base + "White.png",
    "black": _base + "Black.png",
    "grey": _base + "Grey.png",
  };
}