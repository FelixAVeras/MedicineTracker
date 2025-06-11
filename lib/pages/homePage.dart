import 'package:flutter/material.dart';
import 'package:pilldotrack/models/Medicine.dart';
import 'package:pilldotrack/pages/addMedicationPage.dart';
import 'package:pilldotrack/partials/MedicineList.dart';
import 'package:pilldotrack/services/DatabaseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Medicamentos'),
        centerTitle: false,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.pinkAccent),
              child: Text('PildoTracker'),
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: const Text('Historial'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_emergency),
              title: const Text('Contactos de Emergencia'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: MedicineList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddMedicinePage())),
        label: const Text('Agregar Medicamento'),
        icon: const Icon(Icons.add)
      ),
    );
  }
}