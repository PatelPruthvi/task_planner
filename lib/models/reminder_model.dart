// ignore_for_file: public_member_api_docs, sort_constructors_first
class ReminderModel {
  int? id;
  String? title;
  String? date;
  bool? isCompleted;
  String? category;
  String? completionTime;
  String? reminder;
  String? repeat;

  ReminderModel(
      {this.id,
      this.title,
      this.date,
      this.isCompleted,
      this.category,
      this.completionTime,
      this.reminder,
      this.repeat});

  ReminderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    date = json['date'];
    isCompleted = json['isCompleted'] == 1 ? true : false;
    category = json['category'];
    completionTime = json['completionTime'];
    reminder = json['reminder'];
    repeat = json['repeat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['isCompleted'] = isCompleted == true ? 1 : 0;
    data['category'] = category;
    data['completionTime'] = completionTime;
    data['reminder'] = reminder;
    data['repeat'] = repeat;
    return data;
  }
}
