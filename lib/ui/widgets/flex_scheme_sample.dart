import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class FlexSchemeSample extends StatelessWidget {
  const FlexSchemeSample({
    Key? key,
    required this.flexSchemeColor,
    final this.height = 24,
    final this.width = 24,
    final this.borderRadius = 4,
    final this.padding,
  }) : super(key: key);

  final FlexSchemeColor flexSchemeColor;
  final double height;
  final double width;
  final double borderRadius;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SchemeColorBox(
          color: flexSchemeColor.primary,
          height: height,
          width: width,
          borderRadius: borderRadius,
          padding: padding,
        ),
        _SchemeColorBox(
          color: flexSchemeColor.primaryVariant,
          height: height,
          width: width,
          borderRadius: borderRadius,
          padding: padding,
        ),
        _SchemeColorBox(
          color: flexSchemeColor.secondary,
          height: height,
          width: width,
          borderRadius: borderRadius,
          padding: padding,
        ),
        _SchemeColorBox(
          color: flexSchemeColor.secondaryVariant,
          height: height,
          width: width,
          borderRadius: borderRadius,
          padding: padding,
        ),
      ],
    );
  }
}

/// From Flex Color Scheme API
/// Draws a box with rounded corners with given background [color].
///
/// Have defaults for standard use case, but may be modified via parent.
class _SchemeColorBox extends StatelessWidget {
  /// Default constructor.
  const _SchemeColorBox({
    Key? key,
    required final this.color,
    final this.height = 24,
    final this.width = 24,
    final this.borderRadius = 4,
    final this.padding,
  }) : super(key: key);

  /// The background color used to draw an individual scheme color box.
  /// Required, cannot be null.
  final Color color;

  /// The height of an individual scheme color box. Defaults to 24 dp.
  final double height;

  /// The width of an individual scheme color box. Defaults to 24 dp.
  final double width;

  /// The circular borderRadius of an individual scheme color box.
  /// Defaults to 4 dp.
  final double borderRadius;

  /// Padding around an individual scheme color box.
  /// If null, default to `const EdgeInsets.all(3)`
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(3),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
    );
  }
}
