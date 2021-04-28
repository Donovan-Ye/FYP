import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FloatingIcons extends StatefulWidget {
  final Function icon1Tap;
  final Function icon2Tap;
  final Function icon3Tap;
  final Function icon4Tap;
  final Function icon5Tap;
  final Icon icon2;
  final Color icon2Color;
  final Icon icon4;
  final Color icon4Color;
  final Icon icon5;
  final Color icon5Color;

  const FloatingIcons({
    Key key,
    this.icon1Tap,
    this.icon2Tap,
    this.icon3Tap,
    this.icon4Tap,
    this.icon4,
    this.icon4Color,
    this.icon2,
    this.icon2Color,
    this.icon5Tap,
    this.icon5,
    this.icon5Color,
  }) : super(key: key);

  @override
  _FloatingIcons createState() => _FloatingIcons();
}

class _FloatingIcons extends State<FloatingIcons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _floatingIcon(Icon(Icons.hail), Colors.white, tap: widget.icon1Tap),
        _floatingIcon(widget.icon2, widget.icon2Color, tap: widget.icon2Tap),
        _floatingIcon(Icon(Icons.wifi), Colors.white, tap: widget.icon3Tap),
        _floatingIcon(widget.icon4, widget.icon4Color, tap: widget.icon4Tap),
        _floatingIcon(widget.icon5, widget.icon5Color, tap: widget.icon5Tap),
      ],
    );
  }

  Widget _floatingIcon(Icon icon, Color color, {Function tap}) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
        ),
        child: icon,
      ),
    );
  }
}
