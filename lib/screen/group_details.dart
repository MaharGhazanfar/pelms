import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pelms/screen/student_details.dart';
import 'package:provider/provider.dart';

import '../provider/model_create_group.dart';
import '../util/firebase_db_handler.dart';
import '../util/item_select_check.dart';
import 'create_group.dart';

class GroupDetails extends StatefulWidget {
  final List<String>? userStatus;

  const GroupDetails({
    Key? key,
    required this.userStatus,
  }) : super(key: key);
  static const pageName = '/GroupDetails';

  @override
  _GroupDetailsState createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  double scale = 1.0;
  List<Map<String, dynamic>> dataList = [];
  final PageController _pageController =
      PageController(initialPage: 1, viewportFraction: 0.25);

  late Stream<QuerySnapshot> _groupStream;
  late SelectMultipleItems selectMultipleItemsProvider =
      Provider.of<SelectMultipleItems>(context);
  late TextEditingController _searchController;
  bool dataLoad = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    print('.............status...........${widget.userStatus}/////////');
    if (widget.userStatus.toString().contains('SuperAdmin')) {
      _groupStream = DBHandler.groupCollection().snapshots();
    } else {
      _groupStream =
          DBHandler.groupCollectionWithUID(widget.userStatus![2].toString())
              .snapshots();
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
                'Groups Detail',
              )
            : selectMultipleItemsProvider.appBarTextField(
                searchController: _searchController,
                setState: setState,
                searchingFor: 'Group Details'),
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
                stream: _groupStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: const Text('Something went wrong'),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                        child: const Text('No Internet Connection'));
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
                              // selectMultipleItemsProvider.selectedFlag[index] =
                              //     selectMultipleItemsProvider.selectedFlag[index] ??
                              //         false;
                              bool? isSelected = selectMultipleItemsProvider
                                  .selectedFlag[index];
                              return isSelected != null
                                  ? _builder(
                                      mainContext: mainContext,
                                      map: doc,
                                      isSelected: isSelected,
                                      index: index,
                                      groupName:
                                          doc[ModelCreateGroup.groupNameKey],
                                      courseName:
                                          doc[ModelCreateGroup.courseNameKey],
                                      time:
                                          '${doc[ModelCreateGroup.startingTimeKey]} to ${doc[ModelCreateGroup.endingTimeKey]} ')
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
                                  '${selectMultipleItemsProvider.filterList.length}////view//');
                              bool? isSelected = selectMultipleItemsProvider
                                  .selectedFlag[index];
                              return isSelected != null
                                  ? _builder(
                                      mainContext: mainContext,
                                      map: selectMultipleItemsProvider
                                          .filterList[index],
                                      index: index,
                                      isSelected: isSelected,
                                      groupName: selectMultipleItemsProvider
                                              .filterList[index]
                                          [ModelCreateGroup.groupNameKey],
                                      courseName: selectMultipleItemsProvider
                                              .filterList[index]
                                          [ModelCreateGroup.courseNameKey],
                                      time:
                                          '${selectMultipleItemsProvider.filterList[index][ModelCreateGroup.startingTimeKey]} to ${selectMultipleItemsProvider.filterList[index][ModelCreateGroup.endingTimeKey]} ')
                                  : const Center(
                                      child: CircularProgressIndicator());
                            },
                          );
                  }
                }),
          ),
        ),
      ),
    );
  }

  _builder(
      {required int index,
      required BuildContext mainContext,
      required Map<String, dynamic> map,
      bool? isSelected = false,
      required String groupName,
      required String courseName,
      required String time}) {
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
                        builder: (context) => CreateGroup(
                          mode: 'Edit',
                          map: map,
                        ),
                      ));
                },
                backgroundColor: Colors.grey.shade200,
                spacing: 6,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (context) async {
                  if (widget.userStatus![0].toString() == 'SuperAdmin') {
                    DBHandler.groupStudentCollection(groupName)
                        .get()
                        .then((snapshot) async {
                      for (DocumentSnapshot ds in snapshot.docs) {
                        var studentCourseEnrollmentCollection =
                            await DBHandler.studentCourseEnrollmentCollection(
                                    ds.id.toString())
                                .get();

                        if (studentCourseEnrollmentCollection.docs.length > 1) {
                          DBHandler.studentCourseEnrollmentCollection(
                                  ds.id.toString())
                              .doc(groupName)
                              .delete();
                        } else {
                          DBHandler.studentCourseEnrollmentCollection(
                                  ds.id.toString())
                              .doc(groupName)
                              .delete();
                          DBHandler.studentRegistrationWithUID(
                                  DBHandler.user.toString())
                              .doc(ds.id.toString())
                              .delete();
                          DBHandler.studentCollection()
                              .doc(ds.id.toString())
                              .delete();
                        }
                        ds.reference.delete();
                      }
                    });
                    DBHandler.groupCollection()
                        .doc(groupName)
                        .delete()
                        .then((value) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Deleted Successfully'))))
                        .catchError((error) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Something went Wrong'))));
                  } else {
                    DBHandler.groupStudentCollectionWithUID(
                            groupName, widget.userStatus![2].toString())
                        .get()
                        .then((snapshot) async {
                      for (DocumentSnapshot ds in snapshot.docs) {
                        var studentCourseEnrollmentCollection = await DBHandler
                            .studentCourseEnrollmentCollectionWithUserUID(
                          ds.id.toString(),
                          widget.userStatus![2].toString(),
                        ).get();

                        if (studentCourseEnrollmentCollection.docs.length > 1) {
                          DBHandler
                              .studentCourseEnrollmentCollectionWithUserUID(
                            ds.id.toString(),
                            widget.userStatus![2].toString(),
                          ).doc(groupName).delete();
                        } else {
                          DBHandler
                              .studentCourseEnrollmentCollectionWithUserUID(
                            ds.id.toString(),
                            widget.userStatus![2].toString(),
                          ).doc(groupName).delete();
                          DBHandler.studentRegistrationWithUID(
                                  widget.userStatus![2].toString())
                              .doc(ds.id)
                              .delete();
                          DBHandler.studentCollectionWithUID(
                                  widget.userStatus![2].toString())
                              .doc(
                                ds.id.toString(),
                              )
                              .delete();
                        }
                        ds.reference.delete();
                      }
                    });
                    DBHandler.groupCollectionWithUID(
                            widget.userStatus![2].toString())
                        .doc(groupName)
                        .delete()
                        .then((value) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Deleted Successfully'))))
                        .catchError((error) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Something went Wrong'))));
                    /*
                    // DBHandler.groupStudentCollectionWithUID(
                    //         groupName, widget.userStatus![2].toString())
                    //     .get()
                    //     .then((snapshot) {
                    //   for (DocumentSnapshot ds in snapshot.docs) {
                    //     ds.reference.delete();
                    //   }
                    // });
                    // DBHandler.groupCollectionWithUID(
                    //         widget.userStatus![2].toString())
                    //     .doc(groupName)
                    //     .delete()
                    //     .then((value) => ScaffoldMessenger.of(mainContext)
                    //         .showSnackBar(const SnackBar(
                    //             backgroundColor: Colors.green,
                    //             content: Text('Deleted Successfully'))))
                    //     .catchError((error) => ScaffoldMessenger.of(mainContext)
                    //         .showSnackBar(const SnackBar(
                    //             backgroundColor: Colors.red,
                    //             content: Text('Something went Wrong'))));*/
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
                  setState: setState,
                  isSelected: isSelected,
                  index: index,
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
                    if (widget.userStatus.toString().contains('SuperAdmin')) {
                      if (widget.userStatus!.length > 1) {
                        widget.userStatus!.removeAt(1);
                        widget.userStatus!.add(groupName);
                      } else {
                        widget.userStatus!.add(groupName);
                      }
                    } else {
                      if (widget.userStatus!.length > 3) {
                        widget.userStatus!.removeAt(3);
                        widget.userStatus!.add(groupName);
                      } else {
                        widget.userStatus!.add(groupName);
                      }
                    }
                    selectMultipleItemsProvider.isNotSearching = true;
                    print(
                        '........group........${widget.userStatus}....................');
                    Navigator.pushNamed(context, StudentDetails.pageName,
                        arguments: widget.userStatus);
                  });
                }
              },
              leading: selectMultipleItemsProvider.buildSelectIconForGroups(
                  isSelected: isSelected, context: context),
              title: Text(
                groupName,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 20 : 12,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  courseName,
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 17 : 15,
                      fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Text(
                time,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width > 400 ? 16 : 10,
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
      allDataDoc = await DBHandler.groupCollection().get();
    } else {
      allDataDoc = await DBHandler.groupCollectionWithUID(
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

  void deleteItems(BuildContext mainContext) async {
    for (var item in selectMultipleItemsProvider.list) {
      if (widget.userStatus![0].toString() == 'SuperAdmin') {
        DBHandler.groupStudentCollection(item[ModelCreateGroup.groupNameKey])
            .get()
            .then((snapshot) async {
          for (DocumentSnapshot ds in snapshot.docs) {
            var studentCourseEnrollmentCollection =
                await DBHandler.studentCourseEnrollmentCollection(
                        ds.id.toString())
                    .get();
            if (studentCourseEnrollmentCollection.docs.length > 1) {
              DBHandler.studentCourseEnrollmentCollection(ds.id.toString())
                  .doc(item[ModelCreateGroup.groupNameKey])
                  .delete();
            } else {
              DBHandler.studentCourseEnrollmentCollection(ds.id.toString())
                  .doc(item[ModelCreateGroup.groupNameKey])
                  .delete();
              DBHandler.studentRegistrationWithUID(
                      widget.userStatus![2].toString())
                  .doc(ds.id)
                  .delete();
              DBHandler.studentCollection().doc(ds.id.toString()).delete();
            }
            ds.reference.delete();
          }
        });
        DBHandler.groupCollection()
            .doc(item[ModelCreateGroup.groupNameKey])
            .delete()
            .catchError((error) => ScaffoldMessenger.of(mainContext)
                .showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went Wrong'))));
      } else {
        DBHandler.groupStudentCollectionWithUID(
                item[ModelCreateGroup.groupNameKey],
                widget.userStatus![2].toString())
            .get()
            .then((snapshot) async {
          for (DocumentSnapshot ds in snapshot.docs) {
            var studentCourseEnrollmentCollection =
                await DBHandler.studentCourseEnrollmentCollectionWithUserUID(
              ds.id.toString(),
              widget.userStatus![2].toString(),
            ).get();

            if (studentCourseEnrollmentCollection.docs.length > 1) {
              DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                ds.id.toString(),
                widget.userStatus![2].toString(),
              ).doc(item[ModelCreateGroup.groupNameKey]).delete();
            } else {
              DBHandler.studentCourseEnrollmentCollectionWithUserUID(
                ds.id.toString(),
                widget.userStatus![2].toString(),
              ).doc(item[ModelCreateGroup.groupNameKey]).delete();

              DBHandler.studentRegistrationWithUID(
                      widget.userStatus![2].toString())
                  .doc(ds.id.toString())
                  .delete();

              DBHandler.studentCollectionWithUID(
                      widget.userStatus![2].toString())
                  .doc(
                    ds.id.toString(),
                  )
                  .delete();
            }
            ds.reference.delete();
          }
        });
        DBHandler.groupCollectionWithUID(widget.userStatus![2].toString())
            .doc(item[ModelCreateGroup.groupNameKey])
            .delete()
            .catchError((error) => ScaffoldMessenger.of(mainContext)
                .showSnackBar(const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went Wrong'))));
// .then((value) => ScaffoldMessenger.of(mainContext).showSnackBar(
        //     const SnackBar(
        //         backgroundColor: Colors.green,
        //         content: Text('Deleted Successfully'))))
        // DBHandler.groupStudentCollectionWithUID(
        //     item[ModelCreateGroup.groupNameKey], widget.userStatus![2].toString())
        //     .get()
        //     .then((snapshot) {
        //   for (DocumentSnapshot ds in snapshot.docs) {
        //     ds.reference.delete();
        //   }
        // });
        // DBHandler.groupCollectionWithUID(
        //     widget.userStatus![2].toString())
        //     .doc(item[ModelCreateGroup.groupNameKey])
        //     .delete()
        //     .then((value) => ScaffoldMessenger.of(mainContext)
        //     .showSnackBar(const SnackBar(
        //     backgroundColor: Colors.green,
        //     content: Text('Deleted Successfully'))))
        //     .catchError((error) => ScaffoldMessenger.of(mainContext)
        //     .showSnackBar(const SnackBar(
        //     backgroundColor: Colors.red,
        //     content: Text('Something went Wrong'))));
      }
    }
    ScaffoldMessenger.of(mainContext).showSnackBar(const SnackBar(
        backgroundColor: Colors.green, content: Text('Deleted Successfully')));

    setState(() {
      selectMultipleItemsProvider.list.clear();
      selectMultipleItemsProvider.isSelectionMode = false;
      dataLoad = true;
    });
  }
}
