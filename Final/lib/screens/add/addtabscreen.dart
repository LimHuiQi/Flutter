import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';
import 'addscreen.dart';

class AddTabScreen extends StatefulWidget {
  final User user;
  const AddTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<AddTabScreen> createState() => _AddTabScreenState();
}

class _AddTabScreenState extends State<AddTabScreen> {
  late double screenHeight, screenWidth;
  late int axiscount = 2;
  String maintitle = "Own Item List";
  List<Item> itemList = <Item>[];
  int curPage = 1;
  int totalPages = 1;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    loadAddedItem(curPage);
    print("Add");
  }

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(maintitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          loadAddedItem(curPage);
        },
        child: itemList.isEmpty
            ? const Center(
                child: Text("No Data"),
              )
            : Column(children: [
                Container(
                  height: 24,
                  color: Colors.indigoAccent,
                  alignment: Alignment.center,
                  child: Text(
                    "$totalItems Items Found",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: axiscount,
                    children: List.generate(
                      itemList.length,
                      (index) {
                        return Card(
                          child: InkWell(
                            onLongPress: () {
                              onDeleteDialog(index);
                            },
                            child: Column(
                              children: [
                                CachedNetworkImage(
                                  width: screenWidth,
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      "${MyConfig().server}/barterit/assets/items/${itemList[index].itemId}.1.png",
                                  placeholder: (context, url) =>
                                      const LinearProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                                Text(
                                  itemList[index].itemBrand.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  itemList[index].itemName.toString(),
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: totalPages,
                    itemBuilder: (context, index) {
                      final pageNumber = index + 1;
                      final color =
                          pageNumber == curPage ? Colors.black : Colors.grey;
                      return TextButton(
                        onPressed: () {
                          loadAddedItem(pageNumber);
                        },
                        child: Text(
                          pageNumber.toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                ),
              ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (widget.user.id != "na") {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (content) => AddScreen(user: widget.user),
              ),
            );
            loadAddedItem(curPage);
          } else {
            showCustomSnackBar("Please login/register an account");
          }
        },
        child: const Text(
          "+",
          style: TextStyle(fontSize: 32),
        ),
      ),
    );
  }

  void loadAddedItem(int page) async {
    if (widget.user.id == "na") {
      setState(() {
        // titlecenter = "Unregistered User";
      });
      return;
    }

    final response = await http.post(
      Uri.parse("${MyConfig().server}/barterit/php/load_items.php"),
      body: {
        "userid": widget.user.id,
        "pageno": page.toString(),
      },
    );

    itemList.clear();

    if (response.statusCode == 200) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          itemList.add(Item.fromJson(v));
        });
        totalPages = int.parse(jsondata['numofpage']);
        totalItems = int.parse(jsondata['numberofresult']);
        print(itemList[0].itemName);
      }
      setState(() {
        curPage = page;
      });
    }
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
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

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          showCustomSnackBar("Delete Success");
          loadAddedItem(curPage);
        } else {
          showCustomSnackBar("Failed");
        }
      }
    });
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
