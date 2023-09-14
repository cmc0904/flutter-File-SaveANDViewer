import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class SavedFile extends StatefulWidget {
  const SavedFile({super.key});

  @override
  State<SavedFile> createState() => _SavedFileState();
}

class _SavedFileState extends State<SavedFile> {
  var directory;
  var myList;
  getFilePath() async {
    directory = getApplicationCacheDirectory();

    List<FileSystemEntity> files = directory.listSync();

    // 파일 목록을 출력한다.
    for (FileSystemEntity file in files) {
      print(file.path);
    }

    myList = FutureBuilder(
      future: directory,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var d = snapshot.data;
          if(directory.is())
          var dataList =  as List<dynamic>;
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
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          getFilePath();
        },
        child: const Text("ㅎㅇ"));
  }
}
