import 'package:baghyar/styles.dart';
import 'package:flutter/material.dart';

class EmptyProcessButton extends StatelessWidget {
  final int type;
  final int id;

  const EmptyProcessButton({
    Key? key,
    required this.id,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 60,
        height: 60,
        child: ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              const CircleBorder(),
            ),
            backgroundColor: MaterialStateProperty.all(
                ((Theme.of(context).brightness == Brightness.light)
                    ? Styles.processButtonColorLight
                    : Styles.processButtonColorDark)),
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Theme.of(context).primaryColor;
              }
              return null;
            }),
          ),
          child: Image(
            image: Styles.button[id - 1][getId(type)],
          ),
        ),
      ),
    );
  }
}
