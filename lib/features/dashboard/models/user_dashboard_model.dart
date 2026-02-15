// Will delete

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ewastecare/features/dashboard/models/user_dashboard_constant.dart';

// class UserDashboardModel {
//   String id;
//   double pp;
//   double pet;
//   double hdpe;
//   int totalEcoPoints;
//   double totalAllPlastic;
//   String tierLevel;

//   UserDashboardModel({
//     required this.id,
//     required this.pp,
//     required this.pet,
//     required this.hdpe,
//     required this.totalEcoPoints,
//     required this.totalAllPlastic,
//     required this.tierLevel,
//   });

//   static UserDashboardModel empty() => UserDashboardModel(
//       id: '',
//       pp: 0.0,
//       pet: 0.0,
//       hdpe: 0.0,
//       totalEcoPoints: 0,
//       totalAllPlastic: 0.0,
//       tierLevel: '');

//   toJson() {
//     return {
//       "UserID": id,
//       "TypePP": pp,
//       "TypePET": pet,
//       "TypeHDPE": hdpe,
//       "TotalEcoPoints": totalEcoPoints,
//       "TotalAllPlastic": totalAllPlastic,
//       "TierLevel": tierLevel,
//     };
//   }

//   factory UserDashboardModel.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> document) {
//     if (document.data() == null) return UserDashboardModel.empty();
//     final data = document.data()!;
//     return UserDashboardModel(
//       id: document.id,
//       pp: data["TypePP"],
//       pet: data["TypePET"],
//       hdpe: data["TypeHDPE"],
//       totalEcoPoints: data["TotalEcoPoints"],
//       totalAllPlastic: data["TotalAllPlastic"],
//       tierLevel: data["TierLevel"],
//     );
//   }

//   void updateTier() {
//     double totalCollectedPlastic = pp + pet + hdpe;
//     if (totalCollectedPlastic >= TierCriteria.expert) {
//       tierLevel = 'Expert';
//     } else if (totalCollectedPlastic >= TierCriteria.explorer) {
//       tierLevel = 'Explorer';
//     } else {
//       tierLevel = 'Newbie';
//     }
//   }

//   double getProgress() {
//     double progress = 0.0;
//     double totalCollectedPlastic = pp + pet + hdpe;
//     if (tierLevel == 'Newbie') {
//       progress = totalCollectedPlastic / TierCriteria.explorer;
//     } else if (tierLevel == 'Explorer') {
//       progress = (totalCollectedPlastic - TierCriteria.explorer) /
//                  (TierCriteria.expert - TierCriteria.explorer);
//     } else if (tierLevel == 'Expert') {
//       progress = 1.0; // Expert tier, progress is complete
//     }
//     return progress;
//   }

//   String getNextTier() {
//     if (tierLevel == 'Newbie') {
//       return 'Explorer';
//     } else if (tierLevel == 'Explorer') {
//       return 'Expert';
//     } else {
//       return 'none'; // Already at highest tier
//     }
//   }

//   double getNextTierThreshold() {
//     if (tierLevel == 'Newbie') {
//       return TierCriteria.explorer.toDouble();
//     } else if (tierLevel == 'Explorer') {
//       return TierCriteria.expert.toDouble();
//     } else {
//       return totalAllPlastic; // For expert, return the current total as there's no next tier
//     }
//   }
// }
