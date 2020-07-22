import 'package:flutter/material.dart';

class UserData with ChangeNotifier {
  String _profileImgUrl = '';
  String _name = '';
  String _kakaoId = '';
  final String tokenId;

  UserData({this.tokenId});

  void addKakaoProfile({String profileImgUrl, String name, String kakaoId}) {
    _profileImgUrl = profileImgUrl;
    _name = name;
    _kakaoId = kakaoId;
    notifyListeners();
  }
}
