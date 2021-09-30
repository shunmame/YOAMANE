// import 'yoamane_libraries.dart';

// Future _getPreferences() async {
//   var preferences = await SharedPreferences.getInstance();
//   print(preferences.getInt("test_int_key"));
//   print(preferences.getString("test_string_key"));
//   print(preferences.getBool("test_bool_key"));
//   print(preferences.getDouble("test_double_key"));
// }

// Future _setPreferences() async {
//   var userData = await SharedPreferences.getInstance();
//   userData.setString('token',
//       'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6InVzZXIxIiwiZXhwIjoxNjMzMDU0NTc4fQ.BwUuKkShcvjduPN8laSfwUsW9G6XSAGIUw-cNZCzU14');
// }

// Future _deletePreferences(String key) async {
//   var preferences = await SharedPreferences.getInstance();
//   if (preferences.containsKey(key)) {
//     await preferences.remove(key);
//   }
// }

// Future _deleteAllPreferences() async {
//   var preferences = await SharedPreferences.getInstance();
//   await preferences.clear();
// }
