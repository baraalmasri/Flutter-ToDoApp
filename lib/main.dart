import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_full/shared/cubit/observer.dart';


import 'modules/homePage.dart';

void main() {
  //-----for watching the app states in background
  Bloc.observer = MyBlocObserver();
  //------------------------------
  String title = "المهام اليومية";
  runApp(
    MaterialApp(
        title: title,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          //long holding color
          splashColor:Colors.blueGrey[900],
          textTheme: const TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold ,),
            headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.normal),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          primaryColor:Colors.pinkAccent,
          primarySwatch: Colors.lightBlue,
        ),
        home: home(
          thetitle: title,
        )),
  );
}
