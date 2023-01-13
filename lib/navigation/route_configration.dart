import 'package:flutter/material.dart';
import '../screen/add_admin.dart';
import '../screen/add_fee.dart';
import '../screen/add_inquiry.dart';
import '../screen/admin_details.dart';
import '../screen/create_group.dart';
import '../screen/dashboard.dart';
import '../screen/fee_history_voucher_collection.dart';
import '../screen/first_intro.dart';
import '../screen/group_details.dart';
import '../screen/inquiry_details.dart';
import '../screen/student_details.dart';
import '../widget/bnb_for_student_detail.dart';
import '../widget/bnb_for_student_enrollment.dart';

class RouteConfiguration {
  static Route<dynamic> generateRouts(RouteSettings settings) {
    if (settings.name == BNBForStudentEnrollment.pageName) {
      List<String> userStatus = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            BNBForStudentEnrollment(userStatus: userStatus, mode: 'Normal'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customRightSlideTransition(animation, child);
        },
      );
    } else if (settings.name == AddAdmin.pageName) {
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddAdmin(mode: 'Normal'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customLeftSlideTransition(animation, child);
        },
      );
    } else if (settings.name == AdminDetails.pageName) {
      List<String> userStatus = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            AdminDetails(userStatus: userStatus),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customRightSlideTransition(animation, child);
        },
      );
    } else if (settings.name == InquiryDetails.pageName) {
      List<String> userStatus = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => InquiryDetails(
          userStatus: userStatus,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customRightSlideTransition(animation, child);
        },
      );
    } else if (settings.name == FirstIntro.pageName) {
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FirstIntro(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customLeftSlideTransition(animation, child);
        },
      );
    } else if (settings.name == AddFee.pageName) {
      List<String> userStatus = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => AddFee(
          userStatus: userStatus,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customRightSlideTransition(animation, child);
        },
      );
    } else if (settings.name == CreateGroup.pageName) {
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const CreateGroup(mode: 'Normal'),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customLeftSlideTransition(animation, child);
        },
      );
    } else if (settings.name == GroupDetails.pageName) {
      List<String> userStatus = settings.arguments as List<String>;

      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => GroupDetails(
          userStatus: userStatus,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customRightSlideTransition(animation, child);
        },
      );
    } else if (settings.name == FeeVoucherDetails.pageName) {
      List<String> userStatus = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            FeeVoucherDetails(
          userStatus: userStatus,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customRightSlideTransition(animation, child);
        },
      );
    } else if (settings.name == AddInquiry.pageName) {
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddInquiry(
          mode: 'Normal',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return customLeftSlideTransition(animation, child);
        },
      );
    } else if (settings.name == StudentDetails.pageName) {
      List<String> userStatus = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            StudentDetails(userStatus: userStatus),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeInCirc),
            child: child,
          );
        },
      );
    } else if (settings.name == BNBForStudentProfile.pageName) {
      List<String> studentInfo = settings.arguments as List<String>;
      return PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) =>
            BNBForStudentProfile(
          userCnic: studentInfo[1],
          userUID: studentInfo[2],
          userStatus: studentInfo[0],
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: CurvedAnimation(parent: animation, curve: Curves.easeInCirc),
            child: child,
          );
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => const MyDashBoard(userStatus: ''),
      );
    }
  }

  static Widget customRightSlideTransition(
      Animation<double> animation, Widget child) {
    Tween<Offset> tween =
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0));
    return SlideTransition(
      position: tween.animate(animation),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeInCirc),
        child: child,
      ),
    );
  }

  static Widget customLeftSlideTransition(
      Animation<double> animation, Widget child) {
    Tween<Offset> tween =
        Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0));
    return SlideTransition(
      position: tween.animate(animation),
      child: ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeInCirc),
        child: child,
      ),
    );
  }
}
