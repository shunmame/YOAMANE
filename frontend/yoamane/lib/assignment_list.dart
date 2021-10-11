import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';
import 'assignment_edit.dart';
import 'assignment_form.dart';

class AssignmentListPage extends StatefulWidget {
  AssignmentListPage({
    required this.subjectName,
    this.subjectID,
    this.subjectTask,
    this.currentDate,
  });

  final List<String> subjectName;
  final subjectID;
  final subjectTask;
  final currentDate;

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
        onPressed: () async {
          List<String> _friendUserName = [];
          final _friendIDAddress = Uri.parse(
              'http://sysken8.japanwest.cloudapp.azure.com/api/friend/?user=2');
          final _friendIDHeader = {'Authorization': token};
          final _friendIDResp =
              await http.get(_friendIDAddress, headers: _friendIDHeader);
          final _friendNum = json.decode(_friendIDResp.body).length;

          for (int i = 1; i < _friendNum; i++) {
            final _friendID = json.decode(_friendIDResp.body)[i]['friend_user'];

            final _friendUserAddress = Uri.parse(
                'http://sysken8.japanwest.cloudapp.azure.com/api/user/$_friendID');
            final _friendUserHeader = {'Authorization': token};
            final _friendUserResp =
                await http.get(_friendUserAddress, headers: _friendUserHeader);
            _friendUserName.add(utf8.decode(
                (json.decode(_friendUserResp.body)['username'])
                    .runes
                    .toList()));
          }

          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => AssignmentFormPage(
                      subjectName: widget.subjectName,
                      subjectID: widget.subjectID,
                      friendList: _friendUserName,
                      currentDate: widget.currentDate,
                    )),
          );
        },
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.subjectName.length,
          itemBuilder: (context, i) {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 15.0, 0.0, 0.0),
                  width: double.infinity,
                  child: Text(
                    widget.subjectName[i],
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 25.0),
                  ),
                ),
                Card(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.subjectTask[i].length,
                    itemBuilder: (context, j) {
                      return ListTile(
                        title: Text(
                          widget.subjectTask[i].length != 0
                              ? utf8.decode((widget.subjectTask[i][j]['name'])
                                  .runes
                                  .toList())
                              : '',
                          style: TextStyle(fontSize: 20.0),
                        ),
                        subtitle: Text(
                          widget.subjectTask[i].length != 0
                              ? '期日 : ' +
                                  DateFormat('yyyy年M月d日').format(DateTime.parse(
                                      widget.subjectTask[i][j]['limited_time']))
                              : '',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AssignmentEditPage(
                                    assignmentData: widget.subjectTask[i][j],
                                    subjectID: widget.subjectID,
                                    currentDate: widget.currentDate,
                                  )));
                        },
                      );
                    },
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
