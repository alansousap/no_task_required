import 'package:flutter/material.dart';
import 'package:no_task_required/model/task_model.dart';
import 'package:no_task_required/screens/home_page.dart';
import 'package:no_task_required/screens/widgets/menu.dart';
import 'package:no_task_required/view_model/task_view_model.dart';

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({super.key});

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage>{
  final TaskViewModel viewModel = TaskViewModel(TaskModel());
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _createTask(BuildContext context) async {
    String description = _textEditingController.text.trim();
    await viewModel.createTask(description);
    _textEditingController.clear();
    _focusNode.requestFocus();

    if (context.mounted && viewModel.message!="") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.message, style: TextStyle(fontWeight: FontWeight.bold)),
          behavior: .floating,
          backgroundColor: Colors.amber,
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu(
        home: () => Navigator.pushReplacement<void, void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const HomePage()
          ),
        ),
        newTask: null
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 15,
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Type a description for the task'
                  ),
                  controller: _textEditingController,
                  autofocus: true,
                  focusNode: _focusNode,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _createTask(context);
                  },
                  label: Text('Save'),
                  icon: Icon(Icons.save),
                ),
                if (viewModel.isLoading)
                  Center(
                    child: const CircularProgressIndicator(padding: EdgeInsets.only(top: 20), color: Colors.white),
                  ),
              ]
            )
          );
        }
      ),
    );
  }
}