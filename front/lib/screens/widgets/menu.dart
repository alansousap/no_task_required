import 'package:flutter/material.dart';

class Menu extends StatelessWidget implements PreferredSizeWidget {
  const Menu({super.key, this.home, this.newTask });

  final void Function()? home;
  final void Function()? newTask;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('No Task Required'),
      leading: IconButton(
        onPressed: home,
        icon: Icon(Icons.home)
      ),
      actions: [
        TextButton.icon(
          onPressed: newTask, 
          label: Text('New Task'),
          icon: Icon(Icons.add)
        ),
      ],
      actionsPadding: EdgeInsets.only(right: 35),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}