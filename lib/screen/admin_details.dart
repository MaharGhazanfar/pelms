import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../provider/model_add_admin.dart';
import '../util/firebase_db_handler.dart';
import 'add_admin.dart';

class AdminDetails extends StatefulWidget {
  final List<String> userStatus;

  const AdminDetails({Key? key, required this.userStatus}) : super(key: key);
  static const pageName = '/AdminDetails';

  @override
  _AdminDetailsState createState() => _AdminDetailsState();
}

class _AdminDetailsState extends State<AdminDetails> {
  late Stream<QuerySnapshot> _adminStream;

  @override
  void initState() {
    super.initState();
    if (widget.userStatus.toString().contains('SuperAdmin')) {
      _adminStream = DBHandler.adminCollection().snapshots();
    } else {
      _adminStream =
          DBHandler.adminCollectionWithUID(widget.userStatus[2].toString())
              .snapshots();
    }
  }

  final PageController _pageController =
      PageController(viewportFraction: 0.25, initialPage: 1);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext mainContext) {

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Admin details'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb
              ? MediaQuery.of(mainContext).size.width * 0.7
              : MediaQuery.of(mainContext).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: _adminStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    'Something went wrong////////////////////////////////////////////////////');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return PageView.builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String , dynamic> doc = snapshot.data!.docs[index].data() as Map<String , dynamic>;
                    return _builder(
                        index: index,
                        map:  doc,
                        mainContext: mainContext,
                        adminCnic: doc[ModelAddAdmin.cnicKey],
                        adminName: doc[ModelAddAdmin.nameKey],
                        phoneNumber: doc[ModelAddAdmin.phoneNumberKey],
                        gender: doc[ModelAddAdmin.genderKey]);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _builder(
      {required int index,
      required String adminName,
        required Map<String ,dynamic> map,
      required String adminCnic,
      required String phoneNumber,
      required BuildContext mainContext,
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAdmin(mode: 'Edit',map: map,),));
                },
                backgroundColor: Colors.grey.shade200,
                spacing: 6,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (context) {
                  if (widget.userStatus.toString().contains('SuperAdmin')) {
                    DBHandler.adminCollectionRegistrationWithUID(
                            DBHandler.user!.uid)
                        .doc(adminCnic)
                        .delete();
                    DBHandler.adminCollection()
                        .doc(adminCnic)
                        .delete()
                        .then(
                          (value) {
                            DBHandler.adminCollectionRegistrationWithUID(DBHandler.user.toString()).doc(adminCnic).delete();
                            return ScaffoldMessenger.of(mainContext).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Deleted Successfully'),
                            ),
                          );
                          },
                        )
                        .catchError((error) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text('Something went Wrong'))));
                  } else {
                    ScaffoldMessenger.of(mainContext).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('You are not allowed'),
                        ));
                  }
                },
                backgroundColor: Colors.grey.shade200,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const BNBForStudentProfile(),
              //     ));
            },
            child: Container(
              height: 170,
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
              child: ListTile(
                leading: CircleAvatar(
                    radius: MediaQuery.of(context).size.width > 400 ? 25 : 20,
                    backgroundColor: Colors.blue,
                    child: Center(
                        child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.width > 400 ? 35 : 30,
                      color: Colors.white,
                    ))),
                title: Text(
                  adminName,
                  style: TextStyle(
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 20 : 15,
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
                      fontSize:
                          MediaQuery.of(context).size.width > 400 ? 17 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ));
  }
}
