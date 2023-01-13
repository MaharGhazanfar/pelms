import 'package:day_night_time_picker/lib/constants.dart';
import 'package:day_night_time_picker/lib/daynight_timepicker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomTimePicker {
  static Widget timeGetter(
      {required void Function(TimeOfDay) onTimeChanged,
      required TimeOfDay time,
      required bool iosStyle,
      required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          showPicker(
            is24HrFormat: false,
            iosStylePicker: iosStyle,
            context: context,
            value: time,
            onChange: onTimeChanged,
            minuteInterval: MinuteInterval.FIVE,
            onChangeDateTime: (DateTime dateTime) {},
          ),
        );
      },
      child: Container(
          width:   kIsWeb? MediaQuery.of(context).size.width / 5: MediaQuery.of(context).size.width / 3,
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(
                      3,
                      3,
                    ),
                    spreadRadius: 5,
                    blurRadius: 5)
              ]),
          child: Text('${time.hourOfPeriod} : '
              '${time.minute} '
              '${time.period.toString().substring(10, 12)}')),
    );
  }
}
