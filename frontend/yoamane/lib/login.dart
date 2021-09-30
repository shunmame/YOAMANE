import 'package:yoamane/timetable_time_form.dart';

import 'yoamane_libraries.dart';
import 'timetable.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final token =
      'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6InVzZXIxIiwiZXhwIjoxNjMzMDU0NTc4fQ.BwUuKkShcvjduPN8laSfwUsW9G6XSAGIUw-cNZCzU14';

  // void setToken() async {
  //   var userData = await SharedPreferences.getInstance();
  //   userData.setString('token',
  //       'JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJ1c2VybmFtZSI6InVzZXIxIiwiZXhwIjoxNjMzMDU0NTc4fQ.BwUuKkShcvjduPN8laSfwUsW9G6XSAGIUw-cNZCzU14');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ログインページ'),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 20.0, height: 20.0),
              Text('ID', style: TextStyle(fontSize: 20.0)),
              TextFormField(
                maxLength: 30,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              SizedBox(width: 20.0, height: 20.0),
              Text('パスワード', style: TextStyle(fontSize: 20.0)),
              TextFormField(
                obscureText: true,
                cursorColor: Colors.black,
                maxLength: 50,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => formStatus(value),
              ),
              Container(
                width: double.infinity,
                height: 125.0,
                alignment: Alignment.center,
                child: ElevatedButton(
                  child: Text('ログイン', style: TextStyle(fontSize: 15.0)),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => TimetableTimeFormPage(
                                token: token,
                              )));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
