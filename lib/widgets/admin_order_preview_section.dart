import 'package:flutter/material.dart';

class OrderPreviewSection extends StatelessWidget {
  final String sectionTitle;
  final String sectionDescription;
  const OrderPreviewSection({
    required this.sectionTitle,
    required this.sectionDescription,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).highlightColor,
        borderRadius: BorderRadius.circular(10)
      ),
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Text(
            sectionTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              sectionDescription,
            ),
          )
        ],
      ),
    );
  }
}
