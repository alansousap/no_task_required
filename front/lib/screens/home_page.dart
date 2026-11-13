import 'package:flutter/material.dart';
import 'package:no_task_required/screens/widgets/menu.dart';
import 'package:no_task_required/screens/widgets/message.dart';

import '../data/task.dart';
import '../model/task_model.dart';
import '../view_model/task_view_model.dart';
import 'new_task_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Menu(
        home: null,
        newTask: () => Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const NewTaskPage(),
          ),
        ),
      ),
      body: TaskSelection(),
    );
  }
}

class TaskSelection extends StatefulWidget {
  const TaskSelection({super.key});

  @override
  State<TaskSelection> createState() => _TaskSelectionState();
}

class _TaskSelectionState extends State<TaskSelection> {
  final TaskViewModel viewModel = TaskViewModel(TaskModel());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime inicialDate = DateTime.now();
    DateTime lastDate = DateTime((inicialDate.year) + 2);
    viewModel.getTaskList(inicialDate);

    return Column(
      children: [
        CalendarDatePicker(initialDate: inicialDate, firstDate: DateTime(2026), lastDate: lastDate, onDateChanged: (sd) {
          viewModel.getTaskList(sd);
        }),
        Expanded(
          child: ListenableBuilder(
            listenable: viewModel,
            builder: (context, child) {
              if (viewModel.isLoading) {
                return Center(child: const CircularProgressIndicator(padding: EdgeInsets.only(top: 20), color: Colors.white));
              }
              if (viewModel.message!="") {
                return Message(viewModel.message, Icons.error);
              }
              return TaskListView(listsOfTasks: viewModel.listsOfTasks, updateTaskStatus: viewModel.updateTaskStatus);
            }
          )
        )
      ],
    );
  }

}

class TaskListView extends StatefulWidget {
  const TaskListView({required this.listsOfTasks, required this.updateTaskStatus, super.key});

  final List<Task> listsOfTasks;
  final Function updateTaskStatus;

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  AnimationStatus _animationStatus = .dismissed;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(10),
      itemCount: widget.listsOfTasks.length,
      itemBuilder: (BuildContext context, int index) {
        Task task = widget.listsOfTasks[index];
        bool iniciated = task.iniciated;
        bool completed = task.completed;
        //
        Color taskColor = Colors.white;
        IconData taskIcon = Icons.tag_sharp;
        if (completed) {
          taskColor = Colors.green;
          taskIcon = Icons.task_alt_sharp;
        }
        if (!completed && iniciated) {
          taskColor = Colors.amber;
          taskIcon = Icons.push_pin_sharp;
        }
        //
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: taskColor),
          ),
          child: Row(
            spacing: 5,
            children: [
              Icon(taskIcon, color: taskColor),
              Expanded(child: Text(task.description)),
              MenuAnchor(
                animated: true,
                onAnimationStatusChanged: (AnimationStatus status) {
                  _animationStatus = status;
                },
                menuChildren: [
                  MenuItemButton(
                    child: Text('Idle'),
                    onPressed: () => widget.updateTaskStatus(task.id, false, false),
                  ),
                  MenuItemButton(
                    child: Text('Iniciate'),
                    onPressed: () => widget.updateTaskStatus(task.id, true, false),
                  ),
                  MenuItemButton(
                    child: Text('Complete'),
                    onPressed: () => widget.updateTaskStatus(task.id, false, true),
                  )
                ],
                builder: (BuildContext context, MenuController controller, Widget? child) {
                  return Padding(
                    padding: EdgeInsetsGeometry.directional(end: 20),
                    child: IconButton(
                      onPressed: () {
                        if (_animationStatus.isForwardOrCompleted) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      icon: Icon(Icons.more_horiz),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Padding(padding: EdgeInsets.all(5));
      },
    );
  }

}