import 'package:flutter/material.dart';
import 'package:pilldotrack/models/Medicine.dart';
import 'package:pilldotrack/services/DatabaseService.dart';

class MedicineList extends StatefulWidget {
  @override
  State<MedicineList> createState() => _MedicineListState();
}

class _MedicineListState extends State<MedicineList> {
  late Future<List<Medicine>> _medicines;

  @override
  void initState() {
    super.initState();
    _refreshMedicineList();
  }

  void _refreshMedicineList() {
    setState(() {
      _medicines = DatabaseService().getMedicines();
    });
  }

  void _deleteMedicine(int? id) async {
    if (id != null) {
      await DatabaseService().deleteMedicine(id);
      _refreshMedicineList(); // Recarga la lista
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Medicine>>(
        future: _medicines,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay medicamentos registrados.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final medicine = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(medicine.name),
                    subtitle: Text(
                      '${medicine.dose} - ${medicine.frequency}\nAlias: ${medicine.alias} - Permanente: ${medicine.isPermanent ? 'Sí' : 'No'}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMedicine(medicine.id),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}