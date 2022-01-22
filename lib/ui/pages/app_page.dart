import 'package:flutter/material.dart';

class AppPage extends StatelessWidget {
  final Widget child;

  const AppPage({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          child,
        ],
      ),
    );
  }
}