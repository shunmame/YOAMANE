// Here are libraries for YOAMANE

export 'dart:io';
export 'dart:math';
export 'dart:async';
export 'dart:convert';
import 'dart:convert';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:fluttertoast/fluttertoast.dart';
export 'package:flutter_calendar_carousel/classes/event.dart';
export 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
export 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
export 'package:select_form_field/select_form_field.dart';
export 'package:flutter_local_notifications/flutter_local_notifications.dart';
export 'package:shared_preferences/shared_preferences.dart';

export 'notification.dart';

String? formStatus(String? value) => (value!.isEmpty ? '項目を記入してください' : null);

String utf8Convert(String value) => utf8.decode((value).runes.toList());

final token =
    'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6InVzZXIxIiwiZXhwIjoxNjM0NDI1NjA4fQ.U3ksWuhxolet6lomavcHzMK6GtcaEFlAOYmf4T2Ckuk';
