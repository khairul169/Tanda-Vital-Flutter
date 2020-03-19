import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tanda_vital_flutter/pasien.dart';
import 'package:tanda_vital_flutter/view.dart';
import 'package:tanda_vital_flutter/utils.dart';
import 'package:tanda_vital_flutter/database.dart';

class PasienListItem extends StatelessWidget {
  final PasienData itemData;
  final Function onPress;
  final Function onRemove;

  PasienListItem({
    @required this.itemData,
    @required this.onPress,
    @required this.onRemove
  });

  @override
  Widget build(BuildContext context) {
    final genderIcon = (this.itemData.gender == 1) ? MdiIcons.genderFemale : MdiIcons.genderMale;
    return Card(
      child: ListTile(
        leading: Icon(Icons.person),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(Utils.genderPrefix(this.itemData)),
                Container(
                  margin: EdgeInsets.only(left: 4),
                  child: Icon(genderIcon, size: 18)
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 4),
              child: Text(this.itemData.regNumber + ' • ' + this.itemData.age.toString() + ' th', style: TextStyle(
                fontSize: 14
              )),
            ),
          ]
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => <PopupMenuEntry>[
            PopupMenuItem(
              value: 1,
              child: Row(
                children: <Widget>[
                  Icon(Icons.delete),
                  Container(child: Text("Hapus"), margin: EdgeInsets.only(left: 8)),
                ],
              ),
            )
          ],
          onSelected: (opt) {
            // Remove
            if (opt == 1) {
              onRemove();
            }
          },
        ),
        onTap: onPress,
      ),
    );
  }
}

class PasienListView extends StatelessWidget {
  final List<PasienData> items;
  final Function onRemove;

  PasienListView({@required this.items, @required this.onRemove});

  Widget _buildItem(context, index) {
    if (index >= items.length) {
      return null;
    }

    return PasienListItem(
      itemData: items[index],
      onPress: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => LihatPasien(data: items[index])));
      },
      onRemove: () {
        this.onRemove(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: _buildItem);
  }
}

class TambahPasien extends StatelessWidget {
  // Vars
  final _inputReg = TextEditingController();
  final _inputName = TextEditingController();
  final _inputAge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Pasien'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _inputReg,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                prefixIcon: Icon(Icons.event_note),
                hintText: "No. RM"
              )
            ),
            TextField(
              controller: _inputName,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                prefixIcon: Icon(Icons.person),
                hintText: "Nama Pasien",
              )
            ),
            TextField(
              controller: _inputAge,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 16.0),
                prefixIcon: Icon(Icons.view_agenda),
                hintText: "Umur"
              )
            ),
            Container(
              margin: EdgeInsets.only(top: 16),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context, PasienData(
                    regNumber: _inputReg.text,
                    name: _inputName.text,
                    age: int.tryParse(_inputAge.text) ?? 0,
                  ));
                },
                child: SizedBox(
                  width: double.maxFinite,
                  child: Center(child: Text("Tambah")),
                ),
              )
            )
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PasienData> items = [];
  Map<String, dynamic> user;

  void loadPasienList() async {
    Database db = await AppDB.db;
    List<Map<String, dynamic>> rows = await db.query('pasien', orderBy: 'nama ASC');

    List<PasienData> newItems = [];
    rows.forEach((row) {
      newItems.add(PasienData(
        id: row['id'],
        regNumber: row['reg'],
        name: row['nama'],
        age: row['umur'],
        gender: row['kelamin'],
      ));
    });

    setState(() {
      items = newItems;
    });
  }

  @override
  void initState() {
    super.initState();
    loadPasienList();
  }

  void onAddPressed() async {
    final result = await Navigator.push(context, MaterialPageRoute(
      builder: (context) => TambahPasien()
    ));

    if (result is PasienData) {
      var reg = result.regNumber;
      var nama = result.name;
      var umur = result.age;
      var kelamin = result.gender;

      Database db = await AppDB.db;
      await db.execute('''INSERT INTO pasien
        (reg, nama, umur, kelamin) VALUES
        ('$reg', '$nama', '$umur', '$kelamin')
      ''');

      loadPasienList();
    }
  }

  void onRemove(id) async {
    if (id < 0 || id >= items.length) {
      return;
    }

    int dbId = items[id].id;

    setState(() {
      items.removeAt(id);
    });

    Database db = await AppDB.db;
    await db.execute("DELETE FROM pasien WHERE id='$dbId'");

    loadPasienList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (context) => Icon(Icons.show_chart)),
        title: Text('Dokumentasi TTV'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){})
        ],
      ),
      body: Container(
        child: PasienListView(
          items: this.items,
          onRemove: this.onRemove,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddPressed,
      ),
    );
  }
}
