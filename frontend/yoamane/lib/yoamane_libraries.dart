// Here are libraries for YOAMANE

import 'package:intl/intl.dart';

export 'dart:io';
export 'dart:async';
export 'dart:convert';

export 'package:flutter/material.dart';
export 'package:flutter/services.dart';
export 'package:flutter/rendering.dart';
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

var friendList = [
  'user3',
  'user4',
  'user5',
];

var tags = ['A', 'B', 'C'];

List<List<String>> weeklySchedule = [
  ['英語II', '数学II (4H)', '物理I', ''],
  ['HR', '数学II (2H)', '物理I', ''],
  ['情報処理', '生涯スポーツII', '英語II', '倫理'],
  ['世界史', '世界史', '', ''],
  ['機械製図', '数学II (4H)', '国語II', 'リベラルアーツ実践I'],
];

List<Map<String, dynamic>> assignment = [
  {
    'subject': '数学II (4H)',
    'contents': [
      '過去問',
      '演習1~4',
      '過去問',
      '演習1~4',
      '過去問',
      '演習1~4',
    ],
    'due': DateFormat('yyyy年M月d日').format(DateTime(2021, 09, 20, 23, 59)),
  },
  {
    'subject': '英語II',
    'contents': [
      '単語帳',
      'Workbook',
    ],
    'due': DateFormat('yyyy年M月d日').format(DateTime(2021, 09, 20, 23, 59)),
  },
];

Set<String> subjectList = weeklySchedule.expand((e) => e).toSet();
