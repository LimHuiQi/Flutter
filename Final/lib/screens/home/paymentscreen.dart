import 'dart:convert';

import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final double itemPrice; // Price of the item to be paid
  late final double userBalance; // User's wallet balance
  final User user;
  final Item useritem;

  PaymentScreen(
      {Key? key,
      required this.itemPrice,
      required this.userBalance,
      required this.user,
      required this.useritem})
      : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool paymentInProgress = false;
  bool paymentSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your Wallet Balance: RM ${widget.userBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Screen',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: paymentInProgress
                  ? null
                  : () {
                      // Call the payment function when the Pay button is pressed
                      _simulatePayment();
                    },
              child: paymentInProgress
                  ? const CircularProgressIndicator() // Show a loading indicator during payment
                  : const Text('Pay'),
            ),
            if (paymentSuccess)
              const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Payment Successful!',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _simulatePayment() {
    if (widget.userBalance >= widget.itemPrice) {
      setState(() {
        paymentInProgress = true;
      });

      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          paymentInProgress = false;
          paymentSuccess = true;
        });

        if (paymentSuccess) {
          double updatedBalance = widget.userBalance - widget.itemPrice;
          _updateUserBalance(updatedBalance);
          _createOrder();
          _deleteItem();
        } else {}
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Insufficient Balance'),
          content: const Text(
              'Your wallet balance is not enough to pay for the item.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _createOrder() {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/add_order.php"),
        body: {
          "itemid": widget.useritem.itemId,
          "itembrand": widget.useritem.itemBrand,
          "itemname": widget.useritem.itemName,
          "itemprice": widget.useritem.itemPrice,
          "iteminterest": widget.useritem.itemInterest,
          "userid": widget.user.id,
          "userphone": widget.user.phone,
          "sellerid": widget.useritem.userId,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MainScreen(user: widget.user),
              ),
            );
          });
        } else {}
      } else {}
    });
  }

  void _deleteItem() {
    print(widget.useritem.itemId);
    http.post(Uri.parse("${MyConfig().server}/barterit/php/delete_item.php"),
        body: {
          "itemid": widget.useritem.itemId,
        }).then((response) {
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
        } else {}
      } else {}
    });
  }

  void _updateUserBalance(double updatedBalance) {
    try {
      http.post(
        Uri.parse("${MyConfig().server}/barterit/php/update_wallet.php"),
        body: {
          "userid": widget.user.id, // Use widget.user.id
          "balance": updatedBalance.toString(),
          "dateupdate": DateTime.now().toIso8601String(),
        },
      ).then((response) {
        if (response.statusCode == 200) {
          // Successfully updated balance in the server
          setState(() {
            widget.userBalance = updatedBalance;
            paymentSuccess = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Deducted RM${widget.itemPrice.toStringAsFixed(2)} from your wallet.'),
              duration: const Duration(seconds: 3),
            ),
          );

          // Call the _createOrder and _deleteItem methods since payment is successful
          _createOrder();
          _deleteItem();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update wallet balance.'),
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while updating wallet balance.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}
