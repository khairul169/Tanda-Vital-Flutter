import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tanda_vital_flutter/pasien.dart';
import 'package:tanda_vital_flutter/chart.dart';
import 'package:tanda_vital_flutter/utils.dart';

class Overview extends StatelessWidget {
  final PasienData pasien;

  Overview({this.pasien});

  Widget dataPasien() => Card(
    child: Container(
      padding: EdgeInsets.only(top: 16, right: 16, bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Icon(MdiIcons.accountCircle, size: 48)
          ),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('No. RM', style: TextStyle(fontSize: 12, color: Colors.black45)),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(pasien.regNumber)
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text('Nama', style: TextStyle(fontSize: 12, color: Colors.black45))
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(pasien.name)
                ),
              ],
            )
          ),
          Expanded(
            flex: 9,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Umur', style: TextStyle(fontSize: 12, color: Colors.black45)),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(pasien.age.toString() + ' th')
                ),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  child: Text('Jenis Kelamin', style: TextStyle(fontSize: 12, color: Colors.black45))
                ),
                Container(
                  margin: EdgeInsets.only(top: 2),
                  child: Text(pasien.gender == 1 ? 'Perempuan' : 'Laki-laki')
                ),
              ],
            )
          ),
        ],
      ),
    )
  );

  Widget chartTD() => Card(
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(8),
      child: TimeChart(
        title: "Tekanan Darah",
        leftText: "mmHg",
        series: <ChartSeries>[
          ChartSeries(
            id: 'Sistolik',
            color: Colors.red.shade900,
            values: <ChartValue>[
              ChartValue(0, 110),
              ChartValue(1, 120),
              ChartValue(2, 180),
            ],
          ),
          ChartSeries(
            id: 'Diastolik',
            color: Colors.red.shade300,
            values: <ChartValue>[
              ChartValue(0, 70),
              ChartValue(1, 80),
              ChartValue(2, 100),
            ],
          ),
        ],
      ),
    ),
  );

  Widget chartNadi(List<ChartValue> values) => Card(
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(8),
      child: TimeChart(
        title: "Denyut Nadi",
        leftText: "x/menit",
        series: <ChartSeries>[
          ChartSeries(
            id: 'HR',
            color: Colors.green,
            values: values,
          ),
        ],
      ),
    ),
  );

  Widget buildChart({
    title, leftText, series, timeSpan
  }) => Card(
    child: Container(
      width: double.maxFinite,
      padding: EdgeInsets.all(8),
      child: TimeChart(
        title: title,
        leftText: leftText,
        series: series,
        timeSpan: timeSpan,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final chartValues = [
      {
        'waktu': 14,
        'sistol': 110,
        'diastol': 70,
        'nadi': 88,
        'rr': 21
      },
      {
        'waktu': 15,
        'sistol': 100,
        'diastol': 60,
        'nadi': 82,
        'rr': 20
      },
      {
        'waktu': 16,
        'sistol': 120,
        'diastol': 70,
        'nadi': 86,
        'rr': 18
      },
      {
        'waktu': 18,
        'sistol': 110,
        'diastol': 60,
        'nadi': 72,
        'rr': 18
      },
    ];

    List<ChartValue> sistolik = [];
    List<ChartValue> diastolik = [];
    List<ChartValue> nadi = [];
    List<ChartValue> rr = [];
    int timeSpan = 0;

    chartValues.asMap().forEach((index, item) {
      if (index == 0) {
        timeSpan = item['waktu'];
      }
      sistolik.add(ChartValue(item['waktu'] - timeSpan, item['sistol']));
      diastolik.add(ChartValue(item['waktu'] - timeSpan, item['diastol']));
      nadi.add(ChartValue(item['waktu'] - timeSpan, item['nadi']));
      rr.add(ChartValue(item['waktu'] - timeSpan, item['rr']));
    });

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dataPasien(),

          // Chart tekanan darah
          buildChart(
            title: "Tekanan Darah",
            leftText: "mmHg",
            timeSpan: timeSpan,
            series: <ChartSeries>[
              ChartSeries(
                id: 'Sistolik',
                color: Colors.red.shade900,
                values: sistolik,
              ),
              ChartSeries(
                id: 'Diastolik',
                color: Colors.red.shade300,
                values: diastolik,
              ),
            ],
          ),

          // Chart denyut nadi
          buildChart(
            title: "Denyut Nadi",
            leftText: "x/menit",
            timeSpan: timeSpan,
            series: <ChartSeries>[
              ChartSeries(
                color: Colors.green,
                values: nadi,
              ),
            ],
          ),

          // Chart pernafasan
          buildChart(
            title: "Pernafasan",
            leftText: "x/menit",
            timeSpan: timeSpan,
            series: <ChartSeries>[
              ChartSeries(
                color: Colors.blue,
                values: rr,
              ),
            ],
          ),
        ],
      )
    );
  }
}

class LihatPasien extends StatefulWidget {
  final PasienData data;

  LihatPasien({@required this.data});

  @override
  _LihatPasienState createState() => _LihatPasienState();
}

class _LihatPasienState extends State<LihatPasien> with SingleTickerProviderStateMixin {
  TabController _tabController;

  final List<Tab> _tabs = <Tab>[
    Tab(text: 'Ikhtisar'),
    Tab(text: 'Riwayat'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> buildPages() {
    final data = this.widget.data;
    return <Widget>[
      Overview(pasien: data),
      Text('Haha'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Utils.genderPrefix(this.widget.data)),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: buildPages(),
      ),
    );
  }
}