import 'dart:async';

import 'package:ewastecare/data/repositories/dashboard/user_dashboard_repository.dart';
import 'package:ewastecare/features/dashboard/models/new_user_dashboard_model.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:get/get.dart';

class UserDashboardController extends GetxController {
  static UserDashboardController get instance =>
      Get.put(UserDashboardController());

  final isLoading = false.obs;
  final userController = UserController();
  final userDashboardRepository = UserDashboardRepository();
  bool dataFetched = false;
  final RxBool dataFetched2 = false.obs;
  StreamSubscription<NewUserDashboardModel>? _dashboardSubscription;
  // Rx<UserDashboardModel> userDashboardData = UserDashboardModel.empty().obs;
  Rx<NewUserDashboardModel> newUserDashboardData =
      NewUserDashboardModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    listenToUserDashboardChanges();
  }
  // Future<void> fetchUserRecord() async {
  //   try {
  //     isLoading.value = true;
  //     if (!dataFetched) {
  //       final userId = await userController.getCurrentUserId();
  //       final userDashboardData =
  //           await userDashboardRepository.fetchUserDashboardData(userId);
  //       // final userDashboardData =
  //       //     await userDashboardRepository.fetchUserDashboardData(userId);
  //       this.userDashboardData(userDashboardData);
  //       // dataFetched = true;
  //     }
  //   } catch (e) {
  //     userDashboardData(UserDashboardModel.empty());
  //   } finally {
  //     dataFetched = true;
  //     isLoading.value = false;
  //   }
  // }

  //  Future<void> fetchUserRecord() async {
  //     try {
  //       isLoading.value = true;
  //       if (!dataFetched) {
  //         final userId = await userController.getCurrentUserId();
  //         final userDashboardData =
  //             await userDashboardRepository.fetchUserDashboardData(userId);
  //         // final userDashboardData =
  //         //     await userDashboardRepository.fetchUserDashboardData(userId);
  //         this.userDashboardData(userDashboardData);
  //         // dataFetched = true;
  //       }
  //     } catch (e) {
  //       userDashboardData(UserDashboardModel.empty());
  //     } finally {
  //       dataFetched = true;
  //       isLoading.value = false;
  //     }
  //   }
  Future<void> listenToUserDashboardChanges() async {
    try {
      isLoading.value = true;
      final userId = await userController.getCurrentUserId();

      await _dashboardSubscription?.cancel();
      _dashboardSubscription = userDashboardRepository
          .watchUserDashboardTryData(userId)
          .listen(
            (dashboardData) {
              newUserDashboardData(dashboardData);
              dataFetched = true;
              isLoading.value = false;
            },
            onError: (_) {
              newUserDashboardData(NewUserDashboardModel.empty());
              isLoading.value = false;
            },
          );
    } catch (e) {
      newUserDashboardData(NewUserDashboardModel.empty());
      isLoading.value = false;
    }
  }

  Future<void> NewfetchUserRecord() async {
    try {
      isLoading.value = true;
      if (!dataFetched) {
        final userId = await userController.getCurrentUserId();
        final newUserDashboardData = await userDashboardRepository
            .fetchUserDashboardTryData(userId);
        // final userDashboardData =
        //     await userDashboardRepository.fetchUserDashboardData(userId);
        this.newUserDashboardData(newUserDashboardData);
        print("Data able to fatched");
        // dataFetched = true;
      }
    } catch (e) {
      newUserDashboardData(NewUserDashboardModel.empty());
      print("No data fetched");
    } finally {
      dataFetched = true;
      isLoading.value = false;
    }
  }

  Future<void> setDefaultDashboardValues() async {
    try {
      isLoading.value = true;
      if (!dataFetched) {
        final userId = await userController.getCurrentUserId();
        print(userId);
        await userDashboardRepository.setDefaultDashboardValues(userId);
        // this.userDashboardData(userDashboardData);
        // dataFetched = true;
      }
    } catch (e) {
      print(e);
    } finally {
      dataFetched = true;
      isLoading.value = false;
    }
  }

  void resetDataFetched() {
    dataFetched = false;
  }

  @override
  void onClose() {
    _dashboardSubscription?.cancel();
    super.onClose();
  }
}
