import 'dart:convert';

class Task {
  int? id;
  String? title;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  String? note;
  int? user;
  int? project;

  Task(
      {this.id,
      this.title,
      this.isCompleted,
      this.date,
      this.startTime,
      this.endTime,
      this.color,
      this.remind,
      this.repeat,
      this.note,
      this.project,
      this.user});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json["title"];
    isCompleted = json["isCompleted"];
    date = json["date"];
    startTime = json["startTime"];
    endTime = json["endTime"];
    color = json["color"];
    remind = json["remind"];
    repeat = json["repeat"];
    note = json["note"];
    project = json["project"];
    user = json["user"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = id;
    data["title"] = title;
    data["isCompleted"] = isCompleted;
    data["date"] = date;
    data["startTime"] = startTime;
    data["endTime"] = endTime;
    data["color"] = color;
    data["remind"] = remind;
    data["repeat"] = repeat;
    data["note"] = note;
    data["project"] = project;
    data["user"] = user;
    return data;
  }
}
