import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ewastecare/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ewastecare/firebase_options.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final authenticationRepository = AuthenticationRepository();

  Get.put(authenticationRepository);

  runApp(const App());
}
