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
          itemCount: widget.subjectTask.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                if (widget.subjectTask.length != 0)
                  Card(
                    child: ListTile(
                      title: Text(
                        utf8.decode(
                            (widget.subjectTask[index]['name']).runes.toList()),
                        style: TextStyle(fontSize: 30.0),
                      ),
                      subtitle: Text(
                        '期日 : ' +
                            DateFormat('yyyy年M月d日').format(DateTime.parse(
                                widget.subjectTask[index]['limited_time'])),
                        style: TextStyle(fontSize: 20.0),
                      ),
                      onTap: () {},
                    ),
                  ),
//                if (widget.subjectSubtask.length != 0 && index == 0)
//                  Card(
//                    child: CheckboxListTile(
//                      title: Text(
//                        widget.subjectSubtask[0]['name'],
////                        utf8.decode((widget.subjectSubtask[0]['name'])
////                            .runes
////                            .toList()),
//                        style: TextStyle(fontSize: 20.0),
//                      ),
//                      activeColor: Colors.black,
//                      value: _value,
//                      onChanged: (bool? value) => setState(() {
//                        _value = value!;
//                      }),
//                    ),
//                  ),
//                if (widget.subjectSubtask.length != 0 && index == 0)
//                  Card(
//                    child: CheckboxListTile(
//                      title: Text(
//                        widget.subjectSubtask[1]['name'],
//                        style: TextStyle(fontSize: 20.0),
//                      ),
//                      activeColor: Colors.black,
//                      value: _value,
//                      onChanged: (bool? value) => setState(() {
//                        _value = value!;
//                      }),
//                    ),
//                  ),
//                if (widget.subjectSubtask.length != 0 && index == 0)
//                  Card(
//                    child: CheckboxListTile(
//                      title: Text(
//                        widget.subjectSubtask[2]['name'],
//                        style: TextStyle(fontSize: 20.0),
//                      ),
//                      activeColor: Colors.black,
//                      value: _value,
//                      onChanged: (bool? value) => setState(() {
//                        _value = value!;
//                      }),
//                    ),
//                  ),
                SizedBox(width: 20.0, height: 20.0),
              ],
            );
          },
        ),
      ),
    );
  }
}
