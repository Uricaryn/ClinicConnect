class Patient {
  final String id;
  final String firstName;
  final String lastName;
  final DateTime dateOfBirth;
  final String email;
  final String phoneNumber;
  final String address;
  final String notes;

  Patient({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.notes,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      notes: json['notes'],
    );
  }

  String get fullName => '$firstName $lastName';
}
