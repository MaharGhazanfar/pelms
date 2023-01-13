import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/model_add_student.dart';
import '../util/firebase_db_handler.dart';
import '../util/network_authentication.dart';
import '../util/validation.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class AddStudent extends StatefulWidget {
  final List<String>? userStatus;

  final String mode;
  final Map<String, dynamic>? map;
  static const pageName = '/AddStudent';

  const AddStudent(
      {Key? key, required this.userStatus, required this.mode, this.map})
      : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController gMailNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  ButtonState stateTextWithIcon = ButtonState.idle;

  final globalKey = GlobalKey<FormState>();
  String genderMale = 'male';
  String genderFemale = 'female';
  late ModelAddStudent modelAddStudentProvider;

  @override
  void initState() {
    super.initState();
    modelAddStudentProvider =
        Provider.of<ModelAddStudent>(context, listen: false);

    if (widget.mode.contains('Edit')) {
      nameController.text = widget.map![ModelAddStudent.nameKey];
      fatherNameController.text = widget.map![ModelAddStudent.fatherNameKey];
      gMailNameController.text = widget.map![ModelAddStudent.gMailKey];
      phoneController.text = widget.map![ModelAddStudent.phoneNumberKey];
      cnicController.text = widget.map![ModelAddStudent.cnicKey];
      addressController.text = widget.map![ModelAddStudent.addressKey];
      modelAddStudentProvider.gender = widget.map![ModelAddStudent.genderKey];
    }
  }

  @override
  void dispose() {
    gMailNameController.dispose();
    nameController.dispose();
    fatherNameController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp(r'[a-zA-Z ]'),
                                allow: true)
                          ],
                          controller: nameController,
                          icon: Icons.person,
                          titleName: 'Name',
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter(RegExp(r'[a-zA-Z ]'),
                                allow: true)
                          ],
                          controller: fatherNameController,
                          icon: Icons.person,
                          titleName: 'Father Name',
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          controller: phoneController,
                          icon: Icons.phone,
                          titleName: 'Phone Number',
                          textInputType: TextInputType.phone,
                          maxLength: 11,
                          validate: (value) =>
                              ModelValidation.phoneNumberValidation(
                                  value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: gMailNameController,
                          icon: Icons.mail,
                          titleName: 'Gmail',
                          textInputType: TextInputType.emailAddress,
                          validate: (value) => ModelValidation.gmailValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: cnicController,
                          inputFormatters: [
                            MaskedInputFormatter('#####-#######-#',
                                allowedCharMatcher: RegExp(r'[0-9]'))
                          ],
                          icon: Icons.perm_identity,
                          titleName: 'CNIC',
                          maxLength: 15,
                          textInputType: TextInputType.number,
                          validate: (value) =>
                              ModelValidation.cnicValidation(value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: addressController,
                          icon: Icons.add_location_rounded,
                          titleName: 'Address',
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black12,
                                  offset: Offset(
                                    3,
                                    3,
                                  ),
                                  spreadRadius: 5,
                                  blurRadius: 5)
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              const Text('Gender :'),
                              Row(
                                children: [
                                  Consumer<ModelAddStudent>(
                                    builder: (context, value, child) =>
                                        Radio<String>(
                                            value: genderMale,
                                            groupValue:
                                                modelAddStudentProvider.gender,
                                            onChanged: (value) {
                                              modelAddStudentProvider.gender =
                                                  value!;
                                            }),
                                  ),
                                  const Text('Male '),
                                ],
                              ),
                              Row(
                                children: [
                                  Consumer<ModelAddStudent>(
                                    builder: (context, value, child) =>
                                        Radio<String>(
                                            value: genderFemale,
                                            groupValue:
                                                modelAddStudentProvider.gender,
                                            onChanged: (value) {
                                              modelAddStudentProvider.gender =
                                                  value!;
                                            }),
                                  ),
                                  const Text('Female '),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: CustomButton(
                        buttonState: stateTextWithIcon,
                        text: widget.mode.contains('Edit') ? 'Update' : 'Add',
                        onPressed: () {
                          onPressedIconWithText(context);
                        },
                      ),
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
        SharedPreferences sharedPreferencesCNIC =
            await SharedPreferences.getInstance();

        print(
            '...............${widget.userStatus.toString()}...........................................');
        switch (stateTextWithIcon) {
          case ButtonState.idle:
            {
              if (globalKey.currentState!.validate()) {
                stateTextWithIcon = ButtonState.loading;

                var modelAddStudent = ModelAddStudent(
                  name: nameController.text.toString(),
                  address: addressController.text.toString(),
                  cnic: cnicController.text.toString(),
                  gender: modelAddStudentProvider.gender,
                  fatherName: fatherNameController.text.toString(),
                  phoneNumber: phoneController.text.toString(),
                  gMail: gMailNameController.text.toString(),
                );

                sharedPreferencesCNIC.setString(
                    'cnic', cnicController.text.toString());

                widget.userStatus.toString().contains('SuperAdmin')
                    ? DBHandler.studentCollection()
                        .doc(cnicController.text.toString())
                        .set(modelAddStudent.toMap())
                        .then((value) {
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          stateTextWithIcon = ButtonState.fail;
                        });
                      })
                    : DBHandler.studentCollectionWithUID(
                            widget.userStatus![2].toString())
                        .doc(cnicController.text.toString())
                        .set(modelAddStudent.toMap())
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
