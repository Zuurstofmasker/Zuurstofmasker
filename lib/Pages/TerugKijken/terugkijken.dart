import 'package:flutter/material.dart';
import 'package:zuurstofmasker/Helpers/sessionHelpers.dart';
import 'package:zuurstofmasker/Models/sessionDetail.dart';
import 'package:zuurstofmasker/Widgets/nav.dart';

class TerugKijken extends StatefulWidget {
  const TerugKijken({super.key});

  @override
  State<TerugKijken> createState() => _terugkijkenState();
}

List<SessionDetail> sessions = [];

class _terugkijkenState extends State<TerugKijken> {
  @override
  void initState() {
    super.initState();
    loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Nav(
      child: SingleChildScrollView(
        child: Column(
          children: getTerugKijkItems(context),
        ),
      ),
    );
  }
}

List<Widget> getTerugKijkItems(BuildContext context) {
  List<Widget> items = [];
  for (SessionDetail item in sessions) {
    items.add(Text("${item.id} ${item.nameMother}"));
  }
  return items;
}

void loadSessions() async {
  sessions = await getSessions();
}
