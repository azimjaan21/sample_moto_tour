import 'package:sample_moto_tour/tools/extentions/sized_box_ext.dart';
import 'package:sample_moto_tour/tools/file_importer.dart';

class MapCustomBottomSheet extends StatelessWidget {
  final String startLocation;
  final String finalLocation;
  final String distance;
  final Function() onPressed;
  final Function(int index) onSelected;
  final bool startSelected;
  const MapCustomBottomSheet(
      {super.key,
      required this.startLocation,
      required this.finalLocation,
      required this.distance,
      required this.onPressed,
      required this.onSelected,
      required this.startSelected});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      minChildSize: 0.05,
      maxChildSize: 0.45,
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
            padding: const EdgeInsets.only(top: 20),
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
                          distance,
                          style: const TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),

                        8.kH,
                        // Location input
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: startSelected
                                    ? Colors.amber
                                    : Colors.white),
                            8.wH,
                            Expanded(
                              child: InkWell(
                                autofocus: true,
                                onTap: () {
                                  onSelected(0);
                                },
                                child: Text(
                                  startLocation,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            if (startSelected)
                              const Icon(Icons.api_sharp,
                                  color: Color.fromARGB(255, 26, 255, 0))
                          ],
                        ),
                        16.kH,
                        const Divider(),
                        16.kH,
                        // Destination input
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                color: !startSelected
                                    ? Colors.amber
                                    : Colors.white),
                            8.wH,
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  onSelected(1);
                                },
                                child: Text(
                                  finalLocation,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            if (!startSelected)
                              const Icon(Icons.api_sharp, color: Color.fromARGB(255, 26, 255, 0))
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
