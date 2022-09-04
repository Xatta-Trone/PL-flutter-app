import 'package:flutter/material.dart';

class Departments extends StatelessWidget {
  const Departments({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          child: const Text('Departments'),
        ),
      ),
    );
  }
}
