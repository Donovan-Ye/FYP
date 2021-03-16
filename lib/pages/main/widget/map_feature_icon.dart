import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MapFeatureIcon extends StatelessWidget {
  final String name;
  final Color color;
  final IconData icon;
  final BuildContext context;
  final Function tap;

  const MapFeatureIcon(
      {Key key, this.name, this.color, this.icon, this.context, this.tap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 65,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(50), color: color),
      child: Column(
        children: [
          GestureDetector(
            onTap: tap,
            child: new Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          Text(
            name,
            style: TextStyle(color: Colors.white, fontSize: 12),
          )
        ],
      ),
    );
  }
}
