import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/model_add_admin.dart';
import '../util/firebase_db_handler.dart';
import '../util/network_authentication.dart';
import '../util/validation.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class AddAdmin extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? map;

  const AddAdmin({Key? key, required this.mode, this.map}) : super(key: key);
  static const pageName = '/AddAdmin';

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  TextEditingController nameController = TextEditingController();
  TextEditingController gMailController = TextEditingController();
  TextEditingController salaryController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  List<String>? userStatus = [];

  String genderMale = 'male';
  String genderFemale = 'female';
  late String gender;

  ButtonState stateTextWithIcon = ButtonState.idle;

  final globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    gender = genderMale;

    print('......................${widget.mode}');
    print('......................${widget.map}');
    if (widget.mode.contains('Edit')) {
      nameController.text = widget.map![ModelAddAdmin.nameKey];
      phoneController.text = widget.map![ModelAddAdmin.phoneNumberKey];
      gMailController.text = widget.map![ModelAddAdmin.gMailKey];
      cnicController.text = widget.map![ModelAddAdmin.cnicKey];
      salaryController.text = widget.map![ModelAddAdmin.salaryKey].toString();
      addressController.text = widget.map![ModelAddAdmin.addressKey].toString();
    }
  }

  @override
  void dispose() {
    gMailController.dispose();
    nameController.dispose();
    salaryController.dispose();
    addressController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Admin'),
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
                              controller: nameController,
                              icon: Icons.person,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[a-zA-Z ]'))
                              ],
                              titleName: 'Name',
                              validate: (value) =>
                                  ModelValidation.commonValidation(
                                      value.toString())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomWidget.customTextField(
                              controller: phoneController,
                              icon: Icons.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              titleName: 'Phone Number',
                              textInputType: TextInputType.number,
                              maxLength: 11,
                              validate: (value) =>
                                  ModelValidation.phoneNumberValidation(
                                      value.toString())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomWidget.customTextField(
                              controller: gMailController,
                              icon: Icons.mail,
                              titleName: 'Gmail',
                              textInputType: TextInputType.emailAddress,
                              validate: (value) =>
                                  ModelValidation.gmailValidation(
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
                              textInputType: TextInputType.number,
                              maxLength: 15,
                              validate: (value) =>
                                  ModelValidation.cnicValidation(
                                      value.toString())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomWidget.customTextField(
                              controller: salaryController,
                              icon: Icons.payments_outlined,
                              textInputType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              titleName: 'Salary',
                              validate: (value) =>
                                  ModelValidation.commonValidation(
                                      value.toString())),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomWidget.customTextField(
                              controller: addressController,
                              icon: Icons.add_location_rounded,
                              titleName: 'Address',
                              validate: (value) =>
                                  ModelValidation.commonValidation(
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
                                      Radio<String>(
                                          value: genderMale,
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value!;
                                            });
                                          }),
                                      const Text('Male '),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Radio<String>(
                                          value: genderFemale,
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value!;
                                            });
                                          }),
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
                              text: widget.mode.contains('Edit')
                                  ? 'Update'
                                  : 'Add',
                              onPressed: () {
                                onPressedIconWithText(context);
                              }),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ));
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
                var addAdmin = ModelAddAdmin(
                    name: nameController.text.toString(),
                    salary: salaryController.text.toString(),
                    phoneNumber: '0${phoneController.text.toString()}',
                    cnic: cnicController.text.toString(),
                    gMail: gMailController.text.toString(),
                    address: addressController.text.toString(),
                    gender: gender);

                userStatus.toString().contains('SuperAdmin')
                    ? DBHandler.adminCollection()
                        .doc(cnicController.text.toString())
                        .set(addAdmin.toMap())
                        .then((value) {
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          stateTextWithIcon = ButtonState.fail;
                        });
                      })
                    : DBHandler.adminCollectionWithUID(
                            userStatus![2].toString())
                        .doc(cnicController.text.toString())
                        .set(addAdmin.toMap())
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
        setState(() {
          stateTextWithIcon = stateTextWithIcon;
        });
        NetworkAuth.showNow(mainContext);
      }
    });
  }
}
