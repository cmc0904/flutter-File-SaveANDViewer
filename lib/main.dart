import 'package:flutter/material.dart';
import 'package:flutter_application_diary/main_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  await initializeDateFormatting();

  runApp(const MainPage());
}
