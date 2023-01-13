import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../provider/ModelFeeStructure.dart';
import '../provider/model_add_student.dart';
import '../util/firebase_db_handler.dart';
import '../util/item_select_check_for_students.dart';
import '../widget/bnb_for_student_detail.dart';
import '../widget/bnb_for_student_enrollment.dart';
import '../widget/custom_profile.dart';

class StudentDetails extends StatefulWidget {
  final List<String>? userStatus;

  const StudentDetails({Key? key, required this.userStatus}) : super(key: key);
  static const pageName = '/StudentDetails';

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  double scale = 1.0;
  double totalFee = 0.0;
  double outStanding = 0.0;
  List<Map<String, dynamic>> dataList = [];

  final PageController _pageController =
      PageController(viewportFraction: 0.25, initialPage: 1);
  Alignment alignment = Alignment.bottomCenter;

  late Stream<QuerySnapshot> _studentStream;
  bool dataLoad = true;
  late SelectMultipleItemsForStudent selectMultipleItemsProvider =
      Provider.of<SelectMultipleItemsForStudent>(context);
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.userStatus.toString().contains('SuperAdmin')) {
      _studentStream =
          DBHandler.groupStudentCollection(widget.userStatus![1].toString())
              .snapshots();
      print('${widget.userStatus}////////superAdmin////..............');
    } else {
      _studentStream = DBHandler.groupStudentCollectionWithUID(
              widget.userStatus![3].toString(),
              widget.userStatus![2].toString())
          .snapshots();
      print('${widget.userStatus}////////admin////..............');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {
    dataLoad ? getData() : null;
    dataLoad = false;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: selectMultipleItemsProvider.isNotSearching
            ? selectMultipleItemsProvider.appBarTitle(
                'Student Details',
              )
            : selectMultipleItemsProvider.appBarTextField(
                searchController: _searchController,
                setState: setState,
              ),
        leadingWidth: 100,
        leading: (selectMultipleItemsProvider.isNotSearching)
            ? (selectMultipleItemsProvider.isSelectionMode)
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        selectMultipleItemsProvider.buildSelectAllButton(
                          setState: setState,
                        )!,
                        Text('${selectMultipleItemsProvider.list.length}')
                      ],
                    ),
                  )
                : null
            : (selectMultipleItemsProvider.isSelectionMode)
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        selectMultipleItemsProvider.buildSelectAllButton(
                          setState: setState,
                        )!,
                        Text('${selectMultipleItemsProvider.list.length}')
                      ],
                    ),
                  )
                : selectMultipleItemsProvider.buildLeading(),
        actions: [
          selectMultipleItemsProvider.isNotSearching
              ? IconButton(
                  onPressed: () {
                    if (selectMultipleItemsProvider.dataList.isNotEmpty) {
                      selectMultipleItemsProvider.isSelectionMode = false;
                      selectMultipleItemsProvider.selectedFlag
                          .updateAll((key, value) => false);
                      selectMultipleItemsProvider.isNotSearching = false;
                    }
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
              : const SizedBox(),
          (selectMultipleItemsProvider.isSelectionMode)
              ? IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    deleteItems(context);
                  },
                )
              : const SizedBox(),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb
              ? MediaQuery.of(mainContext).size.width * 0.7
              : MediaQuery.of(mainContext).size.width,
          child: AnimatedScale(
            onEnd: () {
              setState(() {
                scale = 1;
              });
            },
            scale: scale,
            duration: const Duration(seconds: 1),
            child: StreamBuilder<QuerySnapshot>(
              stream: _studentStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  return selectMultipleItemsProvider.isNotSearching
                      ? PageView.builder(
                          itemCount: snapshot.data!.docs.length,
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> doc =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            bool? isSelected =
                                selectMultipleItemsProvider.selectedFlag[index];

                            return isSelected != null
                                ? _builder(
                                    index: index,
                                    mainContext: mainContext,
                                    isSelected: isSelected,
                                    studentCnic: doc[ModelAddStudent.cnicKey],
                                    studentName: doc[ModelAddStudent.nameKey],
                                    phoneNumber:
                                        doc[ModelAddStudent.phoneNumberKey],
                                    gender: doc[ModelAddStudent.genderKey],
                                    map: doc)
                                : const Center(
                                    child: CircularProgressIndicator());
                          },
                        )
                      : PageView.builder(
                          itemCount:
                              selectMultipleItemsProvider.filterList.length,
                          scrollDirection: Axis.vertical,
                          controller: _pageController,
                          itemBuilder: (BuildContext context, int index) {
                            print(
                                '${selectMultipleItemsProvider.filterList.length}//////filterlisted view');
                            bool? isSelected =
                                selectMultipleItemsProvider.selectedFlag[index];
                            return isSelected != null
                                ? _builder(
                                    index: index,
                                    mainContext: mainContext,
                                    isSelected: isSelected,
                                    studentCnic: selectMultipleItemsProvider
                                            .filterList[index]
                                        [ModelAddStudent.cnicKey],
                                    studentName: selectMultipleItemsProvider
                                            .filterList[index]
                                        [ModelAddStudent.nameKey],
                                    phoneNumber: selectMultipleItemsProvider
                                            .filterList[index]
                                        [ModelAddStudent.phoneNumberKey],
                                    gender: selectMultipleItemsProvider
                                            .filterList[index]
                                        [ModelAddStudent.genderKey],
                                    map: selectMultipleItemsProvider
                                        .filterList[index])
                                : const Center(
                                    child: CircularProgressIndicator());
                          },
                        );
                }
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // print('////////////click//////$totalFee//////$outStanding/////');
          totalFee = 0.0;
          outStanding = 0.0;
          List<String> listOfCNICStudent = [];
          if (widget.userStatus![0].toString() == 'SuperAdmin') {
            // print('/////////////////superAdmin///////////');

            var snapshot = await DBHandler.groupStudentCollection(
                    widget.userStatus![1].toString())
                .get();

            listOfCNICStudent = snapshot.docs.map((doc) {
              return doc.id.toString();
            }).toList();

            for (int count = 0; count < listOfCNICStudent.length; count++) {
              var singleStudentFee =
                  await DBHandler.studentCourseEnrollmentCollection(
                          listOfCNICStudent[count])
                      .doc(widget.userStatus![1].toString())
                      .get()
                      .then((value) => value.data() as Map<String, dynamic>);
              totalFee += singleStudentFee[ModelFeeStructure.payableKey];
              List listOfOutstanding =
                  singleStudentFee[ModelFeeStructure.outStandingKey];
              for (var element in listOfOutstanding) {
                outStanding += element;
              }
            }
          } else {
            //  print('//////////////////else/////////');
            var snapshot = await DBHandler.groupStudentCollectionWithUID(
                    widget.userStatus![3].toString(),
                    widget.userStatus![2].toString())
                .get();

            listOfCNICStudent = snapshot.docs.map((doc) {
              return doc.id.toString();
            }).toList();

            for (int count = 0; count < listOfCNICStudent.length; count++) {
              var singleStudentFee =
                  await DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                          listOfCNICStudent[count],
                          widget.userStatus![2].toString())
                      .doc(widget.userStatus![3].toString())
                      .get()
                      .then((value) => value.data() as Map<String, dynamic>);
              totalFee += singleStudentFee[ModelFeeStructure.payableKey];
              List listOfOutstanding =
                  singleStudentFee[ModelFeeStructure.outStandingKey];
              for (var element in listOfOutstanding) {
                outStanding += element;
              }
            }
          }
          _showModalBottomSheet(
              totalFee: totalFee,
              totalStudent: listOfCNICStudent.length,
              received: totalFee - outStanding,
              outstanding: outStanding);
        },
        child: const Icon(
          Icons.keyboard_arrow_up,
          size: 35,
        ),
      ),
    );
  }

  _showModalBottomSheet(
      {required int totalStudent,
      required double totalFee,
      required double received,
      required double outstanding}) {
    showModalBottomSheet(
      enableDrag: true,
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) {
        return Container(
          // height: 200,
          width: double.infinity,

          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: kIsWeb
                  ? MediaQuery.of(context).size.width * 0.7
                  : MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomProfileWidget.customProfileText(
                      text: totalStudent.toString(),
                      title: 'Total Students',
                      context: context),
                  CustomProfileWidget.customProfileText(
                      text: totalFee.toString(),
                      title: 'Total Payable Fee',
                      context: context),
                  CustomProfileWidget.customProfileText(
                      text: received.toString(),
                      title: 'Total Received',
                      context: context),
                  CustomProfileWidget.customProfileText(
                      text: outstanding.toString(),
                      title: 'Total OutStanding',
                      context: context)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _builder(
      {required int index,
      required BuildContext mainContext,
      required String studentName,
      bool? isSelected = false,
      required Map<String, dynamic> map,
      required String studentCnic,
      required String phoneNumber,
      required String gender}) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 1.0;

          if (_pageController.position.haveDimensions) {
            value = (_pageController.page! - index);

            if (value >= 0) {
              double _lowerLimit = 0;
              double _upperLimit = 2;

              value =
                  (_upperLimit - (value.abs() * (_upperLimit - _lowerLimit)))
                      .clamp(_lowerLimit, _upperLimit);
              value = _upperLimit - value;
              value *= -0;
            }
          } else {
            if (index == 0) {
              value = 0;
            } else if (index == 1) {
              value = -0;
            }
          }

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(value),
            alignment: Alignment.bottomCenter,
            child: Padding(padding: const EdgeInsets.all(16.0), child: child),
          );
        },
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                flex: 1,
                onPressed: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BNBForStudentEnrollment(
                                userStatus: widget.userStatus,
                                mode: 'Edit',
                                map: map,
                              )));
                },
                backgroundColor: Colors.grey.shade200,
                spacing: 6,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (context) async {
                  if (widget.userStatus![0].toString() == 'SuperAdmin') {
                    var studentCourseEnrollmentCollection =
                        await DBHandler.studentCourseEnrollmentCollection(
                                studentCnic)
                            .get();
                    DBHandler.groupStudentCollection(widget.userStatus![1])
                        .doc(studentCnic)
                        .delete()
                        .then((value) {
                      if (studentCourseEnrollmentCollection.docs.length > 1) {
                        DBHandler.studentCourseEnrollmentCollection(studentCnic)
                            .doc(widget.userStatus![1])
                            .delete();
                      } else {
                        DBHandler.studentCourseEnrollmentCollection(studentCnic)
                            .doc(widget.userStatus![1])
                            .delete();
                        DBHandler.studentRegistrationWithUID(
                                DBHandler.user.toString())
                            .doc(studentCnic)
                            .delete();
                        DBHandler.studentCollection().doc(studentCnic).delete();
                      }

                      return ScaffoldMessenger.of(mainContext).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Deleted Successfully')));
                    }).catchError((error) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Something went Wrong'))));
                  } else {
                    var studentCourseEnrollmentCollection = await DBHandler
                            .studentCourseEnrollmentCollectionWithUserUID(
                                studentCnic, widget.userStatus![2])
                        .get();

                    DBHandler.groupStudentCollectionWithUID(
                            widget.userStatus![3], widget.userStatus![2])
                        .doc(studentCnic)
                        .delete()
                        .then((value) {
                      if (studentCourseEnrollmentCollection.docs.length > 1) {
                        DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                                studentCnic, widget.userStatus![2])
                            .doc(widget.userStatus![3])
                            .delete();
                      } else {
                        DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                                studentCnic, widget.userStatus![2])
                            .doc(widget.userStatus![3])
                            .delete();
                        DBHandler.studentCollectionWithUID(
                                widget.userStatus![2])
                            .doc(studentCnic)
                            .delete();
                        DBHandler.studentRegistrationWithUID(
                                widget.userStatus![2])
                            .doc(studentCnic)
                            .delete();
                      }

                      return ScaffoldMessenger.of(mainContext).showSnackBar(
                          const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Deleted Successfully')));
                    }).catchError((error) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Something went Wrong'))));
                  }
                  dataLoad = true;
                  setState(() {});
                },
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: Container(
            height: 170,
            decoration: BoxDecoration(
                color: isSelected!
                    ? Colors.blueGrey.withOpacity(0.02)
                    : Colors.grey.shade50,
                border: Border.all(color: Colors.blue.shade400, width: 3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(2, 2),
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 3),
                  BoxShadow(
                      offset: Offset(-2, -3),
                      color: Colors.white10,
                      blurRadius: 5,
                      spreadRadius: 3)
                ]),
            alignment: Alignment.center,
            child: ListTile(
              onLongPress: () => selectMultipleItemsProvider.onLongPress(
                  isSelected: isSelected,
                  index: index,
                  setState: setState,
                  map: map),
              onTap: () async {
                if (selectMultipleItemsProvider.isSelectionMode) {
                  selectMultipleItemsProvider.onTap(
                      setState: setState,
                      isSelected: isSelected,
                      index: index,
                      map: map);
                } else {
                  setState(() {
                    scale = 0.0;
                  });
                  await Future.delayed(const Duration(milliseconds: 600), () {
                    Navigator.pushNamed(context, BNBForStudentProfile.pageName,
                        arguments: <String>[
                          widget.userStatus![0],
                          studentCnic,
                          widget.userStatus.toString().contains('SuperAdmin')
                              ? DBHandler.user!.uid.toString()
                              : widget.userStatus![2].toString()
                        ]);
                  });
                }
              },
              // leading: CircleAvatar(
              //   radius: MediaQuery.of(context).size.width > 400 ? 25 : 20,
              //   backgroundColor: Colors.blue,
              //   child: Center(
              //     child: Icon(
              //       Icons.person,
              //       size: MediaQuery.of(context).size.width > 400 ? 35 : 30,
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
              leading: selectMultipleItemsProvider.buildSelectIcon(
                  isSelected: isSelected, context: context),
              title: Text(
                studentName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 15,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  phoneNumber,
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 17 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Text(
                gender,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 17 : 14,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ));
  }

  void getData() async {
    selectMultipleItemsProvider.dataList.clear();
    selectMultipleItemsProvider.selectedFlag.clear();
    selectMultipleItemsProvider.list.clear();

    QuerySnapshot<Object?> allDataDoc;
    if (widget.userStatus.toString().contains('SuperAdmin')) {
      allDataDoc = await DBHandler.groupStudentCollection(
              widget.userStatus![1].toString())
          .get();
    } else {
      allDataDoc = await DBHandler.groupStudentCollectionWithUID(
              widget.userStatus![3].toString(),
              widget.userStatus![2].toString())
          .get();
    }
    for (int i = 0; i < allDataDoc.docs.length; i++) {
      var doc = allDataDoc.docs[i].data() as Map<String, dynamic>;
      selectMultipleItemsProvider.dataList.add(doc);
      selectMultipleItemsProvider.selectedFlag[i] =
          selectMultipleItemsProvider.selectedFlag[i] ?? false;
    }
    selectMultipleItemsProvider.filterList =
        selectMultipleItemsProvider.dataList;
    print(
        '${selectMultipleItemsProvider.filterList.length}//////////////////////////????????????');
  }

  void deleteItems(BuildContext context) async {
    if (widget.userStatus![0].toString() == 'SuperAdmin') {
      for (var item in selectMultipleItemsProvider.list) {
        var studentCourseEnrollmentCollection =
            await DBHandler.studentCourseEnrollmentCollection(
                    item[ModelAddStudent.cnicKey])
                .get();
        DBHandler.groupStudentCollection(widget.userStatus![1])
            .doc(item[ModelAddStudent.cnicKey])
            .delete()
            .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went Wrong'))));
        //.then((value) {

        // return ScaffoldMessenger.of(context).showSnackBar(
        //     const SnackBar(
        //         backgroundColor: Colors.green,
        //         content: Text('Deleted Successfully')));
        //})
        if (studentCourseEnrollmentCollection.docs.length > 1) {
          DBHandler.studentCourseEnrollmentCollection(
                  item[ModelAddStudent.cnicKey])
              .doc(widget.userStatus![1])
              .delete();
        } else {
          DBHandler.studentCourseEnrollmentCollection(
                  item[ModelAddStudent.cnicKey])
              .doc(widget.userStatus![1])
              .delete();
          DBHandler.studentRegistrationWithUID(DBHandler.user.toString())
              .doc(item[ModelAddStudent.cnicKey])
              .delete();
          DBHandler.studentCollection()
              .doc(item[ModelAddStudent.cnicKey])
              .delete();
        }
      }

      //   DBHandler.feeHistoryCollection()
      //       .doc(item[ModelAddStudent.cnicKey])
      //       .delete()
      //       .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(
      //               backgroundColor: Colors.red,
      //               content: Text('Something went Wrong'))));
      // }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Deleted Successfully')));
    } else {
      for (var item in selectMultipleItemsProvider.list) {
        var studentCourseEnrollmentCollection =
            await DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                    item[ModelAddStudent.cnicKey], widget.userStatus![2])
                .get();

        DBHandler.groupStudentCollectionWithUID(
                widget.userStatus![3], widget.userStatus![2])
            .doc(item[ModelAddStudent.cnicKey])
            .delete()
            .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went Wrong'))));

        if (studentCourseEnrollmentCollection.docs.length > 1) {
          DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                  item[ModelAddStudent.cnicKey], widget.userStatus![2])
              .doc(widget.userStatus![3])
              .delete();
        } else {
          DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                  item[ModelAddStudent.cnicKey], widget.userStatus![2])
              .doc(widget.userStatus![3])
              .delete();
          DBHandler.studentCollectionWithUID(widget.userStatus![2])
              .doc(item[ModelAddStudent.cnicKey])
              .delete();
          DBHandler.studentRegistrationWithUID(widget.userStatus![2])
              .doc(item[ModelAddStudent.cnicKey])
              .delete();
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Deleted Successfully')));
    }

    setState(() {
      selectMultipleItemsProvider.list.clear();
      selectMultipleItemsProvider.isSelectionMode = false;
      dataLoad = true;
    });
  }
}
