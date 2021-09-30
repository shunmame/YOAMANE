// import 'yoamane_libraries.dart';
// import 'assignment_list.dart';
// import 'schedule_form.dart';
// import 'logout.dart';
// import 'subject_form.dart';
//
// class CalendarPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _CalendarPage();
// }
//
// class _CalendarPage extends State<CalendarPage> {
//   Map<DateTime, List<CleanCalendarEvent>> _events = {
//     DateTime(2021, 10, 9, 00, 00): [
//       CleanCalendarEvent(
//         'プロコン本戦',
//         startTime: DateTime(2021, 10, 9, 00, 00),
//         endTime: DateTime(2021, 10, 7, 23, 59),
//         description: 'プロコン本戦(10/9~10/10)',
//         isAllDay: true,
//         isDone: true,
//         color: Colors.blue,
//       ),s
//     ],
//     DateTime(2021, 10, 10, 00, 00): [
//       CleanCalendarEvent(
//         'プロコン本戦',
//         startTime: DateTime(2021, 10, 10, 00, 00),
//         endTime: DateTime(2021, 10, 10, 23, 59),
//         description: 'プロコン本戦(10/9~10/10)',
//         isAllDay: true,
//         color: Colors.blue,
//       ),
//     ],
//   };
//
//   @override
//   Widget build(BuildContext context) {
//     final double deviceHeight = MediaQuery.of(context).size.height;
//     String _selectStatus = '';
//     List<String> _articles = ['時間割', '予定ラベル', '友達', '予定', '課題', 'ログアウト'];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YOAMANE'),
//         automaticallyImplyLeading: false,
//         actions: [
//           PopupMenuButton<String>(
//             initialValue: _selectStatus,
//             onSelected: (String s) {
//               if (s == _articles[0]) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => SubjectFormPage()),
//                 );
//               } else if (s == _articles[2]) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => FriendsListPage()),
//                 );
//               } else if (s == _articles[3]) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => ScheduleFormPage()),
//                 );
//               } else if (s == _articles[4]) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => AssignmentListPage()),
//                 );
//               } else if (s == _articles[5]) {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => LogoutPage()),
//                 );
//               }
//             },
//             itemBuilder: (context) {
//               return _articles
//                   .map((String s) => PopupMenuItem(child: Text(s), value: s))
//                   .toList();
//             },
//           )
//         ],
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           LimitedBox(
//             maxHeight: deviceHeight * (3.0 / 5.0),
//             child: Calendar(
// //          startOnMonday: false,
//               weekDays: ['月', '火', '水', '木', '金', '土', '日'],
//               events: _events,
//               eventDoneColor: Colors.black,
//               selectedColor: Colors.pink,
//               todayColor: Colors.blue,
//               eventColor: Colors.green,
//               locale: 'ja_JP',
//               todayButtonText: '',
//               isExpanded: true,
//               expandableDateFormat: 'yyyy年 M月d日 EEEE',
//               dayOfWeekStyle: TextStyle(
//                 color: Colors.black,
//                 fontWeight: FontWeight.w800,
//                 fontSize: 10.0,
//               ),
//             ),
//           ),
//           // SafeArea(
//           //   child: ,
//           // )
//         ],
//       ),
//     );
//   }
// }
//
// // // とりあえず今日明日の時間割+その他予定を表示
// // Map<DateTime, List<CleanCalendarEvent>> jsonToEvents() {
// //   List<List<String>> timetable = [
// //     ['英語II', '数学II (4H)', '物理I', '', ''],
// //     ['HR', '数学II (2H)', '物理I', '', ''],
// //     ['情報処理', '生涯スポーツII', '英語II', '倫理', ''],
// //     ['世界史', '世界史', '', '', ''],
// //     ['機械製図', '数学II (4H)', '国語II', 'リベラルアーツ実践I', ''],
// //   ];
// //
// //   int dateDiff = 1;
// //   DateTime now = DateTime.now();
// //   DateTime today = DateTime(now.year, now.month, 27, 00, 00);
// //   if (today.weekday == 5) {
// //     dateDiff = 3;
// //   } else if (today.weekday >= 6) {
// //     today = today.add(Duration(days: 8 - today.weekday));
// //   }
// //
// //   DateTime tomorrow = today.add(Duration(days: dateDiff));
// //
// //   List<CleanCalendarEvent> scheduleOfToday = [];
// //   List<CleanCalendarEvent> scheduleOfTomorrow = [];
// //
// //   for (int i = 0; i < timetable.length; i++) {
// //     if (timetable[today.weekday - 1][i] == '') continue;
// //     scheduleOfToday.add(CleanCalendarEvent(
// //       '${i + 1}限目',
// //       startTime: timeSchedule(today)[i],
// //       endTime: timeSchedule(today)[i].add(Duration(minutes: 90)),
// //       description: timetable[today.weekday - 1][i],
// //     ));
// //   }
// //   for (int i = 0; i < timetable.length; i++) {
// //     if (timetable[tomorrow.weekday - 1][i] == '') continue;
// //     scheduleOfTomorrow.add(CleanCalendarEvent(
// //       '${i + 1}限目',
// //       startTime: timeSchedule(today)[i],
// //       endTime: timeSchedule(today)[i].add(Duration(minutes: 90)),
// //       description: timetable[tomorrow.weekday - 1][i],
// //     ));
// //   }
// //
// //   return {today: scheduleOfToday, tomorrow: scheduleOfTomorrow};
// // }
// //
// // List<DateTime> timeSchedule(DateTime date) {
// //   DateTime classTime(int hour, int minute) =>
// //       DateTime(date.year, date.month, date.day, hour, minute);
// //
// //   return [
// //     classTime(8, 50),
// //     classTime(10, 30),
// //     classTime(13, 15),
// //     classTime(14, 55),
// //     classTime(16, 35),
// //   ];
// // }
