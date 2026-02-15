import 'package:flutter/material.dart';

class WasteSectionHeading extends StatelessWidget {
  const WasteSectionHeading({
    super.key,
    this.textColor,
    this.showActionButton = true,
    required this.title,
    this.icon,
    this.onPressed,
  });

  final Color? textColor;
  final bool showActionButton;
  final String title;
  final IconData? icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall!.apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          IconButton(onPressed: onPressed, icon: Icon(icon)),
      ],
    );
  }
}
