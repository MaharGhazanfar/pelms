import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../provider/model_add_inquiry.dart';
import '../provider/model_fee_voucher.dart';
import '../util/firebase_db_handler.dart';
import '../util/item_select_check.dart';
import 'add_inquiry.dart';

class InquiryDetails extends StatefulWidget {
  final List<String> userStatus;

  const InquiryDetails({Key? key, required this.userStatus}) : super(key: key);
  static const pageName = '/InquiryDetails';

  @override
  _InquiryDetailsState createState() => _InquiryDetailsState();
}

class _InquiryDetailsState extends State<InquiryDetails> {
  bool dataLoad = true;
  late Stream<QuerySnapshot> _inquiryStream;
  final PageController _pageController =
      PageController(viewportFraction: 0.25, initialPage: 1);
  late SelectMultipleItems selectMultipleItemsProvider =
      Provider.of<SelectMultipleItems>(context);
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.userStatus.toString().contains('SuperAdmin')) {
      _inquiryStream = DBHandler.inquiryCollection().snapshots();
    } else {
      _inquiryStream =
          DBHandler.inquiryCollectionWithUID(widget.userStatus[2].toString())
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
                  'Inquiry Details',
                )
              : selectMultipleItemsProvider.appBarTextField(
                  searchController: _searchController,
                  setState: setState,
                  searchingFor: 'Inquiry Details'),
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
            child: StreamBuilder<QuerySnapshot>(
                stream: _inquiryStream,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text(
                        'Something went wrong////////////////////////////////////////////////////');
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
                              // selectMultipleItemsProvider.selectedFlag[index] =
                              //     selectMultipleItemsProvider.selectedFlag[index] ??
                              //         false;
                              bool? isSelected = selectMultipleItemsProvider
                                  .selectedFlag[index];
                              return isSelected != null
                                  ? _builder(
                                      map: doc,
                                      confirmationStatus: doc[ModelAddInquiry
                                          .confirmationStatusKey],
                                      mainContext: mainContext,
                                      isSelected: isSelected,
                                      index: index,
                                      cnic: doc[ModelAddInquiry.cnicKey],
                                      studentName: doc[ModelAddInquiry.nameKey],
                                      phoneNumber:
                                          doc[ModelAddInquiry.phoneNumberKey],
                                      about:
                                          doc[ModelAddInquiry.aboutInquiryKey])
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
                                  '${selectMultipleItemsProvider.filterList.length}//////');
                              bool? isSelected = selectMultipleItemsProvider
                                  .selectedFlag[index];
                              return isSelected != null
                                  ? _builder(
                                      map: selectMultipleItemsProvider
                                          .filterList[index],
                                      mainContext: mainContext,
                                      isSelected: isSelected,
                                      index: index,
                                      confirmationStatus:
                                          selectMultipleItemsProvider.filterList[index]
                                              [ModelAddInquiry
                                                  .confirmationStatusKey],
                                      cnic: selectMultipleItemsProvider.filterList[index]
                                          [ModelAddInquiry.cnicKey],
                                      studentName: selectMultipleItemsProvider
                                              .filterList[index]
                                          [ModelAddInquiry.nameKey],
                                      phoneNumber: selectMultipleItemsProvider
                                              .filterList[index]
                                          [ModelAddInquiry.phoneNumberKey],
                                      about: selectMultipleItemsProvider.filterList[index]
                                          [ModelAddInquiry.aboutInquiryKey])
                                  : const Center(child: CircularProgressIndicator());
                            },
                          );
                  }
                }),
          ),
        ));
  }

  _builder(
      {required int index,
      required Map<String, dynamic> map,
      required String studentName,
      required String phoneNumber,
      required String confirmationStatus,
      required String about,
      bool? isSelected = false,
      required String cnic,
      required BuildContext mainContext}) {
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
                backgroundColor: Colors.grey.shade200,
                spacing: 6,
                icon: Icons.edit,
                label: 'Edit',
                onPressed: (context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddInquiry(mode: 'Edit', map: map),
                    ),
                  );
                },
              ),
              SlidableAction(
                onPressed: (context) {
                  if (widget.userStatus[0].toString() == 'SuperAdmin') {
                    DBHandler.inquiryCollection()
                        .doc(cnic)
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
                    DBHandler.inquiryCollectionWithUID(
                            widget.userStatus[2].toString())
                        .doc(cnic)
                        .delete()
                        .then((value) => ScaffoldMessenger.of(mainContext)
                            .showSnackBar(const SnackBar(
                                backgroundColor: Colors.green,
                                content: Text('Deleted Successfully'))))
                        .catchError((error) => ScaffoldMessenger.of(mainContext)
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
                  setState: setState,
                  isSelected: isSelected,
                  index: index,
                  map: map),
              onTap: () => selectMultipleItemsProvider.onTap(
                  setState: setState,
                  isSelected: isSelected,
                  index: index,
                  map: map),
              leading: selectMultipleItemsProvider.buildSelectIcon(
                  isSelected: isSelected, context: context),
              title: Text(
                studentName,
                style: TextStyle(
                    fontSize:
                        MediaQuery.of(mainContext).size.width > 400 ? 20 : 15,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  cnic,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize:
                          MediaQuery.of(mainContext).size.width > 400 ? 17 : 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
              trailing: Column(
                children: [
                  Text(
                    phoneNumber,
                    style: TextStyle(
                        fontSize: MediaQuery.of(mainContext).size.width > 400
                            ? 17
                            : 14,
                        fontWeight: FontWeight.w100),
                  ),
                  TextButton(
                      onPressed: () {
                        if (widget.userStatus[0].toString() == 'SuperAdmin') {
                          DBHandler.inquiryCollection().doc(cnic).update({
                            ModelAddInquiry.confirmationStatusKey:
                                confirmationStatus == ('Confirmed')
                                    ? 'NotConfirmed'
                                    : 'Confirmed'
                          });
                          selectMultipleItemsProvider.dataList[index]
                                  [ModelAddInquiry.confirmationStatusKey] =
                              confirmationStatus == ('Confirmed')
                                  ? 'NotConfirmed'
                                  : 'Confirmed';
                          selectMultipleItemsProvider.filterList[index]
                                  [ModelAddInquiry.confirmationStatusKey] =
                              confirmationStatus == ('Confirmed')
                                  ? 'NotConfirmed'
                                  : 'Confirmed';
                        } else {
                          DBHandler.inquiryCollectionWithUID(
                                  widget.userStatus[2].toString())
                              .doc(cnic)
                              .update({
                            ModelAddInquiry.confirmationStatusKey:
                                confirmationStatus == ('Confirmed')
                                    ? 'NotConfirmed'
                                    : 'Confirmed'
                          });
                          selectMultipleItemsProvider.dataList[index]
                                  [ModelAddInquiry.confirmationStatusKey] =
                              confirmationStatus == ('Confirmed')
                                  ? 'NotConfirmed'
                                  : 'Confirmed';
                          selectMultipleItemsProvider.filterList[index]
                                  [ModelAddInquiry.confirmationStatusKey] =
                              confirmationStatus == ('Confirmed')
                                  ? 'NotConfirmed'
                                  : 'Confirmed';
                        }
                      },
                      child: FittedBox(
                          child: Text(confirmationStatus,
                              style: TextStyle(
                                  color: confirmationStatus == 'Confirmed'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))))
                ],
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
      allDataDoc = await DBHandler.inquiryCollection().get();
    } else {
      allDataDoc = await DBHandler.inquiryCollectionWithUID(
              widget.userStatus[2].toString())
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

  void deleteItems(BuildContext context) {
    if (widget.userStatus[0].toString() == 'SuperAdmin') {
      for (var item in selectMultipleItemsProvider.list) {
        DBHandler.feeHistoryCollection()
            .doc(item[ModelFeeVoucher.cnicKey])
            .delete()
            .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went Wrong'))));
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Deleted Successfully')));
    } else {
      for (var item in selectMultipleItemsProvider.list) {
        DBHandler.feeHistoryCollectionWithUserUID(
                widget.userStatus[2].toString())
            .doc(item[ModelFeeVoucher.cnicKey])
            .delete()
            .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Something went Wrong'))));
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
