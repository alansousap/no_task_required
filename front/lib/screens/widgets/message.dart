import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message(this.text, this.icon, {super.key});

  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Row(
        spacing: 5,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          Text(text,
            style: TextStyle(
              fontSize: 25
            ),
          ),
        ],
      ),
    );
  }
}