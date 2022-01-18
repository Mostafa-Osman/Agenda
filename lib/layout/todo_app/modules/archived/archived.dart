import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/todo_app/modules/tasks/tasks.dart';
import 'package:todo/layout/todo_app/shared/cubit/AppCubit.dart';
import 'package:todo/layout/todo_app/shared/cubit/states.dart';


class ArchivedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, ToDoStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = AppCubit.get(context).archivedTasks;
        return tasksBuilder(tasks: tasks, text: "Archived");
      },
    );
  }
}
