// use and checked
import 'package:ewastecare/common/widget/appbar/appbar.dart';
import 'package:ewastecare/utils/constants/texts.dart';
import 'package:ewastecare/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class UserQrCode extends StatelessWidget {
  const UserQrCode({super.key, this.qrData});

  final String? qrData;

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    final qrValue = qrData ?? controller.getDisplayUserId();
    return Theme(
      data: ThemeData(brightness: Brightness.light),
      child: Scaffold(
        appBar: WasteAppBar(
          showBackArrow: true,
          title: Text(WasteTexts.userQrCode.tr),
        ),
        body: Center(
          child: Obx(() {
            final userQR = controller.user.value.userQR;

            if (userQR.isNotEmpty && qrData == null) {
              return Image.network(userQR);
            }

            return QrImageView(
              data: qrValue,
              version: QrVersions.auto,
              size: 220,
              backgroundColor: Colors.white,
            );
          }),
        ),
      ),
    );
  }
}
