import 'dart:async';
import 'package:expandable/expandable.dart';

import 'package:flutter/material.dart';
import 'package:flutter_app/models/laundry_session.dart';
import 'package:flutter_app/pages/new_session.dart';
import 'package:flutter_app/pages/plot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/service/api.dart';

class Laundry extends StatefulWidget {
  const Laundry({super.key});

  @override
  _LaundryState createState() => _LaundryState();
}

class _LaundryState extends State<Laundry> {
  late Future<List<LaundrySession>> futureLaundrySessions;
  late Timer timer;

  Future<List<LaundrySession>> fetchSessions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    return getLaundrySession(token);
  }

  void deleteSession(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    deleteLaundrySession(token, id);
  }

  void stopSession(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token").toString();
    var result = await endLaundrySession(token, id);
    if (result != null) refresh();
  }

  void _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void startSession() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewSession()),
    );
  }

  @override
  void initState() {
    super.initState();
    futureLaundrySessions = fetchSessions();
    timer = Timer.periodic(const Duration(minutes: 5), (Timer t) => refresh());
  }

  Future refresh() async {
    if (!mounted) return;
    setState(() {
      futureLaundrySessions = fetchSessions();
    });
  }

  Widget sessionHeader(data, index, {active = false}) {
    return Row(children: [
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Color(int.parse("0xff${data[index].color}")),
            shape: BoxShape.circle),
        child: Text(
          data[index].icon,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      Text(data[index].name,
          style: const TextStyle(fontSize: 20, color: Colors.blue)),
      const SizedBox(
        width: 25,
      ),
      if (active) ...[
        Text(
          'ACTIVE',
          style: TextStyle(
              fontSize: 13,
              color: Colors.white,
              background: Paint()
                ..strokeWidth = 15.0
                ..color = Colors.blue
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.round),
        )
      ]
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Laundries"),
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          FloatingActionButton(
            heroTag: "addSessionBtn",
            onPressed: startSession,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add_rounded),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            heroTag: "logoutBtn",
            onPressed: _handleLogout,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.logout_rounded),
          ),
        ]),
        body: RefreshIndicator(
          onRefresh: refresh,
          child: Center(
              child: FutureBuilder<List<LaundrySession>>(
                  future: futureLaundrySessions,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<LaundrySession> data = snapshot.data!;
                      return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (_) {
                                setState(() {
                                  deleteSession(data[index].id);
                                  data.removeAt(index);
                                });
                              },
                              background: Container(
                                color: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                alignment: Alignment.centerRight,
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              child: ExpandablePanel(
                                  theme: const ExpandableThemeData(
                                    headerAlignment:
                                        ExpandablePanelHeaderAlignment.center,
                                    tapHeaderToExpand: true,
                                    hasIcon: true,
                                  ),
                                  // header: Text(data[index].name),
                                  header: sessionHeader(data, index,
                                      active: data[index].finishedAt == null),
                                  collapsed: Container(),
                                  expanded: Column(children: [
                                    Plot(
                                      id: data[index].id,
                                    ),
                                    if (data[index].finishedAt == null) ...[
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15),
                                        alignment: Alignment.center,
                                        child: ElevatedButton(
                                          onPressed: () =>
                                              stopSession(data[index].id),
                                          child: const Text(
                                            'STOP SESSION',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18),
                                          ),
                                        ),
                                      )
                                    ]
                                  ])),
                            );
                            //}
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    // By default show a loading spinner.
                    return const CircularProgressIndicator();
                  })),
        ));
  }
}
