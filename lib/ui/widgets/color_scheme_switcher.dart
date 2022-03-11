import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:recipes_app/ui/widgets/flex_scheme_sample.dart';

class ColorSchemeSwitcher extends StatefulWidget {
  FlexScheme colorScheme;
  final ValueChanged<FlexScheme> onSchemeChanged;

  ColorSchemeSwitcher({
    Key? key,
    required this.colorScheme,
    required this.onSchemeChanged,
  }) : super(key: key);

  @override
  State<ColorSchemeSwitcher> createState() => _ColorSchemeSwitcherState();
}

class _ColorSchemeSwitcherState extends State<ColorSchemeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Icon(
          Icons.color_lens,
          color: Theme.of(context).colorScheme.onBackground,
        ),
        const SizedBox(width: 20),
        const Text('Color Scheme'),
        const Spacer(),
        DropdownButton<FlexScheme>(
          value: widget.colorScheme,
          icon: const Icon(Icons.arrow_downward),
          onChanged: (FlexScheme? newScheme) {
            widget.colorScheme = newScheme!;
            widget.onSchemeChanged(newScheme);
            setState(() {});
          },
          items: FlexScheme.values
              .map<DropdownMenuItem<FlexScheme>>((FlexScheme val) {
            // TODO: make it use the current themeMode
            return DropdownMenuItem<FlexScheme>(
              value: val,
              child: FlexSchemeSample(
                flexSchemeColor: FlexColor.schemes[val]?.light ??
                    FlexColor.schemes[FlexScheme.amber]!.light,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
