import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/todo_app/modules/tasks/tasks.dart';
import 'package:todo/layout/todo_app/shared/cubit/AppCubit.dart';
import 'package:todo/layout/todo_app/shared/cubit/states.dart';


class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, ToDoStates>(
      listener: (BuildContext context, ToDoStates state) {},
      builder: (BuildContext context, ToDoStates state) {
        var tasks = AppCubit.get(context).doneTasks;
        return tasksBuilder(tasks: tasks,text:"Done");
      },
    );
  }
}
