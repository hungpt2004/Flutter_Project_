import 'package:flutter/material.dart';
import 'package:mynote_application/view/scenic_screen.dart';
import 'package:mynote_application/view/speciality_screen.dart';
import 'city_screen.dart';
import 'license_screen.dart';
import 'university_screen.dart';

class InterfaceUser extends StatelessWidget {
  final int provinceId;

  const InterfaceUser({Key? key, required this.provinceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Province Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCard(
              context,
              title: 'City',
              icon: Icons.location_city,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CityScreen(provinceId: provinceId),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              title: 'University',
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UniversityScreen(provinceId: provinceId),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              title: 'Scenics',
              icon: Icons.landscape,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScenicScreen(provinceId: provinceId),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              title: 'Specialities',
              icon: Icons.local_fire_department,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecialityScreen(provinceId: provinceId),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              title: 'Licenses',
              icon: Icons.assignment,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LicenseScreen(provinceId: provinceId),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(
          icon,
          size: 36,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
