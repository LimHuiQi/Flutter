class User {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? password;
  String? datereg;
  late double balance; // Mark 'balance' as late
  String? dateupdate;
  String?
      imageUrl; // Add the 'imageUrl' property to store the profile image URL

  User({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.password,
    this.datereg,
    double? balance, // Update the parameter type to double?
    this.dateupdate,
    this.imageUrl,
  }) : balance = balance ??
            0; // Initialize balance using the provided value or default to 0

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    password = json['password'];
    datereg = json['datereg'];
    balance = (json['balance'] ?? 0)
        .toDouble(); // Convert 'balance' to double if not null, else default to 0
    dateupdate = json['dateupdate'];
    imageUrl = json['imageUrl']; // Set 'imageUrl' from JSON data
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['phone'] = phone;
    data['password'] = password;
    data['datereg'] = datereg;
    data['balance'] = balance; // Include 'balance' in the JSON data
    data['dateupdate'] = dateupdate;
    data['imageUrl'] = imageUrl; // Include 'imageUrl' in the JSON data
    return data;
  }
}
