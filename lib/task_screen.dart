import 'dart:ui';

import 'package:flutter/material.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<String> tasks = ["Go Fishing", "Read Some Books", "Dancing"];
  List<String> completedTasks = [];
  String? currentTask;
  TextEditingController? _textEditingController;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Colors.lightBlueAccent,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.fromLTRB(30, 20, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: FloatingActionButton(
                          onPressed: () {
                            // ignore: avoid_print
                            print('List Notes button pressed');
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    padding: const EdgeInsets.all(40.0),
                                    child: ListView(children: [
                                      for (String item in completedTasks)
                                        Text(item)
                                    ]),
                                  );
                                });
                          },
                          child: const Icon(Icons.list, color: Colors.black87),
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const Expanded(
                        child: Text(
                          "Todoey",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 50,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${tasks.length} Tasks",
                          style: const TextStyle(
                            color: Color(0xFFDEDDDD),
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 6,
                child: Material(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20)),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: ListView(
                        children: [
                          for (String item in tasks)
                            ListItem(
                                item: item,
                                onCompleted: () {
                                  setState(() {
                                    completedTasks.add(item);
                                    tasks.remove(item);
                                  });
                                }),
                          // for (String item in tasks)
                          //   ListTile(
                          //     leading: Text(item),
                          //     trailing:
                          //         Checkbox(onChanged: (value) {}, value: false),
                          //   ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          dynamic val = await showModalBottomSheet(
              isDismissible: true,
              context: context,
              builder: (context) {
                return Container(
                  padding: const EdgeInsets.all(40),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Task',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            letterSpacing: 2,
                            color: Colors.lightBlueAccent),
                      ),
                      TextField(
                        autofocus: true,
                        controller: _textEditingController,
                        onSubmitted: (value) {
                          if (_textEditingController?.text != '') {
                            setState(() {
                              tasks.add(_textEditingController?.text ?? '');
                              _textEditingController?.text = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.lightBlueAccent),
                        ),
                        onPressed: () {
                          if (_textEditingController?.text != '') {
                            setState(() {
                              tasks.add(_textEditingController?.text ?? '');
                              _textEditingController?.text = '';
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });

          print(val);
          print('Add Note button pressed');
        },
        child: const Icon(Icons.add, color: Colors.white),
        backgroundColor: Colors.lightBlueAccent,
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  String? item;
  Function? onCompleted;
  ListItem({Key? key, required this.onCompleted, this.item}) : super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  bool checkBox = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.item ?? '',
            style: TextStyle(
              fontSize: 19,
              color: Colors.black87,
              decoration: checkBox ? TextDecoration.lineThrough : null,
            ),
          ),
          Checkbox(
              value: checkBox,
              onChanged: (value) async {
                setState(() {
                  checkBox = !checkBox;
                });
                await Future.delayed(const Duration(seconds: 1));

                if (checkBox) {
                  widget.onCompleted!();
                  dispose();
                }
              })
        ],
      ),
    );
  }
}
