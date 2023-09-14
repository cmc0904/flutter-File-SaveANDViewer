import 'package:flutter/material.dart';
import 'package:flutter_application_diary/add_file.dart';
import 'package:flutter_application_diary/saved_file.dart';

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
  var data = [const AddFilePage(), const SavedFile()];
  var page;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            setState(() {
              page = data[value];
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.save), label: "파일 저장"),
            BottomNavigationBarItem(
                icon: Icon(Icons.file_copy), label: "저장된 파일"),
          ]),
      appBar: AppBar(
        title: const Text("파일 저장"),
        centerTitle: true,
      ),
      body: page,
    );
  }
}
