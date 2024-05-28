import 'package:flutter/material.dart';
import 'package:sample_moto_tour/widgets/custom_sliverAppbar.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          const CustomSliverAppBar(
              title: 'Rides', imagePath: 'assets/background.jpg'),
        ];
      },
      body: const SingleChildScrollView(
        child: Column(
          children: [
            Card(
              child: ListTile(),
            ),
          ],
        ),
      ),
    ));
  }
}
