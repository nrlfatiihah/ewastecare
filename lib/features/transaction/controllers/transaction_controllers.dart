import 'package:get/get.dart';
import 'package:ewastecare/features/transaction/model/transaction_model.dart';
import 'package:ewastecare/data/repositories/transaction/transaction_repository.dart';

class TransactionController extends GetxController {
  final TransactionRepository transactionRepository;
  final String userId;

  TransactionController(this.transactionRepository, this.userId);

  RxList<TransactionModel> transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserTransactions();
  }

  Future<void> fetchUserTransactions() async {
    try {
      final fetchedTransactions = await transactionRepository
          .fetchUserTransactions(userId);
      transactions.value = fetchedTransactions;
    } catch (e) {
      // Handle error
    }
  }
}
