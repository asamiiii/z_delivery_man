import 'package:flutter/material.dart';

//? --> Fill All Avillable Space
class ExSpace extends StatelessWidget {
  /// Fill All Avillable Space
  const ExSpace({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Expanded(child: SizedBox());
  }
}

//? --> Add Space Horizontally
// ignore: must_be_immutable
class HSpace extends StatelessWidget {
  double? space;

  /// Add Space Horizontally .
  HSpace(
    this.space,
    Key? key,
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space ?? 0,
    );
  }
}

//? --> Add Space Vertically
// ignore: must_be_immutable
class VSpace extends StatelessWidget {
  double? space;

  /// Add Space Vertically .
  VSpace(
    this.space, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space ?? 0,
    );
  }
}
