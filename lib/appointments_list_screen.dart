import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:http/http.dart' as http;
import 'package:crm1/models/appointments_model.dart';

// DataGrid kaynağı
class AppointmentDataGridSource extends DataGridSource {
  List<DataGridRow> _appointmentData = [];

  AppointmentDataGridSource(List<Appointment> appointments) {
    _appointmentData = appointments.map<DataGridRow>((appointment) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'id', value: appointment.id),
        DataGridCell<String>(
            columnName: 'patientId', value: appointment.patientId),
        DataGridCell<DateTime>(columnName: 'date', value: appointment.date),
        DataGridCell<String>(
            columnName: 'procedureName', value: appointment.procedureName),
        DataGridCell<String>(columnName: 'notes', value: appointment.notes),
        DataGridCell<String>(columnName: 'status', value: appointment.status),
      ]);
    }).toList();
  }

  @override
  List<DataGridRow> get rows => _appointmentData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          alignment: Alignment.center,
          child: Text(cell.value.toString()),
        );
      }).toList(),
    );
  }
}

// Ana sayfa widget'ı
class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentsPage> {
  List<Appointment> _appointments = [];
  late AppointmentDataGridSource _appointmentDataGridSource;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    const apiUrl =
        'https://medicalcrmapi-eddka8a3a0cvgmbt.canadacentral-01.azurewebsites.net/api/Appointment/All';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('11195200:60-dayfreetrial'))}',
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        final appointments =
            jsonData.map((json) => Appointment.fromJson(json)).toList();
        setState(() {
          _appointments = appointments;
          _appointmentDataGridSource = AppointmentDataGridSource(_appointments);
          _isLoading = false;
        });
      } else {
        _showError('Randevu bilgileri yüklenemedi.');
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
        title: const Text('Randevular'),
        backgroundColor: Colors.pink,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Mevcut Randevular",
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      height: 400,
                      child: SfDataGrid(
                        source: _appointmentDataGridSource,
                        columns: <GridColumn>[
                          GridColumn(
                            columnName: 'id',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Randevu ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'patientId',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Hasta ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'date',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Tarih',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'procedureName',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'İşlem Tipi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'notes',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Notlar',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          GridColumn(
                            columnName: 'status',
                            label: Container(
                              padding: const EdgeInsets.all(8.0),
                              alignment: Alignment.center,
                              child: const Text(
                                'Durum',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
