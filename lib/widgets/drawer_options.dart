import 'package:flutter/material.dart';
import 'package:sample_moto_tour/screens/rides_screen.dart';
import 'package:sample_moto_tour/tools/extentions/sized_box_ext.dart';

class DrawerOptions extends StatelessWidget {
  const DrawerOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.35,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/background.jpg',
                      ),
                      fit: BoxFit.cover),
                ),
              ),
              Container(
                height: MediaQuery.sizeOf(context).height * 0.35,
                width: double.infinity,
                color: Colors.black45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 50,
                      child: Image.asset(
                        'assets/avatar.png',
                      ),
                    ),
                    8.kH,
                    const Expanded(
                        child: Text(
                      'Abdul Sharif',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )),
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.motorcycle_outlined),
            title: const Text('Rides'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RidesScreen(),
                  ));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Account'),
            onTap: () {
              // Handle drawer item tap
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color(0xFFFF0505),
            ),
            title: const Text(
              'Sign out',
              style: TextStyle(
                color: Color(0xFFFF0505),
              ),
            ),
            onTap: () {
              // Handle drawer item tap
            },
          ),
        ],
      ),
    );
  }
}
