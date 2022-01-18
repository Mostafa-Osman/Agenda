import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/layout/todo_app/shared/cubit/AppCubit.dart';
import 'package:todo/layout/todo_app/shared/cubit/states.dart';


class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, ToDoStates>(
        listener: (BuildContext context, ToDoStates state) {
          if (state is AppInsertDatabaseState) Navigator.of(context).pop();
        },
        builder: (BuildContext context, ToDoStates state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text("New Tasks"),
            ),
            body: ConditionalBuilder(
              condition: state is AppGetDataFromDatabaseLoadingState,
              builder: (context) => Center(child: CircularProgressIndicator()),
              fallback: (context) => cubit.screens[cubit.bottomNavigationIndex],
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(
                cubit.buttonSheetIcon,
              ),
              onPressed: () {
                if (cubit.buttonValue) {
                  if (formKey.currentState.validate()) {
                    cubit.insertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    titleController = TextEditingController();
                    timeController = TextEditingController();
                    dateController = TextEditingController();
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet((context) {
                        return Container(
                          width: double.infinity,
                          height: 320,
                          color: Colors.grey[200],
                          padding: EdgeInsets.all(10),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: titleController,
                                  // kind of keyboard (text, number, email,...)
                                  keyboardType: TextInputType.text,
                                  // have a value which wrote inside
                                  onFieldSubmitted: (String value) {},
                                  onTap: () {},

                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Empty Value!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Task Title",
                                    prefixIcon: Icon(Icons.title),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: timeController,
                                  // kind of keyboard (text, number, email,...)
                                  keyboardType: null,
                                  // have a value which wrote inside
                                  onFieldSubmitted: (String value) {},
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value.format(context).toString();
                                    }).catchError((error) {});
                                  },

                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Empty Value!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Task Time",
                                    prefixIcon: Icon(Icons.access_time),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: dateController,
                                  // kind of keyboard (text, number, email,...)
                                  keyboardType: TextInputType.text,
                                  // have a value which wrote inside
                                  onFieldSubmitted: (String value) {},
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse("2050-01-01"),
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd()
                                          .format(value)
                                          .toString();
                                    });
                                  },
                                  validator: (String value) {
                                    if (value.isEmpty) {
                                      return "Empty Value!!";
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Task Date",
                                    prefixIcon: Icon(Icons.date_range),
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })
                      .closed
                      .then((_) {
                        cubit.changeButtonSheetState(
                            isShow: false, icon: Icons.edit);
                      });
                  cubit.changeButtonSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              selectedFontSize: 20,
              unselectedFontSize: 18,
              currentIndex: cubit.bottomNavigationIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.view_headline_sharp),
                  label: "Tasks",
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outlined), label: "done"),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive),
                  label: "archived",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
