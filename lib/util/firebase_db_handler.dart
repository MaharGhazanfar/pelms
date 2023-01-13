import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DBHandler{


  static var user = FirebaseAuth.instance.currentUser;

  ////////////////////////////////student collection///////////////////////////////////////////
  static CollectionReference studentCollection(){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('Student');
  }

  static CollectionReference studentCollectionWithUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('Student');
  }
////////////////////////////////admin collection///////////////////////////////////////////
  static CollectionReference adminCollection(){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('Admin');
  }

  static CollectionReference adminCollectionWithUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('Admin');
  }

////////////////////////////////inquiry collection///////////////////////////////////////////
  static CollectionReference inquiryCollection(){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('Inquiry');
  }

  static CollectionReference inquiryCollectionWithUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('Inquiry');
  }

////////////////////////////////group collection///////////////////////////////////////////

  static CollectionReference groupCollection(){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('Group');
  }

  static CollectionReference groupCollectionWithUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('Group');
  }
////////////////////////////////Student Enrollment Collection///////////////////////////////////////////
  static CollectionReference studentCourseEnrollmentCollection(String docs){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('Student').doc(docs).collection('CourseEnrollment');
  }
  static CollectionReference studentCourseEnrollmentCollectionWithUserUID(String docs, String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('Student').doc(docs).collection('CourseEnrollment');
  }

  ////////////////////////////////group Student Enrollment Collection///////////////////////////////////////////

  static CollectionReference  groupStudentCollection(String docs){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('Group').doc(docs).collection('EnrollStudent');
  }

  static CollectionReference  groupStudentCollectionWithUID(String docs,String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('Group').doc(docs).collection('EnrollStudent');
  }

  ////////////////////////////////fee history Collection///////////////////////////////////////////
  static CollectionReference feeHistoryCollection(){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(user!.uid).collection('FeeHistory');
  }
  static CollectionReference feeHistoryCollectionWithUserUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('FeeHistory');
  }



  static CollectionReference studentRegistrationWithUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('VerifiedStudent');
  }

  static CollectionReference adminCollectionRegistrationWithUID(String userUID){
    return  FirebaseFirestore.instance
        .collection('SuperAdmins')
        .doc(userUID).collection('VerifiedAdmin');
  }

















}