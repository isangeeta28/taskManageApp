import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskmanagementapp/services/auth_services.dart';
import 'package:taskmanagementapp/services/task_services.dart';
import 'package:taskmanagementapp/services/user_services.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/task_bloc.dart';
import 'bloc/user_bloc.dart';
import 'screens/login_screen.dart';
import 'screens/task_screen.dart';
import 'screens/task_form_screen.dart';
import 'screens/register_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(AuthService()),
        ),
        BlocProvider(
          create: (context) => TaskBloc(TaskService())..add(LoadTasks()),
        ),
        BlocProvider(
          create: (context) => UserBloc(UserService())..add(LoadUsers()),
        ),
      ],
      child: MaterialApp(
        title: 'Task Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/register',
        routes: {
          '/': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/tasks': (context) => TaskScreen(),
          '/task_form': (context) => TaskFormScreen(),
        },
      ),
    );
  }
}
