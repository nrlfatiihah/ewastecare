import 'package:ewastecare/features/personalization/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserModel PDPA consent', () {
    test('serializes PDPA consent metadata to JSON', () {
      final user = UserModel(
        id: 'user-1',
        firstName: 'Ali',
        lastName: 'Abu',
        username: 'ali',
        homeAddress: 'Kuala Lumpur',
        gender: 'Male',
        dateOfBirth: '1990-01-01',
        email: 'ali@example.com',
        phoneNo: '0123456789',
        profilePicture: '',
        wastePoint: 0,
        role: 'user',
        userQR: '',
        customUserId: 'kl',
        pdpaConsentAt: '2026-08-17T10:30:00Z',
        pdpaNoticeVersion: 'PDPA-2026-08',
      );

      final json = user.toJson();

      expect(json['PDPAConsentAt'], '2026-08-17T10:30:00Z');
      expect(json['PDPANoticeVersion'], 'PDPA-2026-08');
    });
  });
}
