import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/layout/todo_app/shared/components/component.dart';
import 'package:todo/layout/todo_app/shared/cubit/AppCubit.dart';
import 'package:todo/layout/todo_app/shared/cubit/states.dart';

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, ToDoStates>(
      listener: (BuildContext context, ToDoStates state) {},
      builder: (BuildContext context, ToDoStates state) {
        var tasks = AppCubit.get(context).newTasks;
        return tasksBuilder(tasks: tasks,text:"Tasks");
      },
    );
  }
}

Widget tasksBuilder({@required List<Map> tasks,@required text}) => ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.grey,
            ),
            Text('No $text Yet, please Add some $text ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
