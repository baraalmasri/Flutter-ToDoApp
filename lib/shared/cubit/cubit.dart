import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app_full/shared/components/components.dart';
import 'package:to_do_app_full/shared/cubit/states.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());

  //make instance for all pages or layouts
  static AppCubit get(context) => BlocProvider.of(context);

  //----database----------------------
  List<Map> tasks = [];
  List<Map> doneTasks = [];
  List<Map> acrhviedTasks = [];
  late Database database;

  void createDatabase() {
    // get the currect path of main folder
    // var databasesPath =   getDatabasesPath();
    // // adding the path to the name of database to be full path ex: ../folder1/folder2/folder3/todo_.db
    //
    // String path = join(databasesPath, 'to_do.db');

    openDatabase('to_do.db', version: 1, onCreate: (database, version) {
      print('database created');

      //create tables with error handler using ,then method
      //after execute SQL command print table created and print error if not executed
      database
          .execute(
              "CREATE TABLE tasks (id INTEGER PRIMARY KEY ,title TEXT ,time TEXT , date TEXT , status TEXT )")
          .then((value) {
        print("table created");
      }
              //look like try catch method
              ).catchError((error) {
        print("error after creating table ${error}");
      });
    }, onOpen: (database) {
      getDataFromDatabase(database);

      print('database opend');
    }).then((value) {
      // like setState but in bloc
      database = value;
      emit(AppCreateDataBaseState());
    });
  }

  void insertToDatabase(
      {required String title,
      required String time,
      required String date}) async {
    await database.transaction((txn) => txn
            .rawInsert(
                'INSERT INTO tasks(title,time,date,status)VALUES("${title}","${time}","${date}","new")')
            .then((value) {
          emit(AppInsertDataBaseState());
          print("insert successfuly ${value}");
          // re-read from database again to show the inserted data
          getDataFromDatabase(database);
        }).catchError((Error) =>
                print("error when inserting new row ${Error.toString()}")));
    return null;
  }

  void getDataFromDatabase(database) {
    emit(AppLoadingDataBaseState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      tasks = [];
      doneTasks = [];
      acrhviedTasks = [];
//3 list for done and new and archived
      value.forEach((element) {
        if (element['status'] == 'new') {
          tasks.add(element);
          emit(AppReadDataBaseState());
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
          emit(AppReadDataBaseState());
        } else {
          acrhviedTasks.add(element);
          emit(AppReadDataBaseState());
        }
      });
      emit(AppReadDataBaseState());
    });
  }

  void updateData({required String status, required int id}) async {
    await database.rawUpdate('UPDATE tasks SET status=?   WHERE id =?',
        ['$status', id]).then((value) {
      //set update state bloc

      // for reload the data after update
      getDataFromDatabase(database);
      emit(AppUpdateDataBaseState());
    });
  }

  void deleteData({
  required int id ,
}){
    database.rawDelete('DELETE FROM tasks WHERE id = ?',[id]).then((value) {
      // for reload the data after update
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState ());

    });
  }
//-------------------------------------------------------+

//-----------------navigation bar bottoms and screens changes -------------
  List<Widget> pages = [

    BodyWithSeparatedList('new'),
    BodyWithSeparatedList('done'),
    BodyWithSeparatedList('archived'),
  ];
  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
        icon: Icon(Icons.task_alt_outlined),
        label: 'أخر المهام',
        backgroundColor: Colors.red),
    BottomNavigationBarItem(
        icon: Icon(
          Icons.done,
          color: Colors.greenAccent[500],
        ),
        label: 'المهام التامة',
        backgroundColor: Colors.red),
    BottomNavigationBarItem(
        icon: Icon(Icons.archive),
        label: 'المهام المؤرشفة ',
        backgroundColor: Colors.red),
  ];

  int currectIndex = 0;

  void changePageIndex(index) {
    currectIndex = index;
    emit(changeNavBarPageState());
  }

  //---------------------general varibale ----------------------------------
  TextEditingController titleTextController = new TextEditingController();
  TextEditingController dateTextController = new TextEditingController();
  TextEditingController timeTextController = new TextEditingController();
  TextEditingController statusTextController = new TextEditingController();
  IconData theIconOfAddingTask = Icons.add;
  List<Widget> children = [];

  bool sheetOpen = false;

  void cleanDataFromsheet() {
    //for remove the data from fields
    titleTextController.text = "";
    dateTextController.text = "";
    timeTextController.text = "";
    sheetOpen = false;
    theIconOfAddingTask = Icons.add;

    emit(cleanSheet());
  }

  void changeFlotingButtonIcon() {
    theIconOfAddingTask = Icons.keyboard_arrow_down;
    emit(changeFlotingActionButtonIconState());
  }
}
