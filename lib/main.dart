import 'package:firebase_core/firebase_core.dart';
import 'package:sample_moto_tour/auth/screens/login_screen.dart';
import 'package:sample_moto_tour/auth/services/auth.service.dart';
import 'package:sample_moto_tour/tools/file_importer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDAVJ-WawK1Z-hWG8gX-VI6K7QYML4gemY",
          authDomain: "moto-tour-9a3cf.firebaseapp.com",
          projectId: "moto-tour-9a3cf",
          storageBucket: "moto-tour-9a3cf.appspot.com",
          messagingSenderId: "362137786738",
          appId: "1:362137786738:web:9f066655f402c49fbf65eb",
          measurementId: "G-LQKYWY3RCM"));

  runApp( const MyApp());
}

class MyApp extends StatelessWidget {
   const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moto Tour',
      debugShowCheckedModeBanner: false,
      theme: myThemeData,
      home:    AuthService.auth.currentUser == null
            ?  LoginScreen()
            : const MapScreen(),
    );
  }
}
