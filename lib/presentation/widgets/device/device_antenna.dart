import 'package:baghyar/styles.dart';
import 'package:flutter/material.dart';

class Antenna extends StatelessWidget {
  final int networkCoverage;

  const Antenna({Key? key, required this.networkCoverage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];
    for (int i = 0; i < 4; i++) {
      if (networkCoverage >= (4 - i)) {
        widgets.add(Container(
          width: 10,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            color: (Theme.of(context).brightness == Brightness.light)
                ? Styles.primaryColorLight
                : Styles.primaryColorDark,
          ),
        ));
        widgets.add(const SizedBox(width: 3));
      } else {
        widgets.add(Container(
          width: 10,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            color: (Theme.of(context).brightness == Brightness.light)
                ? Styles.antennaOffLight
                : Styles.antennaOffDark,
          ),
        ));
        widgets.add(const SizedBox(width: 3));
      }
    }
    widgets.add(
      SizedBox(
        width: 32,
        height: 32,
        child: Container(
          width: 16,
          height: 16,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/anten.png'),
            ),
          ),
        ),
      ),
    );
    return Row(
      children: widgets,
    );
  }
}
