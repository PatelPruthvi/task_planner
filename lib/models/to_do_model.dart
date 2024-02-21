class ToDoModel {
  int? id;
  String? title;
  String? date;
  bool? isCompleted;

  ToDoModel({this.id, this.title, this.date, this.isCompleted});

  ToDoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    isCompleted = json['isCompleted'] == 1 ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['isCompleted'] = isCompleted == true ? 1 : 0;

    return data;
  }
}
