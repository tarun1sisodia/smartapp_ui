import 'package:flutter/material.dart';
import 'di/injection_container.dart' as di;
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await di.init();

  runApp(const SmartAttendanceApp());
}
