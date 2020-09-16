class UserData {
  bool isSnsLogin = false;
  String profileImgUrl;
  String name;
  String snsId;
  String tokenId;

  UserData(
      {this.isSnsLogin = false,
      this.profileImgUrl = '',
      this.name = '사용자',
      this.snsId = '',
      this.tokenId});

  String getId() {
    if (isSnsLogin) {
      return snsId;
    } else {
      return tokenId;
    }
  }
}
