import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:tugas_uasppb/screens/cart/cart_screen.dart';

class IconBtnWithCounter extends StatelessWidget {
  final String svgSrc;
  final int numOfItems;
  final GestureTapCallback press;
  final double size;

  const IconBtnWithCounter({
    Key? key,
    required this.svgSrc,
    required this.press,
    this.numOfItems = 0,
    this.size = 24,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            svgSrc,
            height: size,
          ),
          onPressed: press,
        ),
        if (numOfItems != 0)
          Positioned(
            top: -1,
            right: -3,
            child: Container(
              padding: const EdgeInsets.all(2),
              height: size / 2.5,
              width: size / 1.5,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4848),
                shape: BoxShape.circle,
                border: Border.all(width: 1.5, color: Colors.white),
              ),
              child: Center(
                child: Text(
                  "$numOfItems",
                  style: TextStyle(
                    fontSize: size / 3,
                    height: 1,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
      ],
    );
  }
}
