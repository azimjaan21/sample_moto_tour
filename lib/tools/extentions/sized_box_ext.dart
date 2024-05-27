import 'package:sample_moto_tour/tools/file_importer.dart';

extension IntExtension on int {
  int validate({int value = 0}) {
    return this;
  }

  Widget get kH => SizedBox(
        height: toDouble(),
      );
  Widget get wH => SizedBox(
        width: toDouble(),
      );
}
