import 'package:sample_moto_tour/tools/file_importer.dart';

class DrawerOptions extends StatelessWidget {
  DrawerOptions({super.key});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/background.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                color: Colors.black45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Stack(
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.amber,
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                    8.kH,
                    Expanded(
                      child: Text(
                        AuthService.auth.currentUser!.email.toString(),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Главный экран'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.motorcycle_outlined),
            title: const Text('Мотопоездки'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RidesScreen(),
                ),
              );
            },
          ),
          // const Divider(),
          // ListTile(
          //   leading: const Icon(Icons.person),
          //   title: const Text('Аккаунт'),
          //   onTap: () {
          //     // Handle drawer item tap
          //   },
          // ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color(0xFFFF0505),
            ),
            title: const Text(
              'Выход',
              style: TextStyle(
                color: Color(0xFFFF0505),
              ),
            ),
            onTap: () {
              _authService.signOut().then((_) {
                // Navigate to the login screen after sign out
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
              }).catchError((error) {
                // Handle sign-out errors
                print('Error signing out: $error');
                // Show snackbar or dialog to inform the user
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Failed to sign out. Please try again.'),
                ));
              });
            },
          ),
        ],
      ),
    );
  }
}
