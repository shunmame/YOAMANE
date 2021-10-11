import 'yoamane_libraries.dart';
import 'timetable_time_form.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('ログインページ'),
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () async => false,
        child: Form(
          key: _formKey,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20.0, height: 20.0),
                Text('ID', style: TextStyle(fontSize: 30.0)),
                TextFormField(
                  maxLength: 30,
                  initialValue: 'user1',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => formStatus(value),
                ),
                SizedBox(width: 20.0, height: 20.0),
                Text('パスワード', style: TextStyle(fontSize: 30.0)),
                TextFormField(
                  obscureText: true,
                  cursorColor: Colors.black,
                  maxLength: 50,
                  initialValue: 'user1',
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => formStatus(value),
                ),
                Container(
                  width: double.infinity,
                  height: 125.0,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('ログイン', style: TextStyle(fontSize: 20.0)),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => TimetableTimeFormPage()));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
