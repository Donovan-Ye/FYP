import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _floatingIcon(Icon(Icons.hail)),
        _floatingIcon(Icon(Icons.radio)),
        _floatingIcon(Icon(Icons.wifi)),
        _floatingIcon(Icon(Icons.location_city)),
      ],
    );
  }

  Widget _floatingIcon(Icon icon) {
    return Container(
      height: 40,
      width: 40,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.white,
      ),
      child: icon,
    );
  }
}
