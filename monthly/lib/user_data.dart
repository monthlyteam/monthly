import 'package:flutter/material.dart';

class UserData {
  String profileImgUrl;
  String name;
  String kakaoId;
  String tokenId;

  UserData(
      {this.profileImgUrl = '',
      this.name = '',
      this.kakaoId = '',
      this.tokenId});
}
