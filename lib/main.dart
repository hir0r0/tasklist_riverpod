import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/task.dart';
import 'models/tasks.dart';
import 'view/taskdetail.dart';
import 'view/taskitem.dart';

void main() => runApp(const ProviderScope(child: MyApp()));

final tasksProvider = ChangeNotifierProvider<Tasks>(
  (ref) => Tasks(),
);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/detail': (context) => TaskDetail(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Task? task;

    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final tasks = watch(tasksProvider);
          return SafeArea(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              itemCount: tasks.tasklist.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  child: GestureDetector(
                    child: TaskItem(task: tasks.tasklist[index]),
                    onTap: () async => {
                      task = await Navigator.of(context).pushNamed('/detail',
                          arguments: tasks.tasklist[index]) as Task?,
                      if (task != null)
                        {
                          tasks.update(task!),
                        }
                    },
                  ),
                  onDismissed: (direction) {
                    tasks.delete(tasks.tasklist[index]);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {
          task = await Navigator.of(context)
              .pushNamed('/detail', arguments: Task(0, '', '')) as Task?,
          if (task != null)
            {
              context.read(tasksProvider).add(task!),
            }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
