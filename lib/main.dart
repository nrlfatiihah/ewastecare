import 'dart:async';

import 'package:ewastecare/data/repositories/authentication/admin_auth_repo.dart';
import 'package:ewastecare/data/services/notifications/push_notification_service.dart';
import 'package:ewastecare/features/module/controllers/module_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ewastecare/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ewastecare/firebase_options.dart';
import 'package:ewastecare/data/repositories/authentication/authentication_repository.dart';

Future<void> main() async {
  // Todo: Add Widgets Bindings
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

  // Todo: Init Local Storage
  await GetStorage.init();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize Authentication Repositories
  final authenticationRepository = AuthenticationRepository();
  final adminAuthenticationRepository = AdminAuthenticationRepository();

  // Initialize GetX Controllers
  Get.put(authenticationRepository);
  Get.put(adminAuthenticationRepository);
  Get.put(ModuleController());
  final pushNotificationService = Get.put(PushNotificationService());
  await pushNotificationService.init();
  // Get.put(AdminDashboardService());

  runApp(const App());
  unawaited(pushNotificationService.handleInitialMessage());
}
