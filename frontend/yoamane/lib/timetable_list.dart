import 'yoamane_libraries.dart';
import 'timetable_form.dart';

class TimetableListPage extends StatefulWidget {
  TimetableListPage({this.subjectName});

  final subjectName;

  @override
  State<StatefulWidget> createState() => _TimetableListPage();
}

class _TimetableListPage extends State<TimetableListPage> {
  final weekday = ['月曜', '火曜', '水曜', '木曜', '金曜'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('時間割の編集'),
      ),
      body: SafeArea(
        child: GridView.builder(
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
                  '${weekday[index % 5]}${(index / 5).floor() + 1}限',
                  style: TextStyle(fontSize: 15.0),
                ),
                subtitle: Text(
                  widget.subjectName[index],
                  style: TextStyle(fontSize: 25.0),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => TimetableFormPage(
                            subjectName: widget.subjectName[index],
                            classNumber: (index / 5).floor() + 1,
                          )));
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
