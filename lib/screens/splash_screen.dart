import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('Showing splash screen ****************');
    return const Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}
