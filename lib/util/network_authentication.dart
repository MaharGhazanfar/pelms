import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkAuth {
  static Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else if (connectivityResult == ConnectivityResult.bluetooth) {
      return true;
    } else if (connectivityResult == ConnectivityResult.ethernet) {
      return true;
    }
    return false;
  }

  static void showNow(BuildContext mainContext) {
    showDialog(
        context: mainContext,
        builder: (BuildContext mainContext) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Material(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: SizedBox(
                  height: MediaQuery.of(mainContext).size.height * 0.3,
                  width: MediaQuery.of(mainContext).size.width * 7,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.network_check,
                          size: 80,
                          color: Colors.red,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 50.0, right: 50.0),
                          child: Text(
                              'No internet connection, '
                              'please reconnect and try again',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(mainContext);
                            },
                            child: const Text('OK '))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
