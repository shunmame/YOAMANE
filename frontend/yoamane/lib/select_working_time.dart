import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'package:intl/intl.dart';

class SelectWorkingTimePage extends StatefulWidget {
  SelectWorkingTimePage({this.candidate, this.assignmentData});

  final candidate;
  final assignmentData;

  @override
  State<StatefulWidget> createState() => _SelectWorkingTimePage();
}

class _SelectWorkingTimePage extends State<SelectWorkingTimePage> {
  List<DateTime> _start = [];
  List<DateTime> _end = [];

  void setup() {
    Set<int> _suggestIndex = {};

    for (int i = 0; _suggestIndex.length < 3; i++) {
      _suggestIndex.add(Random().nextInt(widget.candidate.length));
      if (i == widget.candidate.length - 1) break;
    }
    for (int i = 0; i < _suggestIndex.length; i++) {
      final _index = _suggestIndex.elementAt(i);

      _start.add(DateTime.parse(widget.candidate[_index]["start_time"]));
      _end.add(DateTime.parse(widget.candidate[_index]["end_time"]));
    }
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIの候補'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'AIによる取り組み時間の候補です\nどの時間を予定に追加しますか？',
            style: TextStyle(fontSize: 35.0),
            textAlign: TextAlign.center,
          ),
          SizedBox(width: double.infinity, height: 50.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _start.length,
            itemBuilder: (context, index) {
              return ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '候補${index + 1}',
                    style: TextStyle(fontSize: 25.0),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                    ),
                    child: Text(
                        '${DateFormat('MM/dd HH:mm').format(_start[index])} ~ ${DateFormat('MM/dd HH:mm').format(_end[index])}',
                        style: TextStyle(fontSize: 25)),
                    onPressed: () async {
                      final _address = Uri.parse(
                          'http://sysken8.japanwest.cloudapp.azure.com/api/schedule/');
                      final _headers = {
                        'content-type': 'application/json',
                        'Authorization': token
                      };
                      final _body = json.encode({
                        "title": "${widget.assignmentData["name"]}",
                        "start_time": _start[index].toIso8601String(),
                        "end_time": _end[index].toIso8601String(),
                        "is_all_day": false,
                        "nofitying_time": null,
                        "collaborating_member_id": 2,
                        "memo": "${widget.assignmentData["memo"]}",
                        "user": 2,
                      });

                      final _resp = await http.post(_address,
                          headers: _headers, body: _body);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        // ignore: unrelated_type_equality_checks
                        content: Text(
                            _resp.statusCode == 200 || _resp.statusCode == 201
                                ? '保存しました'
                                : '保存できませんでした'),
                      ));
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
