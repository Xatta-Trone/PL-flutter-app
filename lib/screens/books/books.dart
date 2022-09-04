import 'package:flutter/material.dart';

class Books extends StatelessWidget {
  const Books({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Container(
          child: const Text('Books'),
        ),
      ),
    );
  }
}
