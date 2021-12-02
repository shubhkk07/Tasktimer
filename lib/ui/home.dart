import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todolocal/constants/colors/colors.dart';
import 'package:todolocal/model/task.dart';
import 'package:todolocal/ui/timer.dart';
import 'package:todolocal/utils/database_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Map<String, dynamic>>> fetchTasks(context) async {
    final data =
        await Provider.of<DatabaseHelper>(context, listen: false).fetchData();
    return data;
  }

  Widget indicator(Color color, String text) {
    return Row(children: [
      Container(
        height: 10,
        width: 10,
        color: color,
      ),
      const SizedBox(width: 8),
      Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleTextStyle: Theme.of(context).textTheme.headline1,
          title: const Text('TO-DOs'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/addNote')
                .then((value) => setState(() {
                      fetchTasks(context);
                    }));
          },
          child: const Icon(Icons.add),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.all(15),
          child: Column(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  indicator(ConstantColors.completed, 'Completed'),
                  indicator(ConstantColors.todo, 'To-Do'),
                  indicator(ConstantColors.inProgress, 'In-Progress'),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                  future: fetchTasks(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      TaskList taskList = TaskList.fromJson(snapshot.data!);
                      return NotificationListener<
                          OverscrollIndicatorNotification>(
                        onNotification: (notification) {
                          notification.disallowGlow();
                          return true;
                        },
                        child: snapshot.data!.isNotEmpty
                            ? ListView.builder(
                                itemCount: taskList.tasks!.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0),
                                    child: Material(
                                      color:
                                          taskList.tasks![index].isCompleted ==
                                                  1
                                              ? ConstantColors.completed
                                              : (taskList.tasks![index]
                                                          .isCompleted ==
                                                      2)
                                                  ? ConstantColors.inProgress
                                                  : ConstantColors.todo,
                                      borderRadius: BorderRadius.circular(10),
                                      elevation: 1,
                                      child: ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                          minLeadingWidth: 15,
                                          dense: true,
                                          isThreeLine: true,
                                          leading: Text(
                                            (index + 1).toString(),
                                            style: textStyle.headline2,
                                          ),
                                          title: Text(
                                            taskList.tasks![index].title!
                                                .toUpperCase(),
                                            style: textStyle.headline2,
                                          ),
                                          subtitle: Text(
                                            taskList.tasks![index].description!,
                                            style: textStyle.bodyText1,
                                          ),
                                          trailing: TaskTimer(
                                            taskDuration: taskList
                                                .tasks![index].taskDuration!,
                                            status: taskList
                                                .tasks![index].isCompleted!,
                                            onTimerEnd: (int status) async {
                                              await Provider.of<DatabaseHelper>(
                                                      context,
                                                      listen: false)
                                                  .updateStatus(
                                                      taskList
                                                          .tasks![index].id!,
                                                      status)
                                                  .then((value) => setState(() {
                                                        fetchTasks(context);
                                                      }));
                                            },
                                          )),
                                    ),
                                  );
                                },
                              )
                            : const Center(
                                child: Text(
                                  'No Tasks! Please add some tasks',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                      );
                    } else if (snapshot.data != null &&
                        snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Tasks'));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ),
          ]),
        ));
  }
}
