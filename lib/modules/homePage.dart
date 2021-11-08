import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app_full/shared/components/components.dart';
import 'package:to_do_app_full/shared/cubit/cubit.dart';
import 'package:to_do_app_full/shared/cubit/states.dart';
import 'package:buildcondition/buildcondition.dart';

class home extends StatelessWidget {
  final String thetitle;

  home({Key? key, required this.thetitle}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();

  //----------------Ui------------------------
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      //AppCubit()..createDatabase() meaning first state it's create data base not initital state
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppState>(
        listener: (BuildContext context, AppState state) {},
        builder: (BuildContext context, AppState state) {
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(thetitle,style: TextStyle(color: Colors.grey[200]),),
            ),
            bottomNavigationBar: myNavigationBar(
              currectindex: AppCubit.get(context).currectIndex,
              itmes: AppCubit.get(context).items,
              OnTabFunc: (index) {
                //with bloc method
                AppCubit.get(context).changePageIndex(index);
              },
            ),
            body:
                //---make circular loading process before getting the data from database
                BuildCondition(
              condition: state is! AppLoadingDataBaseState,
              builder: (context) => AppCubit.get(context)
                  .pages[AppCubit.get(context).currectIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (AppCubit.get(context).sheetOpen) {
                  //here if there is no  data in fields then i can close the sheet,and change the icon to add button
                  if (!formKey.currentState!.validate() ||
                      formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    //with bloc method
                    AppCubit.get(context).cleanDataFromsheet();
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => mySheetWindow(
                            BackGroundColor: Colors.grey[50],
                            RadiusCircularValue: 15.0,
                            shadowBorderColor: Colors.lightBlueAccent,
                            ChildrenList: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: myForm(formKey: formKey, textfields: [
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  CostumTextField(
                                      Controller: AppCubit.get(context)
                                          .titleTextController,
                                      obscuretext: false,
                                      labelText: "عنوان المهمة",
                                      keyboardType: TextInputType.text,
                                      icon: Icons.title,
                                      printedError: "الرجاء ادخل المهمة"),
                                  CostumTextField(
                                      Controller: AppCubit.get(context)
                                          .timeTextController,
                                      obscuretext: false,
                                      labelText: "الوقت",
                                      keyboardType: TextInputType.none,
                                      icon: Icons.watch_later_outlined,
                                      printedError: "الرجاء ادخل الوقت",
                                      ontap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          AppCubit.get(context)
                                                  .timeTextController
                                                  .text =
                                              value!.format(context).toString();
                                        });
                                      }),
                                  CostumTextField(
                                      Controller: AppCubit.get(context)
                                          .dateTextController,
                                      obscuretext: false,
                                      labelText: "التاريخ",
                                      keyboardType: TextInputType.none,
                                      icon: Icons.calendar_today,
                                      printedError: "الرجاء اختر التاريخ",
                                      ontap: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate:
                                              DateTime.parse('2022-12-30'),
                                        ).then((value) {
                                          AppCubit.get(context)
                                                  .dateTextController
                                                  .text =
                                              DateFormat.yMMMd().format(value!);
                                        });
                                      }),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                ]),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    AppCubit.get(context).insertToDatabase(
                                        title: AppCubit.get(context)
                                            .titleTextController
                                            .text,
                                        date: AppCubit.get(context)
                                            .dateTextController
                                            .text,
                                        time: AppCubit.get(context)
                                            .timeTextController
                                            .text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: const Text(
                                                "تمت اضافة الواجب")));
                                    //for close the sheet after adding
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text('إضافة'),
                              ),
                            ]),
                      )
                      .closed
                      .then((value) {
                    //if sheet closed by hand
                    //with bloc method
                    AppCubit.get(context).cleanDataFromsheet();
                  });
                  AppCubit.get(context).sheetOpen = true;
                  //change icon with bloc
                  AppCubit.get(context).changeFlotingButtonIcon();
                }
              },
              child: Icon(AppCubit.get(context).theIconOfAddingTask),
            ),
          );
        },
      ),
    );
  }
}
