class UserDetails {
  UserDetails({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.birthdate,
    this.address,
    this.username,
    this.countryCode,
  });

  UserDetails.fromJson(Map<String,dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phoneNumber = json['mobile'] ?? '';
    birthdate = json['date_of_birth'];
    address = json['address'];
    username = json['username'];
    countryCode = json['country_code'];
  }

  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  int? birthdate;
  String? address;
  String? username;
  String? countryCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['first_name'] = firstName;
    map['last_name'] = lastName;
    map['email'] = email;
    map['mobile'] = phoneNumber;
    map['date_of_birth'] = birthdate;
    map['address'] = address;
    map['username'] = username;
    map['country_code'] = countryCode;

    return map;
  }
}
