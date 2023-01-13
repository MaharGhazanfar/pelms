import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/carousel_counter.dart';
import '../util/firebase_db_handler.dart';
import '../widget/bnb_for_student_enrollment.dart';
import '../widget/carousel_pages.dart';
import '../widget/network_error_page.dart';
import 'add_admin.dart';
import 'add_fee.dart';
import 'add_inquiry.dart';
import 'admin_details.dart';
import 'create_group.dart';
import 'fee_history_voucher_collection.dart';
import 'first_intro.dart';
import 'group_details.dart';
import 'inquiry_details.dart';

class MyDashBoard extends StatefulWidget {
  final String userStatus;

  const MyDashBoard({Key? key, required this.userStatus}) : super(key: key);
  static const pageName = '/DashBoard';

  @override
  _MyDashBoardState createState() => _MyDashBoardState();
}

class _MyDashBoardState extends State<MyDashBoard>
    with SingleTickerProviderStateMixin {
  late ConnectivityResult _connectionStatus = ConnectivityResult.mobile;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final CarouselController _controller = CarouselController();
  static const List list = [1, 2];
  late FancyDrawerController _controllerDrawer;
  bool status = false;
  late Stream<QuerySnapshot> _groupStream;

  @override
  void initState() {
    super.initState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    if (widget.userStatus.toString().contains('SuperAdmin')) {
      _groupStream = DBHandler.groupCollection().snapshots();
    } else {
      _groupStream =
          DBHandler.groupCollectionWithUID(widget.userStatus.toString())
              .snapshots();
    }
    _controllerDrawer = FancyDrawerController(
        vsync: this, duration: const Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.message);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _controllerDrawer.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var carouselCounter = Provider.of<CarouselCounter>(context, listen: false);
    if (_connectionStatus == ConnectivityResult.none) {
      return Center(child: Builder(builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width,
            child: const NetworkErrorPage(),
          ),
        );
      }));
    } else {
      return Material(
        child: FancyDrawerWrapper(
          hideOnContentTap: true,
          itemGap: 8,
          backgroundColor: Colors.black12,
          cornerRadius: 16,
          drawerItems: [
            Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: ListTile(
                leading: CircleAvatar(
                    child: Text(DBHandler.user!.email![0].toString())),
                title: Text(
                  DBHandler.user!.email.toString(),
                  style: const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                SharedPreferences sharePref =
                    await SharedPreferences.getInstance();
                sharePref.remove('cnic');
                List<String>? userStatus =
                    sharePref.getStringList('getUserInfo');

                print(
                    '/////////.....${userStatus.toString()} .......userStatus');

                Navigator.pushNamed(context, AdminDetails.pageName,
                        arguments: userStatus)
                    .then((value) {
                  _controllerDrawer.close();
                  status = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Admin Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.lightBlueAccent,
              radius: 20,
              onTap: () async {
                SharedPreferences sharePref =
                    await SharedPreferences.getInstance();
                sharePref.remove('cnic');
                List<String>? userStatus =
                    sharePref.getStringList('getUserInfo');
                Navigator.pushNamed(context, InquiryDetails.pageName,
                        arguments: userStatus)
                    .then((value) {
                  _controllerDrawer.close();
                  status = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Inquiry Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                SharedPreferences sharePref =
                    await SharedPreferences.getInstance();
                sharePref.remove('cnic');
                List<String>? userStatus =
                    sharePref.getStringList('getUserInfo');
                Navigator.pushNamed(context, FeeVoucherDetails.pageName,
                        arguments: userStatus)
                    .then((value) {
                  _controllerDrawer.close();
                  status = false;
                });
              },
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Fee History",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _controllerDrawer.close();
                status = false;
              },
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "About us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                _controllerDrawer.close();
                status = false;
              },
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Support us",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.lightBlueAccent,
              radius: 20,
              onTap: () async {
                if (widget.userStatus == 'SuperAdmin') {
                  await FirebaseAuth.instance.signOut();
                  FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
                } else if (widget.userStatus == 'Admin') {
                  await FirebaseAuth.instance.signOut();
                  FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
                  FirebaseAuth.instance.authStateChanges().listen((User? user) {
                    if (user == null) {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FirstIntro(),
                          ),
                          (route) => false);
                    } else {
                      print('User is signed in!');
                    }
                  });
                }
              },
              child: Container(
                height: 50,
                alignment: Alignment.centerLeft,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: const Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                    "Log out",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
          controller: _controllerDrawer,
          child: Scaffold(
              appBar: AppBar(
                title: Text(widget.userStatus.toString()),
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    if (status == false) {
                      _controllerDrawer.open();
                      status = true;
                    } else {
                      _controllerDrawer.close();
                      status = false;
                    }
                  },
                ),
              ),
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 4,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 3,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: CarouselSlider(
                                    items: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child:
                                            CarouselPages.getCarouselSinglePage(
                                          color: Colors.blue.shade300,
                                          child: CarouselPages.groupDetails(
                                            context: context,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: GestureDetector(
                                            onTap: () async {
                                              print(
                                                  '...................................................');
                                              SharedPreferences sharePref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              sharePref.remove('cnic');
                                              List<String>? userStatus =
                                                  sharePref.getStringList(
                                                      'getUserInfo');
                                              Navigator.pushNamed(context,
                                                  FeeVoucherDetails.pageName,
                                                  arguments: userStatus);
                                            },
                                            child: CarouselPages
                                                .getCarouselSinglePage(
                                                    color: Colors.cyan.shade200,
                                                    child: CarouselPages
                                                        .latestVoucher()),
                                          )),
                                    ],
                                    options: CarouselOptions(
                                        autoPlay: true,
                                        enableInfiniteScroll: true,
                                        viewportFraction: 0.8,
                                        autoPlayInterval:
                                            const Duration(seconds: 3),
                                        initialPage: 0,
                                        onPageChanged: (index, reason) {
                                          carouselCounter.counter = index;
                                        },
                                        enlargeCenterPage: true,
                                        enlargeStrategy:
                                            CenterPageEnlargeStrategy.scale,
                                        autoPlayCurve: Curves.easeInCirc),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: list.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Consumer<CarouselCounter>(
                                        builder: (context, value, child) =>
                                            Container(
                                          width: 10.0,
                                          height: 10.0,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 4.0),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: (Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? Colors.white
                                                      : Colors.blue)
                                                  .withOpacity(
                                                      carouselCounter.counter ==
                                                              entry.key
                                                          ? 1.0
                                                          : 0.4)),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ]),
                      ),
                      Flexible(
                        flex: 7,
                        child: Column(
                          children: [
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharePref =
                                            await SharedPreferences
                                                .getInstance();
                                        sharePref.remove('cnic');
                                        List<String>? userStatus = sharePref
                                            .getStringList('getUserInfo');

                                        Navigator.pushNamed(context,
                                            BNBForStudentEnrollment.pageName,
                                            arguments: userStatus);
                                      },
                                      child: getCustomCard(
                                          "Add Student", Icons.person_add)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, AddAdmin.pageName);
                                    },
                                    child: getCustomCard(
                                        "Add Admin", Icons.person_add_outlined),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharePref =
                                            await SharedPreferences
                                                .getInstance();
                                        sharePref.remove('cnic');
                                        List<String>? userStatus = sharePref
                                            .getStringList('getUserInfo');
                                        Navigator.pushNamed(
                                            context, AddFee.pageName,
                                            arguments: userStatus);
                                      },
                                      child: getCustomCard(
                                          "Add Fee", Icons.add_box)),
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, CreateGroup.pageName);
                                      },
                                      child: getCustomCard(
                                          "Create Group", Icons.group_sharp))
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                      onTap: () async {
                                        SharedPreferences sharePref =
                                            await SharedPreferences
                                                .getInstance();
                                        sharePref.remove('cnic');
                                        List<String>? userStatus = sharePref
                                            .getStringList('getUserInfo');
                                        Navigator.pushNamed(
                                            context, GroupDetails.pageName,
                                            arguments: userStatus);
                                      },
                                      child: getCustomCard(
                                          "Students Details", Icons.details)),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AddInquiry.pageName,
                                      );
                                    },
                                    child: getCustomCard("Add Inquiry",
                                        Icons.person_add_alt_1_rounded),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ),
      );
    }
  }

  Widget getCustomCard(
    String name,
    IconData icons,
  ) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * .4,
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icons,
              size: 35,
              color: Colors.blue,
            ),
            FittedBox(
              child: Text(
                name,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize:
                        MediaQuery.of(context).size.width <= 400 ? 15 : 20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
