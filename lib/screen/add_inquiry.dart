import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/model_add_inquiry.dart';
import '../util/firebase_db_handler.dart';
import '../util/network_authentication.dart';
import '../util/validation.dart';
import '../widget/custom_button.dart';
import '../widget/custom_textfield.dart';

class AddInquiry extends StatefulWidget {
  final String mode;
  final Map<String, dynamic>? map;

  const AddInquiry({Key? key, required this.mode, this.map}) : super(key: key);
  static const pageName = '/AddInquiry';

  @override
  _AddInquiryState createState() => _AddInquiryState();
}

class _AddInquiryState extends State<AddInquiry> {
  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController gMailController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
  late String confirmValue = 'Confirmed';

  List<String>? userStatus = [];
  static final List<String> confirmationStatus = ['Confirmed', 'NotConfirmed'];

  ButtonState stateTextWithIcon = ButtonState.idle;
  final globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    print('....................mode........./${widget.mode}');
    print('....................mode........./${widget.map}');
    if (widget.mode.contains('Edit')) {
      nameController.text = widget.map![ModelAddInquiry.nameKey];
      fatherNameController.text = widget.map![ModelAddInquiry.fatherNameKey];
      phoneController.text = widget.map![ModelAddInquiry.phoneNumberKey];
      cnicController.text = widget.map![ModelAddInquiry.cnicKey];
      gMailController.text = widget.map![ModelAddInquiry.gMailKey];
      aboutController.text = widget.map![ModelAddInquiry.aboutInquiryKey];
      confirmValue = widget.map![ModelAddInquiry.confirmationStatusKey];
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    fatherNameController.dispose();
    phoneController.dispose();
    cnicController.dispose();
    aboutController.dispose();
    gMailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Add Inquiry'),
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
        centerTitle: true,
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
                          textInputType: TextInputType.number,
                          maxLength: 11,
                          validate: (value) =>
                              ModelValidation.phoneNumberValidation(
                                  value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: cnicController,
                          icon: Icons.perm_identity,
                          titleName: 'CNIC',
                          inputFormatters: [
                            MaskedInputFormatter('#####-#######-#',
                                allowedCharMatcher: RegExp(r'[0-9]'))
                          ],
                          textInputType: TextInputType.number,
                          maxLength: 15,
                          validate: (value) =>
                              ModelValidation.cnicValidation(value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: gMailController,
                          icon: Icons.mail,
                          titleName: 'Gmail',
                          textInputType: TextInputType.emailAddress,
                          validate: (value) => ModelValidation.gmailValidation(
                              value.toString())),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        child: CustomWidget.dropdownButton2(
                            initialValue: confirmValue,
                            onSaved: (value) {
                              confirmValue = value.toString();
                            },
                            validate: (value) {
                              if (value == null) {
                                return 'required';
                              } else {
                                return null;
                              }
                            },
                            onChanged: (p0) {
                              setState(() {
                                confirmValue = p0.toString();
                              });
                            },
                            items: confirmationStatus,
                            context: context,
                            titleName: 'Confirmation Status'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomWidget.customTextField(
                          controller: aboutController,
                          icon: Icons.question_answer_outlined,
                          titleName: 'About Inquiry',
                          validate: (value) => ModelValidation.commonValidation(
                              value.toString())),
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

                var addInquiry = ModelAddInquiry(
                    confirmationValue: confirmValue,
                    cnic: cnicController.text.toString(),
                    name: nameController.text.toString(),
                    aboutInquiry: aboutController.text.toString(),
                    fatherName: fatherNameController.text.toString(),
                    phoneNumber: phoneController.text.toString(),
                    gMail: gMailController.text.toString());

                userStatus.toString().contains('SuperAdmin')
                    ? DBHandler.inquiryCollection()
                        .doc(cnicController.text.toString())
                        .set(addInquiry.toMap())
                        .then((value) {
                        setState(() {
                          stateTextWithIcon = ButtonState.success;
                        });
                      }).onError((error, stackTrace) {
                        setState(() {
                          stateTextWithIcon = ButtonState.fail;
                        });
                      })
                    : DBHandler.inquiryCollectionWithUID(
                            userStatus![2].toString())
                        .doc(cnicController.text.toString())
                        .set(addInquiry.toMap())
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
