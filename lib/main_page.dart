import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_diary/add_page.dart';
import 'package:path_provider/path_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({
    super.key,
  });

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  late Directory? directory;
  String filePath = '';
  dynamic myList = const Text("준비");

  @override
  void initState() {
    // TODO: implement initStat
    getPath().then((value) {
      showList();
    });
  }

  Future<void> getPath() async {
    directory = await getApplicationCacheDirectory();
    if (directory != null) {
      var fileName = 'diray.json';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        const SizedBox(
          height: 100,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                showList();
              },
              child: const Text("조회"),
            ),
            ElevatedButton(
              onPressed: () {
                deleteFile();
              },
              child: const Text("삭제"),
            ),
          ],
        ),
        Expanded(child: myList),
      ]),
      floatingActionButton: FloatingActionButton(
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
        child: const Icon(Icons.apple),
      ),
    );
  }
}
