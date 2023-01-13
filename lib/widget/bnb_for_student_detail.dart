
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';
import '../screen/academic_details_for_student.dart';
import '../screen/student_profile.dart';
import '../screen/voucher_history_for_student.dart';

class BNBForStudentProfile extends StatefulWidget {
  final String userStatus;
  final String userCnic;
  final String userUID;
  const BNBForStudentProfile({Key? key,required this.userStatus,required this.userUID, required this.userCnic}) : super(key: key);
  static const pageName='/BNBForStudentProfile';

  @override
  _BNBForStudentEnrollmentState createState() =>
      _BNBForStudentEnrollmentState();
}

class _BNBForStudentEnrollmentState extends State<BNBForStudentProfile> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    print('................user ...// ${widget.userStatus}////////////////////////');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark),
      child: Scaffold(
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children:  [
            StudentProfile(userStatus: widget.userStatus,studentCnic: widget.userCnic, userUID: widget.userUID,),
            AcademicDetailsForStudent(cnic: widget.userCnic , userUID: widget.userUID),
            VoucherHistoryForStudent(cnic: widget.userCnic, userUID: widget.userUID)
          ],
        ),
        bottomNavigationBar: WaterDropNavBar(
          backgroundColor: Colors.grey.shade100,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
            pageController.animateToPage(selectedIndex,
                duration: const Duration(milliseconds: 800),
                curve: Curves.bounceOut);
          },
          selectedIndex: selectedIndex,
          bottomPadding: 8,
          barItems: [
            BarItem(
                filledIcon: Icons.person, outlinedIcon: Icons.perm_identity),
            BarItem(
              filledIcon: Icons.payments,
              outlinedIcon: Icons.payments_outlined,
            ),
            BarItem(
              filledIcon: Icons.account_balance_wallet,
              outlinedIcon: Icons.account_balance_wallet_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
