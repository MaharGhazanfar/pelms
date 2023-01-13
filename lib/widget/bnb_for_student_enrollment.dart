import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:water_drop_nav_bar/water_drop_nav_bar.dart';

import '../screen/add_student.dart';
import '../screen/fee_structure_enroll_student.dart';
import '../screen/select_group.dart';

class BNBForStudentEnrollment extends StatefulWidget {
  final List<String>? userStatus;
  final String mode;
  final Map<String, dynamic>? map;
  const BNBForStudentEnrollment({Key? key, required this.userStatus,required this.mode,this.map}) : super(key: key);
  static const pageName = '/BNBForStudentEnrollment ';

  @override
  _BNBForStudentEnrollmentState createState() =>
      _BNBForStudentEnrollmentState();
}

class _BNBForStudentEnrollmentState extends State<BNBForStudentEnrollment> {
  int selectedIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedIndex);
    print('...................${widget.userStatus.toString()}......................');
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
            AddStudent(userStatus: widget.userStatus, mode: widget.mode,map: widget.map,),
            CourseEnrollment(userStatus: widget.userStatus,),
            FeeStructure(userStatus: widget.userStatus,),
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
                filledIcon: Icons.person_add_alt_1_rounded,
                outlinedIcon: Icons.person_add_alt),
            BarItem(
              filledIcon: Icons.assignment,
              outlinedIcon: Icons.assignment_outlined,
            ),
            BarItem(
              filledIcon: Icons.add_box,
              outlinedIcon: Icons.add_box_outlined,
            ),
          ],
        ),
      ),
    );
  }
}
