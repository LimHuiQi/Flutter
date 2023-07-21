import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/home/paymentscreen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ItemDetailScreen extends StatefulWidget {
  final Item useritem;
  final User user;

  const ItemDetailScreen({Key? key, required this.useritem, required this.user})
      : super(key: key);

  @override
  _ItemDetailScreenState createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  int qty = 0;

  @override
  void initState() {
    super.initState();
  }

  final df = DateFormat('dd-MM-yyyy hh:mm a');
  final List<File?> _images = List.generate(3, (index) => null);

  late double screenHeight, screenWidth, cardwitdh;
  @override
  Widget build(BuildContext context) {
    loadBalance();
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Item Details")),
      body: Column(
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: PageView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  _images.length,
                  (index) {
                    return Column(
                      children: [
                        SizedBox(
                          width: screenWidth / 1.1,
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: const LinearGradient(
                                      colors: [Colors.purple, Colors.blue],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CachedNetworkImage(
                                    height: 250,
                                    fit: BoxFit.contain,
                                    imageUrl:
                                        "${MyConfig().server}/barterit/assets/items/${widget.useritem.itemId}.${index + 1}.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                Text(
                  widget.useritem.itemBrand.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.useritem.itemName.toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(6),
                },
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "Item Type",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          widget.useritem.itemType.toString(),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "Description",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          widget.useritem.itemDesc.toString(),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "Price",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          "RM ${double.parse(widget.useritem.itemPrice.toString()).toStringAsFixed(2)}",
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "Item Interest",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          widget.useritem.itemInterest.toString(),
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "Location",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          "${widget.useritem.itemLocality}/${widget.useritem.itemState}",
                        ),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      const TableCell(
                        child: Text(
                          "Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      TableCell(
                        child: Text(
                          df.format(DateTime.parse(
                              widget.useritem.itemDate.toString())),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (widget.user.id == null ||
              widget.user.id ==
                  "na") // Conditionally show the login message if the user is not logged in
            Column(
              children: [
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    'Please login to proceed with buying or trading.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          if (widget.user.id != null &&
              widget.user.id !=
                  "na") // Conditionally show the buttons if the user is logged in and not "na"
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      buyItem();
                    },
                    child: const Text("Buy"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _tradeItem();
                    },
                    child: const Text("Trade"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void buyItem() {
    if (widget.user.id == null) {
      // Prompt user to log in
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please log in to buy items.")),
      );
      return;
    }

    if (widget.user.id.toString() == widget.useritem.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User cannot buy their own item")),
      );
      return;
    }

    if (double.parse(widget.useritem.itemPrice.toString()) == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            title: const Text(
              "Cannot Buy",
              style: TextStyle(),
            ),
            content: const Text("This item cannot be bought."),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            title: const Text(
              "Buy Item",
              style: TextStyle(),
            ),
            content: const Text("Are you sure you want to buy this item?"),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  // Pass the item price and user balance to the PaymentScreen
                  double itemPrice =
                      double.parse(widget.useritem.itemPrice.toString());
                  double userBalance = double.parse(widget.user.balance
                      .toString()); // Use the 'balance' field to get the user's wallet balance
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        itemPrice: itemPrice,
                        userBalance: userBalance,
                        user: widget.user,
                        useritem: widget.useritem,
                      ),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _tradeItem() {
    if (widget.user.id.toString() == widget.useritem.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User cannot trade their own item")),
      );
      return;
    }

    // Get the seller's phone number and item details
    final sellerPhoneNumber = widget.useritem.userPhone;
    final itemBrand = widget.useritem.itemBrand;
    final itemName = widget.useritem.itemName;
    print('Seller Phone Number: $sellerPhoneNumber');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text(
            "Trade Item",
            style: TextStyle(),
          ),
          content: const Text(
            "Are you sure you want to trade this item?",
            style: TextStyle(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                final message =
                    "I'm interested in trading your $itemBrand $itemName. Let's discuss further.";
                final url =
                    'https://wa.me/+6$sellerPhoneNumber?text=${Uri.encodeComponent(message)}';
                try {
                  // ignore: deprecated_member_use
                  if (await canLaunch(url)) {
                    // ignore: deprecated_member_use
                    await launch(url);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Failed to launch WhatsApp.")),
                    );
                  }
                } catch (e) {
                  print('Error launching WhatsApp: $e');
                  print(url);
                }
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void loadBalance() async {
    try {
      // Ensure the user is logged in
      if (widget.user.id == null || widget.user.id == "na") {
        return;
      }

      final response = await http.post(
        Uri.parse("${MyConfig().server}/barterit/php/fetch_balance.php"),
        body: {
          "userid": widget.user.id,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        double balance = double.parse(data['balance'].toString());

        setState(() {
          widget.user.balance =
              balance; // Update the user's balance in the user object
        });
      } else {
        showCustomSnackBar('Failed to fetch wallet balance.');
      }
    } catch (e) {
      print('Error: $e');
      showCustomSnackBar('Error while fetching wallet balance.');
    }
  }

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        elevation: 8,
        action: SnackBarAction(
          label: "Dismiss",
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ),
    );
  }
}
