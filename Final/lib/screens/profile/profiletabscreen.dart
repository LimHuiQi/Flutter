import 'dart:convert';
import 'dart:io';
import 'package:barterit/myconfig.dart';
import 'package:barterit/screens/profile/buyorderscreen.dart';
import 'package:barterit/screens/profile/sellorderscreen.dart';
import 'package:barterit/screens/profile/walletscreen.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/screens/profile/loginscreen.dart';
import 'package:barterit/screens/profile/registrationscreen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;

  const ProfileTabScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late double screenHeight, screenWidth;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  void dispose() {
    // Cancel any ongoing asynchronous operations, e.g., timers, animations, streams, etc.
    // Clean up any resources here...
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    loadProfileImage();

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.25,
              width: screenWidth,
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(4),
                      width: screenWidth * 0.4,
                      child: InkWell(
                        onTap: _updateImageDialog, // Add the onTap callback
                        child: _buildAvatar(),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.name.toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          const SizedBox(height: 10),
                          Text(widget.user.email.toString()),
                          const SizedBox(height: 5),
                          Text(widget.user.datereg.toString()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (widget.user.id != null && widget.user.id != "na")
              Container(
                width: screenWidth,
                alignment: Alignment.center,
                color: Theme.of(context).colorScheme.background,
                child: const Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                  child: Text(
                    "BIT WALLET & ORDERS",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView(
                children: [
                  if (widget.user.id != null && widget.user.id != "na")
                    MaterialButton(
                      onPressed: _wallet,
                      child: const Text("Wallet Details"),
                    ),
                  if (widget.user.id != null && widget.user.id != "na")
                    MaterialButton(
                      onPressed: _sellerOrders,
                      child: const Text("Sales"),
                    ),
                  if (widget.user.id != null && widget.user.id != "na")
                    MaterialButton(
                      onPressed: _buyerOrders,
                      child: const Text("Purchases"),
                    ),
                  Container(
                    width: screenWidth,
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.background,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                      child: Text(
                        "PROFILE SETTINGS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (widget.user.id == null || widget.user.id == "na")
                    MaterialButton(
                      onPressed: _register,
                      child: const Text("Register"),
                    ),
                  if (widget.user.id == null || widget.user.id == "na")
                    MaterialButton(
                      onPressed: _login,
                      child: const Text("Login"),
                    ),
                  if (widget.user.id != null && widget.user.id != "na")
                    MaterialButton(
                      onPressed: _updateProfileDialog,
                      child: const Text("Edit Profile"),
                    ),
                  if (widget.user.id != null && widget.user.id != "na")
                    MaterialButton(
                      onPressed: _changePassDialog,
                      child: const Text("Change Password"),
                    ),
                  MaterialButton(
                    onPressed: _logout,
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _register() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
    );
  }

  void _login() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _wallet() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalletScreen(
          user: widget.user,
          balance: widget.user.balance,
        ),
      ),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Call the logout method
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  void _sellerOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => SellOrderScreen(user: widget.user)),
    );
  }

  void _buyerOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BuyOrderScreen(user: widget.user)),
    );
  }

  void _updateProfileDialog() {
    _nameController.text = widget.user.name.toString();
    _emailController.text = widget.user.email.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          title: const Text(
            "Edit Profile",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Update",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                String newname = _nameController.text;
                String newphone = _phoneController.text;
                String newemail = _emailController.text;
                _updateProfile(newname, newphone, newemail);
              },
            ),
            TextButton(
              child: const Text(
                "Cancel",
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

  void _updateProfile(String newname, String newphone, String newemail) {
    http.post(Uri.parse("${MyConfig().server}/barterit/php/update_profile.php"),
        body: {
          "userid": widget.user.id,
          "newname": newname,
          "newphone": newphone,
          "newemail": newemail, // Include the new email in the request body
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        showCustomSnackBar('Profile updated successfully.');
        setState(() {
          widget.user.name = newname;
          widget.user.phone = newphone;
          widget.user.email = newemail; // Update the email in the user object
        });
      } else {
        showCustomSnackBar('Failed to update profile. Please try again.');
      }
    });
  }

  Future<void> loadProfileData() async {
    // Check if the widget is still mounted in the tree
    if (!mounted) {
      return;
    }

    // Check if the user has already logged in or not
    if (widget.user.id == null || widget.user.id == "na") {
      setState(() {
        widget.user.imageUrl = null; // User not logged in, no image available
        widget.user.phone = null; // User not logged in, no phone available
      });
      return;
    }

    // Construct the image URL
    String imageUrl =
        "${MyConfig().server}/barterit/assets/profile/${widget.user.id}.png";

    try {
      // Fetch the profile image
      final imageResponse = await http.get(Uri.parse(imageUrl));

      // Fetch the phone number
      final phoneResponse = await http.post(
        Uri.parse("${MyConfig().server}/barterit/php/get_phone.php"),
        body: {
          "userid": widget.user.id,
        },
      );

      // Check again if the widget is still mounted before updating the state
      if (!mounted) {
        return;
      }

      if (imageResponse.statusCode == 200) {
        // Show the user's profile image fetched from the server
        setState(() {
          widget.user.imageUrl =
              imageUrl; // Update the user object with the new image URL
        });
      } else {
        // Show default profile picture if the image is not available or there's an error
        setState(() {
          widget.user.imageUrl = null;
        });
      }

      if (phoneResponse.statusCode == 200) {
        // Parse the phone number from the response
        var jsonData = jsonDecode(phoneResponse.body);
        String phone = jsonData['phone'] ??
            ""; // If phone is null, set it to an empty string

        setState(() {
          widget.user.phone =
              phone; // Update the user object with the new phone number
        });
      } else {
        // Set phone to null if there's an error fetching the phone number
        setState(() {
          widget.user.phone = null;
        });
      }
    } catch (e) {
      // Show default profile picture and set phone to null if there's an error fetching data
      print('Error: $e');
      setState(() {
        widget.user.imageUrl = null;
        widget.user.phone = null;
      });
    }
  }

  void _changePassDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Change Password?",
            style: TextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _oldpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: _newpasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Change",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _changePassword();
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

  void _changePassword() {
    http.post(
      Uri.parse("${MyConfig().server}/barterit/php/update_profile.php"),
      body: {
        "userid": widget.user.id,
        "oldpass": _oldpasswordController.text,
        "newpass": _newpasswordController.text,
      },
    ).then((response) {
      var jsondata = jsonDecode(response.body);
      if (response.statusCode == 200 && jsondata['status'] == 'success') {
        showCustomSnackBar('Password changed successfully.');
        setState(() {});
      } else {
        showCustomSnackBar('Failed to change password.');
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

  void _updateImageDialog() {
    if (widget.user.email == "na") {
      showCustomSnackBar('Please login/register');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Select from"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _galleryPicker();
                },
                icon: const Icon(Icons.browse_gallery),
                label: const Text("Gallery"),
              ),
              TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                  _cameraPicker();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Camera"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _galleryPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 1200,
      maxWidth: 800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      _updateProfileImage();
      setState(() {});
    }
  }

  Future<void> _updateProfileImage() async {
    if (_image == null) {
      showCustomSnackBar('No image available');
      return;
    }

    String base64Image = base64Encode(_image!.readAsBytesSync());
    try {
      final response = await http.post(
        Uri.parse("${MyConfig().server}/barterit/php/update_profile.php"),
        body: {
          "userid": widget.user.id.toString(),
          "image": base64Image,
        },
      );

      var jsonData = jsonDecode(response.body);
      if (response.statusCode == 200 && jsonData['status'] == 'success') {
        // Fetch the updated image from the server before updating the UI
        String imageUrl =
            "${MyConfig().server}/barterit/assets/profile/${widget.user.id}.png";
        setState(() {
          widget.user.imageUrl =
              imageUrl; // Update the user object with the new image URL
        });

        showCustomSnackBar('Profile image updated successfully');
      } else {
        showCustomSnackBar('Failed to update profile image');
      }
    } catch (e) {
      print('Error: $e');
      showCustomSnackBar('Error while updating profile image');
    }
  }

  Widget _buildAvatar() {
    // Check if the user already has a profile image available
    if (_image != null) {
      // Show the updated image if available
      return CircleAvatar(
        backgroundImage: FileImage(_image!),
        radius: 80,
      );
    } else if (widget.user.imageUrl != null &&
        widget.user.imageUrl!.isNotEmpty) {
      // Show user's profile picture fetched from the server
      return CircleAvatar(
        backgroundImage: NetworkImage(widget.user.imageUrl!),
        radius: 80,
      );
    } else {
      // Show default profile picture for not logged-in users or if the user has no image
      return const CircleAvatar(
        backgroundImage: AssetImage("assets/images/profile.png"),
        radius: 80,
      );
    }
  }

  Future<void> loadProfileImage() async {
    // Check if the widget is still mounted in the tree
    if (!mounted) {
      return;
    }

    // Check if the user has already logged in or not
    if (widget.user.id == null || widget.user.id == "na") {
      setState(() {
        widget.user.imageUrl = null; // User not logged in, no image available
      });
      return;
    }

    // Construct the image URL
    String imageUrl =
        "${MyConfig().server}/barterit/assets/profile/${widget.user.id}.png";

    try {
      final response = await http.get(Uri.parse(imageUrl));

      // Check again if the widget is still mounted before updating the state
      if (!mounted) {
        return;
      }

      if (response.statusCode == 200) {
        // Show the user's profile image fetched from the server
        setState(() {
          widget.user.imageUrl =
              imageUrl; // Update the user object with the new image URL
        });
      } else {
        // Show default profile picture if the image is not available or there's an error
        setState(() {
          widget.user.imageUrl = null;
        });
      }
    } catch (e) {
      // Show default profile picture if there's an error fetching the image
      print('Error: $e');
      setState(() {
        widget.user.imageUrl = null;
      });
    }
  }
}
