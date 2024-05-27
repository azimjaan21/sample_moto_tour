import 'package:sample_moto_tour/tools/file_importer.dart';

class MapCustomBottomSheet extends StatelessWidget {
  const MapCustomBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.25,
      minChildSize: 0.25,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.motoTourColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              Column(
                children: [
                  // Top bar to indicate draggable
                  Container(
                    margin: const EdgeInsets.only(top: 1.0, bottom: 1.0),
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[600],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Location input and destination input
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Location input
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.yellow),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '144 Broughton Ave, Broomfield',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        // Destination input
                        Row(
                          children: [
                            Icon(Icons.location_on, color: Colors.yellow),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                '144 Broughton Ave, Broomfield',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
