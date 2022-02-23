import 'package:flutter/material.dart';

class PushButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onPressed;
  const PushButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
    );
  }
}
