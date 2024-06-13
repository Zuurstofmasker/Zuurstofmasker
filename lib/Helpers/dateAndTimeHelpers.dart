import 'package:flutter/material.dart';

int timeOfDayToMinutes(TimeOfDay myTime) => (myTime.hour * 60) + myTime.minute;

DateTime setTimeOfDayOfDateTime(
  DateTime date,
  TimeOfDay timeOfDay,
) =>
    DateUtils.dateOnly(date)
        .add(Duration(minutes: timeOfDayToMinutes(timeOfDay)));

DateTime dateTimeMinutePresicion(DateTime date) =>
    DateTime(date.year, date.month, date.day, date.hour, date.minute);
