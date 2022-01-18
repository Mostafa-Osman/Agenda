import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/layout/todo_app/modules/archived/archived.dart';
import 'package:todo/layout/todo_app/modules/done/done.dart';
import 'package:todo/layout/todo_app/modules/tasks/tasks.dart';
import 'package:todo/layout/todo_app/shared/cubit/states.dart';


class AppCubit extends Cubit<ToDoStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  var bottomNavigationIndex = 0;
  List<Widget> screens = [
    TasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];

  void changeIndex(index) {
    bottomNavigationIndex = index;
    emit(AppChangeNavBarState());
  }

  bool buttonValue = false;
  IconData buttonSheetIcon = Icons.edit;

  void changeButtonSheetState(
      {@required bool isShow, @required IconData icon}) {
    buttonValue = isShow;
    buttonSheetIcon = icon;
    emit(AppChangeBottomSheetState());
  }



// database
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void createDataBase() {
    openDatabase(
      'database1.db',
      version: 1,
      onCreate: (database, version) {
        print("onCreate");
        database
            .execute(
                'CREATE TABLE Tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT, status TEXT)')
            .then((value) {
          print("onCreate successful");
        }).catchError((error) {
          print(error.toString());
        });
      },
      onOpen: (database) {
        print('onOpen successful');
        getDataFromDatabase(database);
      },
    ).then((value) {
      database = value;
      emit(AppCreateDataBaseState());
    }).catchError((error) => print(error));
  }

  insertToDatabase({
    @required String title,
    @required String time,
    @required String date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO Tasks(title, date, time, status) VALUES("$title", "$date", "$time", "NICE")')
          .then((value) {
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print(error.toString());
      });
      return null;
    });
  }

  void getDataFromDatabase(database) async {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppGetDataFromDatabaseLoadingState());
    database.rawQuery('SELECT * FROM Tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'NICE')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDataFromDatabaseState());
      print(value);
    });
  }

  void updateData(@required String status, @required int id) async {
    database.rawUpdate(
      'UPDATE Tasks SET status = ?  WHERE id = ?',
      ['$status', id],
    ).then((value) {
      getDataFromDatabase(database);
      emit(AppUpDataFromDatabaseLoadingState());
    });
  }

  void deleteData({@required id}) async {
    database.rawDelete('DELETE FROM Tasks WHERE id = ?', [id]).then((value) {
      emit(AppDeleteDataFromDatabaseState());
      getDataFromDatabase(database);
    });
  }
}
