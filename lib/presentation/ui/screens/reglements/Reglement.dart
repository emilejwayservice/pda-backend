import 'package:flutter/material.dart';


class ReglementScreen extends StatefulWidget {

  ReglementScreen({Key? key}) : super(key: key);

  @override
  State<ReglementScreen> createState() => _ReglementScreenState();
}

class _ReglementScreenState extends State<ReglementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("reglement"),
      ),
    );
  }
}