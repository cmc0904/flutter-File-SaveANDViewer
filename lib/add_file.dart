import 'package:flutter/material.dart';
import 'package:flutter_application_diary/add_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:convert';
import 'dart:io';

class AddFilePage extends StatefulWidget {
  const AddFilePage({super.key});

  @override
  State<AddFilePage> createState() => _AddFilePageState();
}

class _AddFilePageState extends State<AddFilePage> {
  late Directory? directory;
  String filePath = '';
  dynamic myList = const Text("준비");
  var name = "";

  Future<void> getPath(name) async {
    directory = await getApplicationCacheDirectory();
    if (directory != null) {
      var fileName = '$name.json';
      filePath = '${directory!.path}/$fileName';
      print(filePath);
    }
  }

  Future<void> showList() async {
    try {
      var file = File(filePath);

      if (file.existsSync()) {
        setState(() {
          myList = FutureBuilder(
            future: file.readAsString(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var d = snapshot.data;
                var dataList = jsonDecode(d!) as List<dynamic>;
                if (dataList.isEmpty) {
                  return const Text("파일은 존재하지만 글은 없습니다.");
                }
                return ListView.separated(
                  itemBuilder: (context, index) {
                    var data = dataList[index] as Map<String, dynamic>;
                    print(data);
                    return ListTile(
                      title: Text(data['title']),
                      subtitle: Text(data['contents'],
                          style: const TextStyle(color: Colors.black)),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteContent(index);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: dataList.length,
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        });
      } else {
        setState(() {
          myList = const Text("결과가 없습니다.");
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteFile() async {
    try {
      var file = File(filePath);
      file.delete().then((value) => showList());
    } catch (e) {
      print(e);
    }
  }

  deleteContent(int index) async {
    try {
      var file = File(filePath);
      String data = await file.readAsString();
      var dataList = jsonDecode(data) as List<dynamic>;
      dataList.removeAt(index);
      await file
          .writeAsString(jsonEncode(dataList))
          .then((value) => showList());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  DateTime selectedDay = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      TableCalendar(
        locale: 'ko_KR',
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: DateTime.now(),
        onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
          // 선택된 날짜의 상태를 갱신합니다.
          setState(() {
            this.selectedDay = selectedDay;
            this.focusedDay = focusedDay;
            name = focusedDay.toString().split(" ")[0];
            getPath(name).then((value) => showList());
          });
        },
        selectedDayPredicate: (DateTime day) {
          return isSameDay(selectedDay, day);
        },
      ),
      Row(
        children: [
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    deleteFile();
                  },
                  child: const Text("파일 제거"),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddPage(filePath: filePath),
                      ),
                    );
                    if (result == 'OK') {
                      showList();
                    }
                  },
                  child: const Text("파일 쓰기"),
                ),
              ),
            ),
          ),
        ],
      ),
      Expanded(child: myList),
    ]);
  }
}
