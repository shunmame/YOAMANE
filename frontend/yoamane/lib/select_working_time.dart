import 'yoamane_libraries.dart';

class SelectWorkingTimePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectWorkingTimePage();
}

class _SelectWorkingTimePage extends State<SelectWorkingTimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AIの候補'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: 3,
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
                  child: Text('${' 12 : 00 〜 23 : 00 '}',
                      style: TextStyle(fontSize: 25)),
                  onPressed: () {},
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
