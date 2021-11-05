import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:luxury_app_pre/Management/Utils.dart';
import 'package:luxury_app_pre/Data/Item.dart';

class SearchBar extends StatefulWidget {
  SearchBar({
    Key? key,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List<String> _dataFound = [];
  Image _searchIcon = Image.asset(utils.resourceManager.images.roundButton);

  @override
  _SearchBarState() {
    _filter.addListener(() {
      print(_filter.text);
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          onTap: () {
            setState(() {
              _searchText = _filter.text;
              _getFirebaseData();
              print(_dataFound.length);
            });
          },
          controller: _filter,
          decoration: InputDecoration(
            prefixIcon: _searchIcon,
            hintText: "Search Bar",
            hintStyle: utils.resourceManager.textStyles.base18_100,
          ),
          style: utils.resourceManager.textStyles.base18_100,
        ),
        _buildResultList(),
      ]
    );
  }

  void _getFirebaseData () {
    setState(() {
      print(_searchText);
      print("Getting data.");
      CollectionReference _collectionRef = FirebaseFirestore.instance.collection('selections');
      print("Got reference");
      Future<void> getData() async {
        // Get docs from collection reference
        QuerySnapshot querySnapshot = await _collectionRef.get();
        print("Queried");

        // Get data from docs and convert map to List
        final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
        _dataFound = [];
        if (_searchText != "") {
          for (int i = 0; i < allData.length; i++) {
            String dataString = allData[i].toString();
            print(dataString);
            print(dataString.indexOf(_searchText));
            if (dataString.indexOf(_searchText) != -1) {
              _dataFound.add(dataString);
            }
            print(_dataFound.length);
          }
        }
        print("Done");
      }
      getData();
    });
  }

  Widget _buildResultList() {
    if (_dataFound.length >= 1) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: _dataFound.length,
        itemBuilder: (BuildContext context, int index) {
          return new ListTile(
            title: Text(_dataFound[index]),
            onTap: () => print(_dataFound[index]),
          );
        },
      );
    } else {
      return Container(width:10, height:10);
    }
  }
}
