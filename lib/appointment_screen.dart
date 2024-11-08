import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/patient_model.dart';
import 'models/enum_models.dart'; // ProcedureType enum import
import 'package:http/http.dart' as http;

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  List<Patient> _patients = [];
  String? _selectedPatientId;
  ProcedureType? _selectedProcedureType;
  DateTime? _selectedDateTime;
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    try {
      final patients = await PatientService().fetchPatients();
      setState(() {
        _patients = patients;
      });
    } catch (e) {
      _showError('Hasta bilgileri yüklenemedi: $e');
    }
  }

  Future<void> _createAppointment() async {
    const apiUrl =
        'https://medicalcrmapi-eddka8a3a0cvgmbt.canadacentral-01.azurewebsites.net/api/Appointment/Create';

    final dateTime = _selectedDateTime?.toUtc().toIso8601String() ?? '';
    final notes = _notesController.text;
    final status = _statusController.text;
    final patientId = _selectedPatientId;
    final procedureCode = _selectedProcedureType?.toCode();

    if (patientId == null || procedureCode == null) {
      _showError('Hasta veya prosedür türü seçilmedi');
      return;
    }

    final appointmentData = {
      'patientId': patientId,
      'date': dateTime,
      'procedureName': procedureCode,
      'notes': notes,
      'status': status,
    };

    const credentials = '11195200:60-dayfreetrial';
    final encodedCredentials = base64Encode(utf8.encode(credentials));

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Basic $encodedCredentials',
        },
        body: jsonEncode(appointmentData),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final message = responseBody['message'] ?? 'Randevu oluşturulamadı';
        _showSuccess('Randevu başarıyla oluşturuldu: $message');
      } else {
        final errorMessage = responseBody['message'] ?? 'Bir hata oluştu';
        _showError('Randevu oluşturulamadı: $errorMessage');
      }
    } catch (e) {
      _showError('Bir hata oluştu: $e');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Randevu Oluştur'),
        backgroundColor: Colors.pink, // Pembe renk
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildPatientDropdown(),
              const SizedBox(height: 16),
              _buildProcedureTypeDropdown(),
              const SizedBox(height: 16),
              _buildDateTimeField(),
              const SizedBox(height: 16),
              _buildNotesField(),
              const SizedBox(height: 16),
              _buildStatusField(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _createAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Pembe arka plan rengi
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Randevu Oluştur',
                  style: TextStyle(
                    color: Colors.white, // Beyaz metin rengi
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButton<String>(
        hint: const Text('Hasta Seçiniz',
            style: TextStyle(color: Colors.black54)),
        value: _selectedPatientId,
        items: _patients.map((patient) {
          return DropdownMenuItem<String>(
            value: patient.id,
            child: Text(patient.fullName),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedPatientId = newValue;
          });
        },
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildProcedureTypeDropdown() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButton<ProcedureType>(
        hint: const Text('Prosedür Türü Seçiniz',
            style: TextStyle(color: Colors.black54)),
        value: _selectedProcedureType,
        items: ProcedureType.values.map((procedure) {
          return DropdownMenuItem<ProcedureType>(
            value: procedure,
            child: Text(procedure.name),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedProcedureType = newValue;
          });
        },
        isExpanded: true,
        underline: const SizedBox(),
      ),
    );
  }

  Widget _buildDateTimeField() {
    return GestureDetector(
      onTap: () async {
        final selectedDateTime = await _showDateTimePicker(context);
        if (selectedDateTime != null) {
          setState(() {
            _selectedDateTime = selectedDateTime;
          });
        }
      },
      child: AbsorbPointer(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: TextEditingController(
                text: _selectedDateTime != null
                    ? _selectedDateTime!.toLocal().toString()
                    : ''),
            decoration: const InputDecoration(
              labelText: 'Randevu Tarihi ve Saati',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              labelStyle: TextStyle(color: Colors.pink), // Pembe renk
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _notesController,
        decoration: const InputDecoration(
          labelText: 'Notlar',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.pink), // Pembe renk
        ),
        maxLines: 4,
      ),
    );
  }

  Widget _buildStatusField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _statusController,
        decoration: const InputDecoration(
          labelText: 'Durum',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16),
          labelStyle: TextStyle(color: Colors.pink), // Pembe renk
        ),
      ),
    );
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(initialDate),
      );

      if (pickedTime != null) {
        return DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      }
    }
    return null;
  }
}
