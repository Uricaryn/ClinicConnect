import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/patient_model.dart';

class PatientService {
  final String apiUrl =
      'https://medicalcrmapi-eddka8a3a0cvgmbt.canadacentral-01.azurewebsites.net/api/Patient/All'; // API URL'nizi buraya ekleyin

  // API'ye erişim için kullanıcı adı ve şifre
  final String username = '11195200'; // API username
  final String apiPassword = '60-dayfreetrial'; // API password

  Future<List<Patient>> fetchPatients() async {
    // Kullanıcı adı ve şifreyi birleştir ve base64 ile kodla
    final credentials = '$username:$apiPassword';
    final encodedCredentials = base64Encode(utf8.encode(credentials));

    // API'ye GET isteği gönderirken Authorization başlığını ekleyin
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Basic $encodedCredentials',
      },
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Patient.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }
}
