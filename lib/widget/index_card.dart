import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wust_helper_ios/util/color_util.dart';

class IndexCard extends StatefulWidget {
  final double width;
  final double height;
  final String backgroundColor;
  final Widget child;
  final Function onTap;
  const IndexCard(
    this.width,
    this.height,
    this.backgroundColor,
    this.child,
    this.onTap, {
    Key key,
  }) : super(key: key);
  @override
  _IndexCardState createState() => _IndexCardState();
}

class _IndexCardState extends State<IndexCard> {
  bool hasShadow = true;
  bool hasTapped = false;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.width == null ? 1 : null,
      heightFactor: widget.height == null ? 1 : null,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Container(
            child: GestureDetector(
          onTap: () => widget.onTap(),
          child: Listener(
            onPointerDown: (event) {
              setState(() {
                hasShadow = false;
                hasTapped = true;
              });
            },
            onPointerUp: (event) {
              setState(() {
                hasShadow = true;
                hasTapped = false;
              });
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color(
                        transformColor("FF", widget.backgroundColor),
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: hasShadow
                          ? [
                              BoxShadow(
                                  color: Color(transformColor('38', '#dcdcdc')),
                                  offset: Offset(1, 1),
                                  spreadRadius: 2,
                                  blurRadius: 2),
                            ]
                          : []),
                ),
                Container(
                  child: widget.child,
                ),
                hasTapped
                    ? FractionallySizedBox(
                        heightFactor: 1,
                        widthFactor: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Color(transformColor('25', '#dcdcdc')),
                          ),
                        ))
                    : Container()
              ],
            ),
          ),
        )),
      ),
    );
  }
}
//screenWidth * 0.9 * 0.42
//screenWidth * 0.44 * 0.57
//screenWidth * 0.44 * 1.18
