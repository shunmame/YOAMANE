import 'yoamane_libraries.dart';

class SubjectFormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SubjectFormPage();
}

class _SubjectFormPage extends State<SubjectFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _selected = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('新規教科'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 20.0, height: 20.0),
                Text('教科名'),
                TextFormField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => formStatus(value),
                ),
                SizedBox(width: 20.0, height: 20.0),
                Text('カラー'),
                GridView.builder(
                  padding: EdgeInsets.fromLTRB(2.5, 0.0, 2.5, 0.0),
                  itemCount: 16,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 30.0,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
//                      alignment: Alignment.topLeft,
//                      width: double.infinity,
//                      decoration: BoxDecoration(
//                        border: Border.all(color: Colors.grey),
//                        borderRadius: BorderRadius.circular(5.0),
//                        color: labelColor[index],
//                      ),
//                      child: Radio(
//                        value: labelName[index],
//                        activeColor: Colors.lightBlue,
//                        groupValue: _selected,
//                        onChanged: (String? value) => setState(() {
//                          _selected = value!;
//                        }),
//                      ),
                        );
                  },
                ),
                Container(
                  width: double.infinity,
                  height: 125.0,
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    child: Text('登録'),
                    onPressed: () {},
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
