import 'package:sample_moto_tour/tools/file_importer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moto Tour',
      debugShowCheckedModeBanner: false,
      theme: myThemeData,
      home: const SplashScreen(),
    );
  }
}
