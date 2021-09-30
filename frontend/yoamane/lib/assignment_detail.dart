import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class AssignmentDetailPage extends StatefulWidget {
  AssignmentDetailPage(
      {this.subjectName, this.subjectTask, this.subjectSubtask});

  final subjectName;
  final subjectTask;
  final subjectSubtask;

  @override
  State<StatefulWidget> createState() => _AssignmentDetailPage();
}

class _AssignmentDetailPage extends State<AssignmentDetailPage> {
  bool _value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subjectName}の課題リスト'),
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 1,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Card(
                  child: ListTile(
                    title: Text(
                      utf8.decode((widget.subjectTask['name']).runes.toList()),
                      style: TextStyle(fontSize: 30.0),
                    ),
                    subtitle: Text(
                      '期日 : ' +
                          DateFormat('yyyy年M月d日').format(DateTime.parse(
                              widget.subjectTask['limited_time'])),
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onTap: () {},
                  ),
                ),
                if (widget.subjectSubtask.length != 0)
                  Card(
                    child: CheckboxListTile(
                      title: Text(
                        utf8.decode(
                            (widget.subjectSubtask[0]['name']).runes.toList()),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      activeColor: Colors.black,
                      value: _value,
                      onChanged: (bool? value) => setState(() {
                        _value = value!;
                      }),
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
