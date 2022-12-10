class UserList {
  final String? userName;
  final int userId;

  UserList.fromJson(Map<dynamic, dynamic> json)
      : userName = json['userName'],
        userId = json['userId'];

  UserList(this.userName, this.userId);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'userName': userName,
        'userId': userId,
      };
}
