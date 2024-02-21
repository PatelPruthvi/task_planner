// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:task_planner/models/enum_models.dart';
import 'package:task_planner/utils/fonts/font_size.dart';

import 'package:task_planner/utils/widgets/utils.dart';
import 'package:task_planner/views/to_do_view/bloc/to_do_bloc.dart';

class TaskTemplateScreen extends StatelessWidget {
  final ToDoBloc toDoBloc;
  const TaskTemplateScreen({Key? key, required this.toDoBloc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Row(
        children: [
          Utils.getAppLogoForAppBar(context),
          const Text("Task Templates")
        ],
      )),
      body: ListView.builder(
        itemCount: defaultTemplates.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              leading: Text(
                defaultTemplateIcon[index],
                style: FontSize.getToDoItemTileTextStyle(context),
              ),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(defaultTemplates[index]),
              ),
              trailing: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    toDoBloc.add(ToDoAddTaskClickedEvent(
                        "${defaultTemplateIcon[index]} ${defaultTemplates[index]}"));
                  },
                  child: Text(
                    "ADD",
                    style: FontSize.getToDoItemTileTextStyle(context).copyWith(
                        color: Theme.of(context).appBarTheme.backgroundColor),
                  )),
            ),
          );
        },
      ),
    );
  }
}
