import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';

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
                    tradeItem();
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
                  // Handle buy logic here
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

  void tradeItem() {
    if (widget.user.id.toString() == widget.useritem.userId.toString()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User cannot trade their own item")),
      );
      return;
    }
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
              onPressed: () {
                Navigator.of(context).pop();
                // Handle trade logic here
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
