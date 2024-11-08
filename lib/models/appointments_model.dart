// Randevu modeli
class Appointment {
  final String id;
  final String patientId;
  final DateTime date;
  final String procedureName;
  final String notes;
  final String status;

  Appointment({
    required this.id,
    required this.patientId,
    required this.date,
    required this.procedureName,
    required this.notes,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      date: DateTime.parse(json['date'] ??
          ''), // This should work fine with the provided date format
      procedureName: json['procedureName']
          .toString(), // Convert to string if it's an integer
      notes: json['notes'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
