import 'package:sample_moto_tour/tools/file_importer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 222,
        backgroundColor: AppColors.motoTourColor,
        splash: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Image.asset(
            'assets/logo.png',
          ),
        ),
        nextScreen: const MapScreen(),
      ),
    );
  }
}

// AuthService.auth.currentUser == null
            // ? const SignInScreen()
            // : const HomeScreen(),