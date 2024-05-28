import 'package:sample_moto_tour/tools/extentions/sized_box_ext.dart';
import 'package:sample_moto_tour/tools/file_importer.dart';

class MapCustomBottomSheet extends StatelessWidget {
  final String startLocation;
  final String finalLocation;
  final String distance;
  final Function() onPressed;
  const MapCustomBottomSheet(
      {super.key,
      required this.startLocation,
      required this.finalLocation,
      required this.distance,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.07,
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
                    margin: const EdgeInsets.only(top: 3.0, bottom: 3.0),
                    height: 5,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // Location input and destination input
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // # distance #
                        Text(
                          '$distance км',
                          style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),

                        8.kH,
                        // Location input
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.white),
                            8.wH,
                            Expanded(
                              child: Text(
                                startLocation,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        16.kH,
                        // Destination input
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.yellow),
                            8.wH,
                            Expanded(
                              child: Text(
                                finalLocation,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, top: 12.0, bottom: 10.0),
                          child: ElevatedButton(
                            onPressed: onPressed,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellowAccent),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Старт',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16),
                                ),
                                5.wH,
                                const Icon(Icons.route, color: Colors.black),
                              ],
                            ),
                          ),
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
