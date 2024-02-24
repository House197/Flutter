import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgets_app/presentation/providers/theme_provider.dart';

class ThemeChangerScreen extends ConsumerWidget {
  static const name = 'theme_changer_screen';
  const ThemeChangerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final isDarkMode = ref.watch(isDarkModeProvider);
    final isDarkMode = ref.watch(themeNotifierProvider).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Changer'),
        actions: [
          IconButton(
              onPressed: () {
                //ref.read(isDarkModeProvider.notifier).update((state) => !state);
                ref.read(themeNotifierProvider.notifier).toggleDarkMode();
              },
              icon: Icon(isDarkMode ? Icons.dark_mode : Icons.sunny))
        ],
      ),
      body: _ThemeChangerView(),
    );
  }
}

class _ThemeChangerView extends ConsumerWidget {
  const _ThemeChangerView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final selectedColor = ref.watch(selectedColorProvider);
    final List<Color> colors = ref.watch(colorListProvider);
    final selectedColor = ref.watch(themeNotifierProvider).selectedColor;
    return ListView.builder(
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return RadioListTile(
              title: Text(
                'Este color',
                style: TextStyle(color: color),
              ),
              subtitle: Text('${color.value}'),
              activeColor: color,
              value: index,
              groupValue: selectedColor,
              onChanged: (value) {
                //ref
                //   .read(selectedColorProvider.notifier)
                // .update((state) => value!);
                ref
                    .read(themeNotifierProvider.notifier)
                    .changeColorIndex(value!);
              });
        });
  }
}

final Map<String, dynamic> list = {
  'PartsInfo_Dictionary':
      "{'82848063-4-SP': {'id_partnumber': 20, 'description': 'Cushion 3ra Fila', 'id_c_partnumber': 14, 'partnumber': '82848063-4-SP'}}",
  'Dates_Dictionary':
      "{'Week11': 1704693600000L, 'Week1': 1698645600000L, 'Week0': 1698040800000L, 'Week3': 1699855200000L, 'Week2': 1699250400000L, 'Week10': 1704088800000L, 'Week5': 1701064800000L, 'Week4': 1700460000000L, 'Week7': 1702274400000L, 'Week6': 1701669600000L, 'Week9': 1703484000000L, 'Week8': 1702879200000L}",
  'Colors_Dictionary': '{}',
  'weekStart': 43,
  'id_line': 9,
  'line_name': 'GMAW TIGUAN 3Row S3'
};
