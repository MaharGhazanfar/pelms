import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NetworkErrorPage extends StatefulWidget {
  const NetworkErrorPage({Key? key}) : super(key: key);

  @override
  State<NetworkErrorPage> createState() => _NetworkErrorPageState();
}

class _NetworkErrorPageState extends State<NetworkErrorPage> {
  @override
  Widget build(BuildContext context) {
    return   Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:  [
          const Icon(Icons.network_check,size: 80,color: Colors.red,),
          const Padding(
            padding: EdgeInsets.only(left: 50.0,right: 50),
            child: Text(
                'No internet connection, '
                    'please reconnect and try again',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(onPressed: () {
            if(kIsWeb){
              SystemNavigator.pop();
            }else{
              AppSettings.openDeviceSettings();
            }

          }, child: const Text('open setting'))

        ],
      ),
    );

  }
}
