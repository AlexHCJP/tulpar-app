
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/models/dictionary/producer_model.dart';

class ProducerTile extends StatelessWidget {
  final ProducerModel producer;
  final VoidCallback? callback;

  const ProducerTile({super.key, required this.producer, this.callback});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(producer.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500))
          ),
          Divider(thickness: 1)
        ],
      ),
    );
  }

}