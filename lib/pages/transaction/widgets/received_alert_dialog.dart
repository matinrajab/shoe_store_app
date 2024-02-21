import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_store_app/pages/transaction/order_page.dart';
import 'package:shoe_store_app/pages/widgets/my_alert_dialog.dart';
import 'package:shoe_store_app/pages/widgets/my_circular_indicator.dart';
import 'package:shoe_store_app/pages/widgets/my_snack_bar.dart';
import 'package:shoe_store_app/providers/transaction_provider.dart';
import 'package:shoe_store_app/shared/order_status.dart';

class ReceivedAlertDialog extends StatelessWidget {
  final int id;

  const ReceivedAlertDialog(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    Future<bool> handleReceived() async {
      bool result;
      transactionProvider.isLoading = true;
      if (await transactionProvider.updateStatus(
        status: successOrder,
        id: id,
      )) {
        await Provider.of<TransactionProvider>(context, listen: false)
            .getTransactions();
        result = true;
      } else {
        MySnackBar.showSnackBar(
          context: context,
          message: 'Gagal Received',
          isSuccess: false,
        );
        result = false;
      }
      Navigator.pop(context);
      transactionProvider.isLoading = false;
      return result;
    }

    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, _) =>
          transactionProvider.isLoading
              ? MyCircularIndicator.show()
              : MyAlertDialog(
                  text: 'Are you sure your order has been received?',
                  onYesTapped: () async {
                    if (await handleReceived()) {
                      Navigator.pushReplacementNamed(
                        context,
                        OrderPage.routeName,
                        arguments: 2,
                      );
                    }
                  },
                ),
    );
  }
}
