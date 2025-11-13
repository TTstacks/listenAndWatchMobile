import 'package:flutter/material.dart';
import 'package:listenandwatch/screens/main_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hjlmhexenfqtagfwniot.supabase.co',
    anonKey: 'sb_publishable_IEJY7demzAFxi8-v7CjuBg_L978NZZn'
  );

  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Directionality(textDirection: TextDirection.ltr, child: BucketVideoListPage()));
  }
}
