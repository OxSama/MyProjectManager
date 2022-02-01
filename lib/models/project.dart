class Project {
  int? id;
  String? name;
  int? owner;

  Project({
    this.id,
    this.name,
    this.owner,
  });

  Project.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json["owner"];
    name = json["name"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["owner"] = owner;
    return data;
  }
}
