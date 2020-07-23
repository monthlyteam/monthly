class UserData {
  String profileImgUrl;
  String name;
  int kakaoId;
  String tokenId;

  UserData(
      {this.profileImgUrl = '',
      this.name = '사용자',
      this.kakaoId = 0,
      this.tokenId});
}
