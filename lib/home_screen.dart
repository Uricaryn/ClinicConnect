import 'package:crm1/main.dart';
import 'package:flutter/material.dart';
import 'appointment_screen.dart';
import 'appointments_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userName;

  const HomeScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F5), // Daha açık pembe arka plan
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        backgroundColor: Colors.pink, // Pembe arka plan rengi
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hoşgeldiniz başlığı
              Text(
                'Hoşgeldiniz, $userName!',
                style: const TextStyle(
                  color: Colors.pink, // Pembe başlık rengi
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              // Randevu Oluştur butonuna yönlendirme ekleniyor
              buildCardButton(
                context,
                title: 'Randevu Oluştur',
                icon: Icons.calendar_today,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppointmentPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              buildCardButton(
                context,
                title: 'Muayene Girişi',
                icon: Icons.local_hospital,
                onTap: () {
                  // Muayene girişi işlevi
                },
              ),
              const SizedBox(height: 20),
              buildCardButton(
                context,
                title: 'Hasta Bilgileri',
                icon: Icons.person,
                onTap: () {
                  // Hasta bilgileri işlevi
                },
              ),
              const SizedBox(height: 20),
              buildCardButton(
                context,
                title: 'Fiyat Listesi',
                icon: Icons.attach_money,
                onTap: () {
                  // Fiyat listesi işlevi
                },
              ),
              const SizedBox(height: 20),
              buildCardButton(
                context,
                title: 'Randevular',
                icon: Icons.note,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AppointmentsPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Ana ekrana (main.dart'a) geri yönlendirme
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const LoginScreen(), // MainScreen'e yönlendirir
                    ),
                    (Route<dynamic> route) =>
                        false, // Geriye dönülebilecek sayfa yok
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink, // Diğer butonlarla aynı renkte
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    color: Colors.white,
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

  // Kart butonunu oluşturan fonksiyon
  Widget buildCardButton(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4, // Kart gölgesi hafifletildi
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Köşeler daha yuvarlak
      ),
      color: Colors.white, // Kart rengi beyaz
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: Colors.pink, size: 28), // İkon rengi pembe
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.pink, // Başlık rengi pembe
            fontSize: 18, // Başlık font boyutu biraz küçültüldü
            fontWeight: FontWeight.w600, // Başlık kalınlığı biraz azaltıldı
          ),
        ),
        trailing: const Icon(Icons.arrow_forward,
            color: Colors.pink), // Ok işareti rengi pembe
        onTap: onTap,
      ),
    );
  }
}
