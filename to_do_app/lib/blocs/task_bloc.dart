import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/task.dart';
import '../services/task_service.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;

  TaskBloc(this.taskService) : super(TaskLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    try {
      final tasks = await taskService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (_) {
      emit(TaskError());
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await taskService.addTask(event.task);
      add(LoadTasks());
    } catch (_) {
      emit(TaskError());
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskService.updateTask(event.task);
      add(LoadTasks());
    } catch (_) {
      emit(TaskError());
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskService.deleteTask(event.task);
      add(LoadTasks());
    } catch (_) {
      emit(TaskError());
    }
  }
}

part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;

  const AddTask(this.task);

  @override
  List<Object> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;

  const UpdateTask(this.task);

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  final Task task;

  const DeleteTask(this.task);

  @override
  List<Object> get props => [task];
}
