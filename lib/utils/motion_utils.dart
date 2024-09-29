import 'package:flutter/material.dart';

class BouncingScroll extends ScrollBehavior {
  const BouncingScroll();

  @override
  ScrollPhysics getScrollPhysics(_) => const BouncingScrollPhysics();
}
