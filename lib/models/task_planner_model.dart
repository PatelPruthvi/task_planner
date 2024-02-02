class TaskPlanner {
  int? id;
  String? title;
  String? date;
  String? startTime;
  String? endTime;
  String? description;
  String? category;
  String? hexColorCode;

  TaskPlanner(
      {this.id,
      this.title,
      this.date,
      this.startTime,
      this.endTime,
      this.description,
      this.hexColorCode,
      this.category});

  TaskPlanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    description = json['description'];
    hexColorCode = json['hexColorCode'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['description'] = description;
    data['hexColorCode'] = hexColorCode;
    data['category'] = category;
    return data;
  }
}
