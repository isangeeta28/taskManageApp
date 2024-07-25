import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/task.dart';
import '../services/task_services.dart';

abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class CreateTask extends TaskEvent {
  final Task task;

  CreateTask(this.task);
}

class UpdateTask extends TaskEvent {
  final Task task;

  UpdateTask(this.task);
}

class DeleteTask extends TaskEvent {
  final int taskId;

  DeleteTask(this.taskId);
}


abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;

  TaskLoaded(this.tasks);
}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}


// Define the Task Bloc
class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskService taskService;

  TaskBloc(this.taskService) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<CreateTask>(_onCreateTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final tasks = await taskService.getTasks();
      emit(TaskLoaded(tasks));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(CreateTask event, Emitter<TaskState> emit) async {
    try {
      await taskService.createTask(event.task);
      add(LoadTasks());  // Reload tasks after creating one
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await taskService.updateTask(event.task);
      add(LoadTasks());  // Reload tasks after updating one
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await taskService.deleteTask(event.taskId);
      add(LoadTasks());  // Reload tasks after deleting one
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
