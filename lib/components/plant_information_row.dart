import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../size_config.dart';

class PlantInfoDetails extends StatelessWidget {
  const PlantInfoDetails(
      {Key key, @required this.description, @required this.plantInfo})
      : super(key: key);
  final String plantInfo;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            description,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Expanded(
              child: Text(
            plantInfo,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: getProportionateScreenHeight(context, 14),
              color: Colors.black,
            ),
          ))
        ],
      ),
    );
  }
}
