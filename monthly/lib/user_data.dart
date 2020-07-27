class UserData {
  bool isKakaoLogin = false;
  String profileImgUrl;
  String name;
  String kakaoId;
  String tokenId;

  UserData(
      {this.isKakaoLogin = false,
      this.profileImgUrl = '',
      this.name = '사용자',
      this.kakaoId = '',
      this.tokenId});

  String getId() {
    if (isKakaoLogin) {
      return kakaoId;
    } else {
      return tokenId;
    }
  }
}
