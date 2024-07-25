import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/task_bloc.dart';
import '../bloc/user_bloc.dart';
import '../models/task.dart';
import '../models/user.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;

  TaskFormScreen({this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String? _priority;
  String? _status;
  User? _assignedUser;

  @override
  void initState() {
    super.initState();
   // if (widget.task != null) {
      _titleController.text = widget.task?.title ?? "";
      print("==========>>>>>> widget.task!.title daat === ${widget.task?.title??""}");
      _descriptionController.text = widget.task?.description ?? "";
      _dueDate = widget.task?.dueDate;
      _priority = widget.task?.priority;
      _status = widget.task?.status;
      _assignedUser = widget.task?.assignedUser;
    //}
    context.read<UserBloc>().add(LoadUsers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dueDate == null
                            ? 'No date chosen!'
                            : 'Due Date: ${_dueDate!.toLocal()}',
                      ),
                    ),
                    TextButton(
                      child: Text('Choose Date'),
                      onPressed: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: _dueDate ?? DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            _dueDate = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: _priority,
                  decoration: InputDecoration(labelText: 'Priority'),
                  items: ['High', 'Medium', 'Low']
                      .map((priority) => DropdownMenuItem(
                    value: priority,
                    child: Text(priority),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _priority = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a priority';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _status,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: ['To-Do', 'In Progress', 'Done']
                      .map((status) => DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _status = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a status';
                    }
                    return null;
                  },
                ),
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserLoading) {
                      return CircularProgressIndicator();
                    } else if (state is UserLoaded) {
                      return DropdownButtonFormField<User>(
                        value: _assignedUser,
                        decoration: InputDecoration(labelText: 'Assigned User'),
                        items: state.users
                            .map((user) => DropdownMenuItem(
                          value: user,
                          child: Text(user.email ?? ""),
                        ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _assignedUser = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a user';
                          }
                          return null;
                        },
                      );
                    } else if (state is UserError) {
                      return Text('Failed to load users');
                    }
                    return Container();
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(
                        id: widget.task?.id ?? 0,
                        title: _titleController.text,
                        description: _descriptionController.text,
                        dueDate: _dueDate ?? DateTime.now(),
                        priority: _priority ?? 'Low',
                        status: _status ?? 'To-Do',
                        assignedUser: _assignedUser,
                      );
                      if (widget.task == null) {
                        // Create a new task
                        context.read<TaskBloc>().add(CreateTask(task));
                      } else {
                        // Update the existing task
                        context.read<TaskBloc>().add(UpdateTask(task));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.task == null ? 'Create' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
