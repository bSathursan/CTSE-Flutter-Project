import 'package:flutter/material.dart';
import '../screens/user_management/user_welcome.dart';

class Layout extends StatelessWidget {
  final String context;
  final Widget? widget;

  const Layout({
    Key? key,
    required this.context,
    this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title: Center(child: Text(this.context),),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const UserWelcome()));
              },
              icon: const Icon(Icons.home)),
        ],
        backgroundColor: Color.fromARGB(255, 22, 17, 36),
      ),
      body: widget,
    );
  }
}
