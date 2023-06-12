import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barterit/models/user.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:barterit/myconfig.dart';

class AddScreen extends StatefulWidget {
  final User user;

  const AddScreen({super.key, required this.user});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  File? _image;
  List<File> selectedImages = [];

  var pathAsset = "assets/images/camera.png";
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _itembrandEditingController =
      TextEditingController();
  final TextEditingController _itemnameEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  final TextEditingController _iteminterestEditingController =
      TextEditingController();
  final TextEditingController _itemstateEditingController =
      TextEditingController();
  final TextEditingController _itemlocalEditingController =
      TextEditingController();
  String selectedType = "Electronics";
  List<String> itemlist = [
    "Electronics",
    "Fashion and clothing",
    "Home and Furniture",
    "Books and Media",
    "Sports and Fitness",
    "Vehicles and Automotive",
    "Collectibles",
    "Toys and Games",
    "Arts and Crafts",
    "Music and Instruments",
    "Health and Beauty",
    "Garden and Outdoor",
  ];
  late Position _currentPosition;

  String curaddress = "";
  String curstate = "";
  String itemlat = "";
  String itemlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text("Insert New Item"), actions: [
        IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh))
      ]),
      body: Column(children: [
        Flexible(
            flex: 4,
            // height: screenHeight / 2.5,
            // width: screenWidth,
            child: GestureDetector(
              onTap: () {
                _selectMultipleImages();
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectedImages.isEmpty
                    ? Image.asset(pathAsset, fit: BoxFit.contain)
                    : ListView.builder(
                        itemCount: selectedImages.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.file(
                            File(selectedImages[index].path),
                            height: 200,
                            width: 200,
                          );
                        }),
              ),
            )),
        Expanded(
          flex: 6,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          height: 50,
                          child: DropdownButton(
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: itemlist.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 2)
                                ? "Item brand must be longer than 2"
                                : null,
                            onFieldSubmitted: (v) {},
                            controller: _itembrandEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Item Brand',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.tag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Item name must be longer than 3"
                                : null,
                            onFieldSubmitted: (v) {},
                            controller: _itemnameEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Item Name',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.title),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        //maxLines: 2,
                        controller: _itemdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "Item interest must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        //maxLines: 2,
                        controller: _iteminterestEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Interest',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current State"
                                : null,
                            enabled: false,
                            controller: _itemstateEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current State',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.flag),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
                            textInputAction: TextInputAction.next,
                            enabled: false,
                            validator: (val) => val!.isEmpty || (val.length < 3)
                                ? "Current Locality"
                                : null,
                            controller: _itemlocalEditingController,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Current Locality',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.map),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                      ),
                    ]),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text("Insert Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  // Future<void> _selectFromCamera() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.pickImage(
  //     source: ImageSource.gallery, //choose from gallery/camera file
  //     maxHeight: 1200,
  //     maxWidth: 800,
  //   );

  //   if (pickedFile != null) {
  //     _image = File(pickedFile.path);
  //     cropImage();
  //   } else {
  //     print('No image selected.');
  //   }
  // }

  Future<void> _selectMultipleImages() async {
    final picker = ImagePicker();
    final selectedImageList = await picker.pickMultiImage();

    if (selectedImageList != null) {
      List<File> selectedImages = selectedImageList
          .map((selectedImage) => File(selectedImage.path))
          .toList();
      List<File>? croppedImages = await cropImage(selectedImages);

      if (croppedImages != null) {
        setState(() {
          this.selectedImages.addAll(croppedImages);
        });
      } else {
        print('No images selected or cropped.');
      }
    } else {
      print('No images selected.');
    }
  }

  Future<List<File>?> cropImage(List<File> images) async {
    List<File> croppedImages = [];
    for (var image in images) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          //CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          //CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
        ],
      );

      if (croppedFile != null) {
        File imageFile = File(croppedFile.path);
        croppedImages.add(imageFile);
      }
    }
    return croppedImages.isNotEmpty ? croppedImages : null;
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      showCustomSnackBar("Check your input");
    }
    if (selectedImages.isEmpty) {
      showCustomSnackBar("Please take picture");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: const Text(
              "Insert your item?",
              style: TextStyle(),
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  insertItem();
                  //registerUser();
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

  void insertItem() async {
    List<String> imageList = [];
    String itembrand = _itembrandEditingController.text;
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String iteminterest = _iteminterestEditingController.text;
    String state = _itemstateEditingController.text;
    String locality = _itemlocalEditingController.text;
    //String base64Image = base64Encode(_image!.readAsBytesSync());
    for (var image in selectedImages) {
      List<int> imageBytes = await image.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      imageList.add(base64Image);
    }
    http.post(Uri.parse("${MyConfig().server}/barterit/php/add_item.php"),
        body: {
          "userid": widget.user.id.toString(),
          "itembrand": itembrand,
          "itemname": itemname,
          "itemdesc": itemdesc,
          "iteminterest": iteminterest,
          "itemtype": selectedType,
          "latitude": itemlat,
          "longitude": itemlong,
          "state": state,
          "locality": locality,
          "image": jsonEncode(imageList)
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          showCustomSnackBar("Insert Success");
        } else {
          showCustomSnackBar("Insert Failed");
        }
        Navigator.pop(context);
      } else {
        showCustomSnackBar("Insert Failed");
        Navigator.pop(context);
      }
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _itemlocalEditingController.text = "Changlun";
      _itemstateEditingController.text = "Kedah";
      itemlat = "6.443455345";
      itemlong = "100.05488449";
    } else {
      _itemlocalEditingController.text = placemarks[0].locality.toString();
      _itemstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      itemlat = _currentPosition.latitude.toString();
      itemlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }

  void showCustomSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
    ));
  }
}
