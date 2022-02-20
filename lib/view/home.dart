import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoooo/DB&state_managment/DB.dart';
import 'package:todoooo/view/widgets/reusable_textForm.dart';

class Notes extends StatefulWidget {
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  TextEditingController textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TaskLogic _taskLogic = TaskLogic();

  DateTime selectedValue = DateTime.now();
  DatePickerController _controller = DatePickerController();
  String title = "";

  Future<void> prepareData() async {
    var mvcProvider = Provider.of<TaskLogic>(context, listen: false);
    await mvcProvider.getData();
  }

  @override
  void initState() {
    prepareData();
    // TODO: implement initState
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SafeArea(
        child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Stack(
                            children: <Widget>[
                              Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    ReusableTextForm(
                                      txt1: "task title",
                                      onChanged: (val) {
                                        title = val;
                                      },
                                    ),
                                    Text("choose date :"),
                                    Container(
                                      child: DatePicker(
                                        DateTime.now(),
                                        width: 60,
                                        height: 80,
                                        controller: _controller,
                                        initialSelectedDate: DateTime.now(),
                                        selectionColor: Colors.black,
                                        selectedTextColor: Colors.white,
                                        onDateChange: (date) {
                                          selectedValue = date;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Submit",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            var date = DateTime.now();
                                            var dateNew =
                                                DateFormat("dd/MM/yyyy")
                                                    .format(date);
                                            await _taskLogic.insertDB(
                                                dateNew, title);

                                            var taskProvider =
                                                Provider.of<TaskLogic>(context,
                                                    listen: false);
                                            print(taskProvider.getData());

                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              backgroundColor: Colors.green,
              child: const Icon(
                Icons.add_alert,
                size: 30,
              ),
            ),
            appBar: AppBar(
              centerTitle: true,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30))),
              backgroundColor: Color(0xff21325E),
              title: Text(
                "To-Do",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            body: Consumer<TaskLogic>(builder: (context, myprovider, child) {
              return ListView.builder(
                  itemCount: myprovider.list.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      onDismissed: (dir) {
                        myprovider.deleteOneRow(myprovider.list[index]["id"]);
                      },
                      key: Key(UniqueKey().toString()),
                      background: Container(
                        child: Icon(
                          Icons.delete,
                          size: 40,
                        ),
                        color: Colors.red,
                      ),
                      child: Card(
                        elevation: 10,
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: ExpansionTile(
                          collapsedBackgroundColor: Colors.white,
                          leading: Icon(Icons.date_range),
                          title: Text(myprovider.list[index]["date"]),
                          children: [
                            Text("slide to delete tasks"),
                            Row(
                              children: [
                                TextButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text(
                                                "Save",
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black),
                                              ),
                                              content: TextFormField(
                                                controller:
                                                    textEditingController,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "${myprovider.list[index]["note"]}"),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      myprovider.update(
                                                          myprovider.list[index]
                                                              ["date"],
                                                          textEditingController
                                                              .text,
                                                          myprovider.list[index]
                                                              ["id"]);
                                                      textEditingController
                                                          .clear();

                                                      var taskProvider =
                                                          Provider.of<
                                                                  TaskLogic>(
                                                              context,
                                                              listen: false);
                                                      taskProvider.getData();
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Notes()));
                                                    },
                                                    child: Text(
                                                      "Save",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black),
                                                    )),
                                              ],
                                            );
                                          });
                                    },
                                    child: CircleAvatar(
                                      child: Icon(
                                        Icons.update,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.blueAccent,
                                    )),
                                Text(
                                  myprovider.list[index]["note"],
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            })),
      ),
    );
  }
}
