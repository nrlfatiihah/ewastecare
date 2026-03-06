import 'package:ewastecare/bindings/general_bindings.dart';
import 'package:ewastecare/utils/constants/colors.dart';
import 'package:ewastecare/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: WasteAppTheme.lightTheme,
      darkTheme: WasteAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        backgroundColor: WasteColors.primary,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      ),
    );
  }
}
