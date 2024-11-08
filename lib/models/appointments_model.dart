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
      id: json['Id'],
      patientId: json['PatientId'],
      date: DateTime.parse(json['Date']),
      procedureName: json['ProcedureName'],
      notes: json['Notes'],
      status: json['Status'],
    );
  }
}
