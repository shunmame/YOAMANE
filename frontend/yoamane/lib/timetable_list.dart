import 'yoamane_libraries.dart';
import 'timetable_edit.dart';

class TimetableListPage extends StatefulWidget {
  TimetableListPage({required this.subjectName, this.subjectID});

  final subjectName;
  final subjectID;

  @override
  State<StatefulWidget> createState() => _TimetableListPage();
}

class _TimetableListPage extends State<TimetableListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('時間割の編集'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
//          Navigator.of(context).push(
//            MaterialPageRoute(
//                builder: (context) => AssignmentFormPage(
//                      subjectName: widget.subjectName,
//                      subjectID: widget.subjectID,
//                      currentDate: widget.currentDate,
//                    )),
//          );
        },
      ),
      body: Column(
        children: [
          SizedBox(width: 20.0, height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('月', style: TextStyle(fontSize: 25.0)),
              Text('火', style: TextStyle(fontSize: 25.0)),
              Text('水', style: TextStyle(fontSize: 25.0)),
              Text('木', style: TextStyle(fontSize: 25.0)),
              Text('金', style: TextStyle(fontSize: 25.0)),
            ],
          ),
          SizedBox(width: 20.0, height: 20.0),
          GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              childAspectRatio: 0.75,
            ),
            itemCount: 20,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  title: Text(
                    '${(index / 5).floor() + 1}限',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  subtitle: Text(
                    widget.subjectName[index] == '空き'
                        ? ''
                        : widget.subjectName[index],
                    style: TextStyle(fontSize: 30.0),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TimetableEditPage(
                              subjectName: widget.subjectName,
                              subjectID: widget.subjectID,
                              classNumber: (index / 5).floor() + 1,
                              currentIndex: index,
                            )));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
