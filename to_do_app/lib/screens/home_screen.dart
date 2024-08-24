import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/task_bloc.dart';
import '../models/task.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'New Task',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      final task = Task(title: _controller.text);
                      context.read<TaskBloc>().add(AddTask(task));
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is TaskLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is TaskLoaded) {
                  return ListView.builder(
                    itemCount: state.tasks.length,
                    itemBuilder: (context, index) {
                      final task = state.tasks[index];
                      return TaskTile(
                        task: task,
                        onChanged: (isChecked) {
                          task.isCompleted = isChecked!;
                          context.read<TaskBloc>().add(UpdateTask(task));
                        },
                        onDelete: () {
                          context.read<TaskBloc>().add(DeleteTask(task));
                        },
                      );
                    },
                  );
                } else {
                  return Center(child: Text('Something went wrong!'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
