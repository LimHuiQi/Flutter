import 'dart:convert';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  final User user;
  final double balance;

  WalletScreen({required this.user, required this.balance});

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _currentBalance = 0.0;

  @override
  void initState() {
    super.initState();
    _currentBalance =
        widget.balance; // Set the initial balance from the 'balance' parameter
    _fetchBalance(); // Fetch the initial balance when the screen is loaded
  }

  Future<void> _fetchBalance() async {
    try {
      String? userId = widget.user.id;
      final response = await http.post(
        Uri.parse("${MyConfig().server}/barterit/php/fetch_balance.php"),
        body: {
          "userid": userId,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response and update the _currentBalance
        Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _currentBalance = double.parse(data['balance'].toString());
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to fetch wallet balance.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error while fetching wallet balance.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BIT Wallet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Balance:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              '\RM${_currentBalance.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddFundsDialog(context);
              },
              child: const Text('Add Funds'),
            ),
            ElevatedButton(
              onPressed: () {
                _showWithdrawFundsDialog(context);
              },
              child: const Text('Withdraw Funds'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddFundsDialog(BuildContext context) async {
    double? amountToAdd = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double enteredAmount = 0.0;

        return AlertDialog(
          title: const Text('Add Funds'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  enteredAmount = double.tryParse(value) ?? 0.0;
                },
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(enteredAmount);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );

    if (amountToAdd != null && amountToAdd > 0) {
      _updateWalletBalance(amountToAdd);
    }
  }

  Future<void> _showWithdrawFundsDialog(BuildContext context) async {
    double? amountToWithdraw = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double enteredAmount = 0.0;

        return AlertDialog(
          title: const Text('Withdraw Funds'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  enteredAmount = double.tryParse(value) ?? 0.0;
                },
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(enteredAmount);
              },
              child: const Text('Withdraw'),
            ),
          ],
        );
      },
    );

    if (amountToWithdraw != null && amountToWithdraw > 0) {
      _withdrawFunds(amountToWithdraw);
    }
  }

  Future<void> _updateWalletBalance(double amountToAdd) async {
    try {
      String? userId = widget.user.id; // Use widget.user.id
      double updatedBalance = _currentBalance + amountToAdd;
      String currentDate = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse("${MyConfig().server}/barterit/php/update_wallet.php"),
        body: {
          "userid": userId,
          "balance": updatedBalance.toString(),
          "dateupdate": currentDate,
        },
      );

      if (response.statusCode == 200) {
        // Successfully updated balance in the server, now update the local balance
        setState(() {
          _currentBalance = updatedBalance;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Added RM${amountToAdd.toStringAsFixed(2)} to your wallet.'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update wallet balance.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
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

  Future<void> _withdrawFunds(double amountToWithdraw) async {
    try {
      String? userId = widget.user.id;
      double updatedBalance =
          _currentBalance - amountToWithdraw; // Subtract the amount to withdraw
      String currentDate = DateTime.now().toIso8601String();

      final response = await http.post(
        Uri.parse("${MyConfig().server}/barterit/php/update_wallet.php"),
        body: {
          "userid": userId,
          "balance": updatedBalance.toString(),
          "dateupdate": currentDate,
        },
      );

      if (response.statusCode == 200) {
        // Successfully updated balance in the server, now update the local balance
        setState(() {
          _currentBalance = updatedBalance;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Withdrew RM${amountToWithdraw.toStringAsFixed(2)} from your wallet.'),
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update wallet balance.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
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
