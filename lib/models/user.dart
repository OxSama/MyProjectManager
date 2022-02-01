class User {
  int? id;
  String? name;
  String? password;
  String? username;
  User({this.id, this.name, this.username, this.password});
  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json["name"];
    username = json["username"];
    password = json["password"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["username"] = username;
    data["password"] = password;
    return data;
  }
}
