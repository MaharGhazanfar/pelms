import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/model_create_group.dart';
import '../util/firebase_db_handler.dart';
import '../util/network_authentication.dart';
import '../util/validation.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';
import '../widget/time_picker.dart';

class CreateGroup extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? map;

  const CreateGroup({Key? key, required this.mode, this.map}) : super(key: key);
  static const pageName = '/CreateGroup';

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  late TextEditingController _groupNameController;
  late TextEditingController _courseNameController;
  late TextEditingController _durationController;
  late TextEditingController dateCtl;
  late TextEditingController _courseFeeController;
  List<String>? userStatus = [];

  TimeOfDay _startTime = TimeOfDay.now().replacing(hour: 11, minute: 30);
  TimeOfDay _endTime = TimeOfDay.now().replacing(hour: 12, minute: 30);
  ButtonState stateTextWithIcon = ButtonState.idle;
  final globalKey = GlobalKey<FormState>();
  bool iosStyle = true;

  void onTimeChanged(TimeOfDay newTime) {
    setState(() {
      _startTime = newTime;
    });
  }

  void onTimeChanged2(TimeOfDay newTime) {
    setState(() {
      _endTime = newTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _groupNameController = TextEditingController();
    _courseNameController = TextEditingController();
    _courseFeeController = TextEditingController();
    _durationController = TextEditingController();
    dateCtl = TextEditingController(text: DateTime.now().toString());

    print('...................${widget.mode}');
    print('...................${widget.map}');

    if (widget.mode.contains('Edit')) {
      _groupNameController.text = widget.map![ModelCreateGroup.groupNameKey];
      _courseNameController.text = widget.map![ModelCreateGroup.courseNameKey];
      _durationController.text = widget.map![ModelCreateGroup.durationKey];
      _courseFeeController.text = widget.map![ModelCreateGroup.courseFeeKey];
      dateCtl.text = widget.map![ModelCreateGroup.dateKey];
    }
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _courseNameController.dispose();
    dateCtl.dispose();
    _durationController.dispose();
    _courseFeeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: const Text(
          'Create Group',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      )),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              width: kIsWeb
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width,
              child: Form(
                key: globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: _groupNameController,
                          icon: Icons.group,
                          titleName: 'Group Name',
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: _courseNameController,
                          icon: Icons.menu_book,
                          titleName: 'Course Name',
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: _durationController,
                          icon: Icons.hourglass_top_rounded,
                          prefixText: 'Months : ',
                          titleName: 'Duration',
                          textInputType: TextInputType.number,
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: _courseFeeController,
                          icon: Icons.payments,
                          titleName: 'Fee',
                          textInputType: TextInputType.number,
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: const BoxDecoration(boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                offset: Offset(
                                  3,
                                  3,
                                ),
                                spreadRadius: 5,
                                blurRadius: 5)
                          ]),
                          child: DateTimePicker(
                            controller: dateCtl,
                            dateHintText: 'dd-mm-yyyy',
                            validator: (value) =>
                                ModelValidation.commonValidation(
                                    value.toString()),
                            decoration: InputDecoration(
                                filled: true,
                                prefixIcon: const Icon(
                                  Icons.date_range_outlined,
                                  color: Colors.black,
                                ),
                                label: const Text('Date'),
                                labelStyle:
                                    const TextStyle(color: Colors.black),
                                fillColor: Colors.white,
                                focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blueGrey, width: 1)),
                                border: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTimePicker.timeGetter(
                              onTimeChanged: onTimeChanged,
                              time: _startTime,
                              iosStyle: iosStyle,
                              context: context),
                          const Text(
                            'To',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          CustomTimePicker.timeGetter(
                              onTimeChanged: onTimeChanged2,
                              time: _endTime,
                              iosStyle: iosStyle,
                              context: context),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: CustomButton(
                          buttonState: stateTextWithIcon,
                          text: widget.mode.contains('Edit') ? 'Update' : 'Add',
                          onPressed: () {
                            onPressedIconWithText(context);
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onPressedIconWithText(BuildContext mainContext) {
    NetworkAuth.check().then((internet) async {
      if (internet) {
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        userStatus = sharedPreferences.getStringList('getUserInfo');
        print(
            '...............${userStatus.toString()}...........................................');
        switch (stateTextWithIcon) {
          case ButtonState.idle:
            {
              if (globalKey.currentState!.validate()) {
                stateTextWithIcon = ButtonState.loading;
                String startTime = '${_startTime.hourOfPeriod} : '
                    '${_startTime.minute} '
                    '${_startTime.period.toString().substring(10, 12)}';
                String endTime = '${_endTime.hourOfPeriod} : '
                    '${_endTime.minute} '
                    '${_endTime.period.toString().substring(10, 12)}';

                var createGroup = ModelCreateGroup(
                    groupName: _groupNameController.text.toString(),
                    courseName: _courseNameController.text.toString(),
                    duration: _durationController.text.toString(),
                    courseFee: _courseFeeController.text.toString(),
                    date: dateCtl.text.toString(),
                    startingTime: startTime,
                    endingTime: endTime);

                userStatus.toString().contains('SuperAdmin')
                    ? DBHandler.groupCollection()
                        .doc(_groupNameController.text.toString())
                        .set(createGroup.toMap())
                        .then((value) {
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          stateTextWithIcon = ButtonState.fail;
                        });
                      })
                    : DBHandler.groupCollectionWithUID(
                            userStatus![2].toString())
                        .doc(_groupNameController.text.toString())
                        .set(createGroup.toMap())
                        .then((value) {
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          stateTextWithIcon = ButtonState.fail;
                        });
                      });
              }
              break;
            }

          case ButtonState.loading:
            break;
          case ButtonState.success:
            stateTextWithIcon = ButtonState.idle;
            break;
          case ButtonState.fail:
            stateTextWithIcon = ButtonState.idle;
            break;
        }
        setState(() {
          stateTextWithIcon = stateTextWithIcon;
        });
      } else {
        NetworkAuth.showNow(mainContext);
      }
    });
  }
}
