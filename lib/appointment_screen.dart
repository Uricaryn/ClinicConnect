import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/patient_service.dart';
import '../models/patient_model.dart';
import 'models/enum_models.dart'; // ProcedureType enum import
import 'package:http/http.dart' as http;

class AppointmentPage extends StatefulWidget {
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
    final apiUrl =
        'http://uricaryn-001-site1.ltempurl.com/api/Appointment/Create';

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

    final credentials = '11195200:60-dayfreetrial';
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
      appBar: AppBar(title: const Text('Randevu Oluştur')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                child: const Text('Randevu Oluştur'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPatientDropdown() {
    return DropdownButton<String>(
      hint: const Text('Hasta Seçiniz'),
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
    );
  }

  Widget _buildProcedureTypeDropdown() {
    return DropdownButton<ProcedureType>(
      hint: const Text('Prosedür Türü Seçiniz'),
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
        child: TextField(
          controller: TextEditingController(
              text: _selectedDateTime != null
                  ? _selectedDateTime!.toLocal().toString()
                  : ''),
          decoration:
              const InputDecoration(labelText: 'Randevu Tarihi ve Saati'),
        ),
      ),
    );
  }

  Widget _buildNotesField() {
    return TextField(
      controller: _notesController,
      decoration: const InputDecoration(labelText: 'Notlar'),
      maxLines: 3,
    );
  }

  Widget _buildStatusField() {
    return TextField(
      controller: _statusController,
      decoration: const InputDecoration(labelText: 'Durum'),
    );
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context) async {
    final initialDate = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate == null) return null;

    final timeOfDay = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (timeOfDay == null) return null;

    return DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }
}
