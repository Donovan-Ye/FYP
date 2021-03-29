import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingIcons extends StatefulWidget {
  final Function icon1Tap;
  final Function icon2Tap;
  final Function icon3Tap;
  final Function icon4Tap;

  const FloatingIcons(
      {Key key, this.icon1Tap, this.icon2Tap, this.icon3Tap, this.icon4Tap})
      : super(key: key);

  @override
  _FloatingIcons createState() => _FloatingIcons();
}

class _FloatingIcons extends State<FloatingIcons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _floatingIcon(Icon(Icons.hail), tap: widget.icon1Tap),
        _floatingIcon(Icon(Icons.radio), tap: widget.icon2Tap),
        _floatingIcon(Icon(Icons.wifi)),
        _floatingIcon(Icon(Icons.location_city)),
      ],
    );
  }

  Widget _floatingIcon(Icon icon, {Function tap}) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.white,
        ),
        child: icon,
      ),
    );
  }
}
