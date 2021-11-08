import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app_full/shared/cubit/cubit.dart';
import 'package:to_do_app_full/shared/cubit/states.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

//---------------------------------------------

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.archive,
            color: Colors.white,
          ),
          Text(
            " Archived",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}

Widget taskItem(Map task) {
  //dismissible make the container slide right and left
  return Dismissible(
    background: slideRightBackground(),
    secondaryBackground: slideLeftBackground(),
    key: Key(task['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(children: [
        CircleAvatar(
          radius: 40.0,
          child: Text(task['time']),
        ),
        SizedBox(
          width: 20.0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(task['title'],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            Text(task['date'], style: TextStyle(color: Colors.grey)),
          ],
        ),
      ]),
    ),
  );
}
//--------------------------------------------------

Widget mySeparatedList({required List<Map> tasks}) {
  return ListView.separated(
      // physics: NeverScrollableScrollPhysics(),
      // shrinkWrap: true,
      itemBuilder: (context, index) => multiBottonSlider(tasks[index], context),
      //with 2 slide
      //taskItem(tasks[index]),
      separatorBuilder: (context, index) => Container(
            width: double.infinity,
            height: 1.0,
            color: Colors.grey,
          ),
      itemCount: tasks.length);
}

Widget BodyWithSeparatedList(String taskType) {
  return BlocConsumer<AppCubit, AppState>(
    listener: (context, state) {},
    builder: (context, state) {
      // geting the  tasks by bloc and route it to the pages sorted by type
      if (taskType == 'new') {
        var tasks = AppCubit.get(context).tasks;
        return mySeparatedList(tasks: tasks);
      } else if (taskType == 'done') {
        var tasks = AppCubit.get(context).doneTasks;
        return mySeparatedList(tasks: tasks);
      } else {
        var tasks = AppCubit.get(context).acrhviedTasks;
        return mySeparatedList(tasks: tasks);
      }
    },
  );
}

//---------------------------------------------------
Widget myNavigationBar(
    {required List<BottomNavigationBarItem> itmes,
    required int currectindex,
    Color? color,
    required Function OnTabFunc}) {
  color:
  Colors.pinkAccent[900];
  return BottomNavigationBar(
    items: itmes,
    onTap: (index) {
      OnTabFunc(index);
    },
    currentIndex: currectindex,
    type: BottomNavigationBarType.fixed,
    backgroundColor: color,
  );
}

//--------------------------------------------
//my costum text field with easy parameters
Widget CostumTextField({
  required TextEditingController Controller,
  IconData? prefixicon,
  required String labelText,
  required bool obscuretext,
  TextInputType? keyboardType,
  IconData? suffixIcon,
  String? printedError,
  Function? suffixFunction,
  Function? ontap,
  IconData? icon,
}) =>
    TextFormField(
        onTap: () {
          ontap!();
        },
        obscureText: obscuretext,
        //onSubmitted: ,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return printedError;
          }
          return null;
        },
        // to use validator you should use TextFormField not TextField
        keyboardType: keyboardType,
        //   keyboardType: TextInputType.datetime,
        //   keyboardType: TextInputType.phone,
        // keyboardType: TextInputType.streetAddress,
        controller: Controller,
        decoration: new InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          labelText: labelText,
          icon: Icon(icon),
          border: UnderlineInputBorder(),
          prefix: Icon(prefixicon),
          suffix: prefixicon != null
              ? IconButton(
                  icon: Icon(suffixIcon),
                  onPressed: () {
                    suffixFunction!();
                  })
              : null,
          // hintText: "User name ",
          //   icon: new Icon(Icons.person))),
        ));

Widget myForm({Key? formKey, List<Widget>? textfields}) =>
    Form(key: formKey, child: Column(children: textfields!));
//------------------------------------------------------------

//sheet layout with shadow porder with custom and cool parameters
Widget mySheetWindow(
        {double? RadiusCircularValue,
        Color? BackGroundColor,
        Color? shadowBorderColor,
        List<Widget>? ChildrenList}) =>
    Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: BackGroundColor,
            borderRadius: BorderRadius.circular(RadiusCircularValue!),
            boxShadow: [
              BoxShadow(color: shadowBorderColor!, spreadRadius: 3),
            ],
          ),
          child: Column(
            children: ChildrenList!,
          ),
        ),
      ),
    );
//----------------------------------------------

Widget CustomButtom({
  required Function func,
  required String bottomName,
  required double bottomHeight,
  required Color bottomColor,
}) =>
    Container(
      height: bottomHeight,
      width: double.infinity,
      child: MaterialButton(
          color: bottomColor,
          onPressed: () {
            func();
          },
          child: Text(bottomName,
              style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 20,
                  fontWeight: FontWeight.w600))),
    );

Widget myTextBottom(
        {Function? onpressed,
        required double fontsize,
        required Color textColor,
        required FontWeight fontweight,
        required String stringValue}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
            child: Text(stringValue,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontsize,
                  fontWeight: fontweight,
                )),
            onPressed: () {
              onpressed!();
            })
      ],
    );

//---------------------------------------------------

Widget multiBottonSlider(Map task, context) => Slidable(
      key: Key(task['id'].toString()),
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
          CircleAvatar(
            radius: 40.0,
            child: Text(task['time']),
          ),
          SizedBox(
            width: 20.0,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(task['title'],
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              Text(" التاريخ ${task['date']}", style: TextStyle(color: Colors.grey)),
            ],
          ),
        ]),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'أرشفة',
          color: Colors.blue,
          icon: Icons.archive,
          onTap: () => AppCubit.get(context)
              .updateData(status: "archived", id: task['id']),
        ),
        IconSlideAction(
          caption: 'تم',
          color: Colors.indigo,
          icon: Icons.done,
          onTap: () =>
              AppCubit.get(context).updateData(status: "done", id: task['id']),
        ),
      ],
      secondaryActions: <Widget>[
        // IconSlideAction(
        //   caption: 'More',
        //   color: Colors.black45,
        //   icon: Icons.more_horiz,
        //   onTap: () => SnackBar(
        //     content: Text(
        //       'More',
        //     ),
        //   ),
        // ),
        IconSlideAction(
          caption: 'حذف',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => AppCubit.get(context).deleteData(id: task['id']),
        ),
      ],
    );
