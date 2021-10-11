import 'package:http/http.dart' as http;
import 'yoamane_libraries.dart';
import 'friend_form.dart';
import 'tag_form.dart';

class FriendListPage extends StatefulWidget {
  FriendListPage({this.friendName, this.tagList});

  final friendName;
  final tagList;

  @override
  State<StatefulWidget> createState() => _FriendListPage();
}

class _FriendListPage extends State<FriendListPage> {
  List<bool> _selected = [];

  void setup() {
    _selected = List.filled((widget.tagList).length, false);
  }

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('フレンドリスト'),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: 20.0, height: 20.0),
            Text('あなたのフレンド', style: TextStyle(fontSize: 25.0)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.friendName.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Container(
                      width: deviceWidth / 2.0,
                      child: Text(
                        widget.friendName[index],
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 35.0),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomRight,
                      width: deviceWidth / 2.25,
                      child: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(child: Text('削除')),
                        ],
                        // onSelected:  ,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(width: 20.0, height: 20.0),
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 25.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () async {
                  final _address = Uri.parse(
                      'http://sysken8.japanwest.cloudapp.azure.com/api/user/1/');
                  final _headers = {
                    'content-type': 'application/json',
                    'Authorization': token
                  };
                  final _resp = await http.get(_address, headers: _headers);
                  final _ID = json.decode(_resp.body)["user_id"].split('-');

                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => FriendFormPage(id: _ID[0])),
                  );
                },
              ),
            ),
            SizedBox(width: 20.0, height: 20.0),
            Text('あなたのタグ', style: TextStyle(fontSize: 25.0)),
            LimitedBox(
              maxHeight: deviceHeight / 3.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.tagList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                    title: Text(
                        utf8.decode(
                            (widget.tagList[index]['name']).runes.toList()),
                        style: TextStyle(fontSize: 35.0)),
                    activeColor: Colors.black,
                    value: _selected[index],
                    onChanged: (bool? value) => setState(() {
                      _selected[index] = value!;
                    }),
                  );
                },
              ),
            ),
            SizedBox(width: double.infinity, height: 20.0),
            Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.only(right: 25.0),
              child: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>
                            TagFormPage(friendName: widget.friendName)),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Container(
//   alignment: Alignment.bottomRight,
//   width: deviceWidth / 3.0,
//   child: PopupMenuButton(
//     itemBuilder: (context) => [
//       PopupMenuItem(
//         child: Text('削除'),
//         onTap: () {},
//       ),
//     ],
//   ),
// ),
