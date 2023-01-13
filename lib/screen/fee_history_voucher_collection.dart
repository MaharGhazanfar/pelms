import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:provider/provider.dart';
import '../provider/model_fee_voucher.dart';
import '../util/firebase_db_handler.dart';
import '../util/item_select_check.dart';


class FeeVoucherDetails extends StatefulWidget {
  final List<String> userStatus;

  const FeeVoucherDetails({Key? key, required this.userStatus})
      : super(key: key);
  static const pageName = '/FeeVoucherDetails';

  @override
  _FeeVoucherDetailsState createState() => _FeeVoucherDetailsState();
}

class _FeeVoucherDetailsState extends State<FeeVoucherDetails> {
  List<Map<String, dynamic>> dataList = [];
  final PageController _pageController =
  PageController(viewportFraction: .35, initialPage: 1);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late Stream<QuerySnapshot> _feeHistoryStream;
  late SelectMultipleItems selectMultipleItemsProvider =
  Provider.of<SelectMultipleItems>(context);
  late TextEditingController _searchController;
  bool dataLoad = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (widget.userStatus.toString().contains('SuperAdmin')) {
      _feeHistoryStream =
          DBHandler.feeHistoryCollection().orderBy('Date').snapshots();
    } else {
      _feeHistoryStream = DBHandler.feeHistoryCollectionWithUserUID(
          widget.userStatus[2].toString())
          .orderBy('Date')
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
  Widget build(BuildContext context) {
    dataLoad ? getData() : null;
    dataLoad = false;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: selectMultipleItemsProvider.isNotSearching
            ? selectMultipleItemsProvider.appBarTitle(
          'Fee History',
        )
            : selectMultipleItemsProvider.appBarTextField(
            searchController: _searchController,
            setState: setState,
            searchingFor: 'Fee History'),
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
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(' There is no data for search')));
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
              deleteItems(_scaffoldKey.currentContext!);
              _searchController.clear();
            },
          )
              : const SizedBox(),
        ],
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: kIsWeb
              ? MediaQuery
              .of(context)
              .size
              .width * 0.7
              : MediaQuery
              .of(context)
              .size
              .width,
          child: StreamBuilder<QuerySnapshot>(
            stream: _feeHistoryStream,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text(
                    'Something went wrong////////////////////////////////////////////////////');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return selectMultipleItemsProvider.isNotSearching ? PageView
                    .builder(
                  itemCount: snapshot.data!.docs.length,
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    var doc = snapshot
                        .data!.docs[(snapshot.data!.docs.length - 1) - index]
                        .data() as Map<String, dynamic>;
                    bool? isSelected = selectMultipleItemsProvider
                        .selectedFlag[index];
                    return isSelected != null
                        ? _builder(
                        map: doc,
                        index: index,
                        isSelected: isSelected,
                        pk: doc[ModelFeeVoucher.dateKey]
                            .toString(),
                        studentName: doc[ModelFeeVoucher.studentNameKey],
                        installment: doc[ModelFeeVoucher.installmentKey],
                        studentCnic: doc[ModelFeeVoucher.cnicKey],
                        time: doc[ModelFeeVoucher.timeKey],
                        courseName: doc[ModelFeeVoucher.courseNameKey],
                        amount: doc[ModelFeeVoucher.amountKey].toString(),
                        date: doc[ModelFeeVoucher.dateKey]
                            .toString()
                            .substring(0, 10)) : const Center(
                        child: CircularProgressIndicator());
                  },
                ) : PageView.builder(
                  itemCount:
                  selectMultipleItemsProvider.filterList.length,
                  scrollDirection: Axis.vertical,
                  controller: _pageController,
                  itemBuilder: (BuildContext context, int index) {
                    print(
                        '${selectMultipleItemsProvider.filterList
                            .length}//////');
                    bool? isSelected = selectMultipleItemsProvider
                        .selectedFlag[index];
                    return isSelected != null
                        ? _builder(
                        index: index,
                        pk: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.dateKey]
                            .toString(),
                        map: selectMultipleItemsProvider
                            .filterList[index],
                        isSelected: isSelected,
                        studentName: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.studentNameKey],
                        installment: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.installmentKey],
                        studentCnic: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.cnicKey],
                        time: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.timeKey],
                        courseName: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.courseNameKey],
                        amount: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.amountKey]
                            .toString(),
                        date: selectMultipleItemsProvider
                            .filterList[index][ModelFeeVoucher.dateKey]
                            .toString()
                            .substring(0, 10))
                        : const Center(child: CircularProgressIndicator());
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  _builder({required int index,
    required String studentName,
    required String installment,
    required String studentCnic,
    required String pk,
    required String time,
    required Map<String, dynamic> map,
    bool? isSelected = false,
    required String courseName,
    required String amount,
    required String date}) {
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
                onPressed: (context) async {
                  if (widget.userStatus[0].toString() == 'SuperAdmin') {
                    DBHandler.feeHistoryCollection()
                        .doc(pk)
                        .delete()
                        .then((value) =>
                        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                            .showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Deleted Successfully'))))
                        .catchError((error) =>
                        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                            .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Something went Wrong'))));
                  } else {
                    DBHandler.feeHistoryCollectionWithUserUID(
                        widget.userStatus[2].toString())
                        .doc(pk)
                        .delete()
                        .then((value) =>
                        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
                            .showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Deleted Successfully'))))
                        .catchError((error) =>
                        ScaffoldMessenger.of(_scaffoldKey.currentContext!)
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
          child: GestureDetector(
            onLongPress: () =>
                selectMultipleItemsProvider.onLongPress(
                    setState: setState,
                    isSelected: isSelected!,
                    index: index,
                    map: map),
            onTap: () =>
                selectMultipleItemsProvider.onTap(
                    setState: setState,
                    isSelected: isSelected!,
                    index: index,
                    map: map),
            child: Container(
              decoration: BoxDecoration(
                  color: isSelected! ? Colors.green.shade200 : Colors.grey
                      .shade50,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Flexible(
                              child: FittedBox(
                                  child: Text(
                                    'Name :',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  )),
                            ),
                            Flexible(
                              child: FittedBox(
                                child: Text(
                                  studentName,
                                  overflow: TextOverflow.fade,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FittedBox(
                                child: Text(
                                  'CNIC :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            FittedBox(
                                child: Text(
                                  studentCnic,
                                  style: const TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FittedBox(
                                child: Text(
                                  'Group Name :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            FittedBox(
                                child: Text(
                                  courseName,
                                  style: const TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FittedBox(
                                child: Text(
                                  'Amount :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            FittedBox(
                                child: Text(
                                  'PKR.$amount',
                                  style: const TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FittedBox(
                                child: Text(
                                  'Installment :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            FittedBox(
                                child: Text(
                                  installment,
                                  style: const TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FittedBox(
                                child: Text(
                                  'Date :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            FittedBox(
                                child: Text(
                                  date,
                                  style: const TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const FittedBox(
                                child: Text(
                                  'Time :',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )),
                            FittedBox(
                                child: Text(
                                  time,
                                  style: const TextStyle(fontSize: 15),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
      allDataDoc = await DBHandler.feeHistoryCollection().orderBy('Date').get();
    } else {
      allDataDoc = await DBHandler.feeHistoryCollectionWithUserUID(
          widget.userStatus[2].toString())
          .orderBy('Date')
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
        '${selectMultipleItemsProvider.filterList
            .length}//////////////////////////????????????');
  }

  void deleteItems(BuildContext context) {
    if (widget.userStatus[0].toString() == 'SuperAdmin') {
      for (var item in selectMultipleItemsProvider.list) {
        DBHandler.feeHistoryCollection()
            .doc(item[ModelFeeVoucher.dateKey])
            .delete()
            .catchError((error) =>
            ScaffoldMessenger.of(context).showSnackBar(
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
            .doc(item[ModelFeeVoucher.dateKey])
            .delete()
            .catchError((error) =>
            ScaffoldMessenger.of(context).showSnackBar(
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
