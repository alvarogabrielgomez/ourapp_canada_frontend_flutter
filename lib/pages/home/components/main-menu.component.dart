import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ourapp_canada/colors.dart';

class HomeMainMenu extends StatelessWidget {
  final List<Widget> children;

  HomeMainMenu({@required this.children});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(20),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        childAspectRatio: 1,
        mainAxisSpacing: 23,
        children: children,
      ),
    );
  }
}

class ItemMainMenu extends StatelessWidget {
  final Function onTap;
  final Widget icon;
  final String label;
  ItemMainMenu({@required this.onTap, this.icon, this.label});
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 2,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          // width: 97,
          // height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(18)),
            border: Border.all(width: 1, color: redCanada),
          ),
          child: Center(
            child: icon != null
                ? icon
                : FaIcon(
                    FontAwesomeIcons.random,
                    color: redCanada,
                  ),
          ),
        ),
      ),
    );
  }
}
