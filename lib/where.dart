import 'package:flutter/material.dart';
import 'package:where/test_map.dart';

class Where extends StatelessWidget {
  const Where({super.key}) ;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TestMap(),
    );
  }
}
