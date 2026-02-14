import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ewastecare/data/repositories/dashboard/admin_dashboard_repository.dart';
import 'package:ewastecare/models/admin_dashboard_models.dart';
import 'package:ewastecare/controllers/user_controller.dart';

class AdminDashboardController extends GetxController {
  static AdminDashboardController instance = Get.put(
    AdminDashboardController(),
  );

  final isLoading = false.obs;
  final adminDashboardRepository = AdminDashboardRepository();
  final userController = UserController();
  bool dataFetched = false;
  final RxBool dataFetched2 = false.obs;
  Rx<AdminDashboardModel> adminDashboardData = AdminDashboardModel.empty().obs;
  var adminDashboardData2 = <Map<String, dynamic>>[].obs;
  var totalTypePPSum = 0.0.obs;
  var totalTypePETSum = 0.0.obs;
  var totalTypeHDPESum = 0.0.obs;
  var totalAllPlasticSum = 0.0.obs;
  var totalAllPlasticOverallSum = 0.0.obs;
  var totalActiveUsers = 0.obs;
  var totalGeneratedPoint = 0.obs;
  var totalRecycledItems = 0.obs;
  var topUser = ''.obs;
  var mostPerformantUser = ''.obs;
  var mostPerformantUsername = ''.obs;
  var totalUsers = 0.obs;
  var maleUsers = 0.obs;
  var femaleUsers = 0.obs;
  var selectedType = 'User Information'.obs;
  var selectedStartDate = Rxn<DateTime>();
  var selectedEndDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchAdminDashboardData();
    fetchAdminDashboardDataByFilterDate();
    fetchUserStatistics();
  }

  Future<void> fetchAdminDashboardData() async {
    try {
      isLoading.value = true;
      adminDashboardData2.value = await adminDashboardRepository
          .getAdminDashboardData();
      calculateTotalDashboard();
    } catch (e) {
      adminDashboardData2.value = [];
      totalRecycledItems.value = 0;
      totalGeneratedPoint.value = 0;
      totalActiveUsers.value = 0;
      topUser.value = '';
      mostPerformantUser.value = '';
      mostPerformantUsername.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAdminDashboardDataByFilterDate([
    DateTime? selectedStartDate,
    DateTime? selectedEndDate,
  ]) async {
    print(
      "Test this time for fetchAdminDashboardDataByFilterDate function: $selectedStartDate, $selectedEndDate",
    );
    try {
      isLoading.value = true;
      adminDashboardData2.value = await adminDashboardRepository
          .getAdminDashboardDataByFilterDate(
            selectedStartDate,
            selectedEndDate,
          );
      calculateTotalDashboard();
    } catch (e) {
      adminDashboardData2.value = [];
      totalTypePPSum.value = 0.0;
      totalTypePETSum.value = 0.0;
      totalTypeHDPESum.value = 0.0;
      totalAllPlasticSum.value = 0.0;
      totalAllPlasticOverallSum.value = 0.0;
      totalGeneratedPoint.value = 0;
      totalActiveUsers.value = 0;
      topUser.value = '';
      mostPerformantUser.value = '';
      mostPerformantUsername.value = '';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserStatistics() async {
    try {
      final genderStats = await adminDashboardRepository
          .fetchGenderStatistics();
      maleUsers.value = genderStats['maleUsers'] ?? 0;
      femaleUsers.value = genderStats['femaleUsers'] ?? 0;
    } catch (e) {
      totalUsers.value = 0;
      maleUsers.value = 0;
      femaleUsers.value = 0;
    }
  }

  Future<void> calculateTotalDashboard() async {
    double sumPP = 0.0;
    double sumPET = 0.0;
    double sumHDPE = 0.0;
    double sumAllPlastic = 0.0;
    double sumAllPlasticOverall = 0.0;
    double totalPoints = 0.0;
    final activeUser = <String>{};
    final userTotals = <String, double>{};

    for (var data in adminDashboardData2) {
      if (data.containsKey('TypePP')) {
        sumPP += data['TypePP'];
      }

      if (data.containsKey('TypePET')) {
        sumPET += data['TypePET'];
      }

      if (data.containsKey('TypeHDPE')) {
        sumHDPE += data['TypeHDPE'];
      }

      if (data.containsKey('TotalPlastic')) {
        sumAllPlastic += data['TotalPlastic'];
        final userId = data['UserID'] as String;
        userTotals.update(
          userId,
          (value) => value + data['TotalPlastic'],
          ifAbsent: () => data['TotalPlastic'],
        );
      }

      if (data.containsKey('TotalAllPlastic')) {
        sumAllPlasticOverall += data['TotalAllPlastic'];
      }

      if (data.containsKey('TotalPoints')) {
        totalPoints += data['TotalPoints'];
      }

      if (data.containsKey('UserID')) {
        activeUser.add(data['UserID']);
      }
    }
    totalTypePPSum.value = double.parse(sumPP.toStringAsFixed(2));
    totalTypePETSum.value = double.parse(sumPET.toStringAsFixed(2));
    totalTypeHDPESum.value = double.parse(sumHDPE.toStringAsFixed(2));
    totalAllPlasticSum.value = double.parse(sumAllPlastic.toStringAsFixed(2));
    totalAllPlasticOverallSum.value = double.parse(
      sumAllPlasticOverall.toStringAsFixed(2),
    );
    totalGeneratedPoint.value = totalPoints.toInt();
    totalActiveUsers.value = activeUser.length;

    if (userTotals.isNotEmpty) {
      final mostPerformantUserEntry = userTotals.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );
      mostPerformantUser.value = mostPerformantUserEntry.key;
      await fetchUsernameByUserId(mostPerformantUser.value);
    } else {
      mostPerformantUser.value = '';
      mostPerformantUsername.value = '';
    }
  }

  Future<void> fetchUsernameByUserId(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (userDoc.exists) {
        mostPerformantUsername.value = userDoc.data()?['Username'] ?? '';
      } else {
        mostPerformantUsername.value = 'Unknown User';
      }
    } catch (e) {
      mostPerformantUsername.value = 'Error fetching username';
    }
  }

  void resetDataFetched() {
    dataFetched = false;
  }

  void resetFilters() {
    selectedType.value = 'User Information';
    selectedStartDate.value = null;
    selectedEndDate.value = null;
  }
}
