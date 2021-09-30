import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'assignment_form.dart';

class AssignmentListPage extends StatefulWidget {
  AssignmentListPage({required this.subjectName, this.subjectTask});

  final List<String> subjectName;
  final subjectTask;

  @override
  State<StatefulWidget> createState() => _AssignmentListPage();
}

class _AssignmentListPage extends State<AssignmentListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('課題一覧'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AssignmentFormPage(
                      subjectName: widget.subjectName,
                    )),
          );
        },
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.subjectName.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  width: double.infinity,
                  child: Text(
                    widget.subjectName[index],
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      utf8.decode(
                          (widget.subjectTask[index]['name']).runes.toList()),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    subtitle: Text(
                      '期日 : ' +
                          DateFormat('yyyy年M月d日').format(DateTime.parse(
                              widget.subjectTask[index]['limited_time'])),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
