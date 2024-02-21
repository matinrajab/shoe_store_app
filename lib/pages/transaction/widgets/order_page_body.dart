import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoe_store_app/models/transaction_model.dart';
import 'package:shoe_store_app/pages/transaction/widgets/order_card.dart';
import 'package:shoe_store_app/pages/transaction/widgets/received_alert_dialog.dart';
import 'package:shoe_store_app/pages/widgets/empty_item.dart';
import 'package:shoe_store_app/providers/transaction_provider.dart';
import 'package:shoe_store_app/shared/order_status.dart';
import 'package:shoe_store_app/shared/theme.dart';

class OrderPageBody extends StatelessWidget {
  final String status;
  final String textButton;

  const OrderPageBody({
    super.key,
    required this.status,
    this.textButton = '',
  });

  @override
  Widget build(BuildContext context) {
    TransactionProvider transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);

    List<TransactionModel> transactions = [];

    transactionProvider.transactions.map((transaction) {
      if (transaction.status == status) {
        transactions.add(transaction);
      }
    }).toList();

    onOrderReceivedTapped(int id) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => ReceivedAlertDialog(id),
      );
    }

    return Center(
      child: transactions.isEmpty
          ? const EmptyItem(
              iconAsset: 'assets/icon/icon_empty_cart.png',
              title: 'Oops! Your Order is Empty',
              subtitle: 'Let\'s find your favorite shoes',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: pagePadding,
              ),
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) => OrderCard(
                transaction: transactions[index],
                isButtonAppear: status != 'SUCCESS',
                textButton: textButton,
                onButtonTap: () {
                  switch (transactions[index].status) {
                    case pendingOrder:
                      () {};
                      break;
                    case shippingOrder:
                      onOrderReceivedTapped(transactions[index].id!);
                      break;
                  }
                },
              ),
            ),
    );
  }
}