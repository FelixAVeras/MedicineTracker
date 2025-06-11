import 'package:flutter/material.dart';
import 'package:pilldotrack/models/Medicine.dart';
import 'package:pilldotrack/services/DatabaseService.dart';

// Clase de la pantalla para agregar un nuevo medicamento
class AddMedicinePage extends StatefulWidget {
  // Constructor con una clave opcional
  const AddMedicinePage({Key? key}) : super(key: key);

  @override
  _AddMedicineScreenState createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicinePage> {
  // Controladores para los campos de texto del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _doseController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();

  // Variable de estado para el booleano 'isPermanent'
  bool _isPermanent = false;

  // Clave global para el formulario, usada para la validación
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Es importante liberar los controladores cuando el widget es desechado
    _nameController.dispose();
    _doseController.dispose();
    _frequencyController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  // Método para guardar el medicamento
  Future<void> _saveMedicine() async {
    // Valida el formulario usando la clave global
    if (_formKey.currentState!.validate()) {
      // Si el formulario es válido, crea un nuevo objeto Medicine
      final newMedicine = Medicine(
        name: _nameController.text,
        dose: _doseController.text,
        frequency: _frequencyController.text,
        alias: _aliasController.text,
        isPermanent: _isPermanent,
      );

      try {
        // Inserta el medicamento en la base de datos usando el DatabaseService
        await DatabaseService().insertMedicine(newMedicine);

        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Medicamento guardado con éxito!')),
        );

        await DatabaseService().getMedicines();

        // Vuelve a la pantalla anterior
        Navigator.pop(context, true); // Pasa 'true' para indicar que se realizó un cambio
      } catch (e) {
        // Maneja cualquier error que ocurra durante la inserción
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar el medicamento: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Medicamento'),
      ),
      body: SingleChildScrollView( // Permite el scroll si el contenido excede la pantalla
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Asigna la clave al formulario
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Estira los elementos horizontalmente
            children: <Widget>[
              // Campo para el nombre del medicamento
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Medicamento',
                  border: OutlineInputBorder(), // Borde de entrada
                  prefixIcon: Icon(Icons.medical_services), // Icono decorativo
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce el nombre del medicamento';
                  }
                  return null; // Retorna null si la validación es exitosa
                },
              ),
              const SizedBox(height: 16.0), // Espacio entre campos

              // Campo para la dosis
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: 'Dosis (ej. 2 tabletas)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.colorize),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la dosis';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo para la frecuencia
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: 'Frecuencia (ej. cada 8 horas)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.access_time),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce la frecuencia';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Campo para el alias
              TextFormField(
                controller: _aliasController,
                decoration: const InputDecoration(
                  labelText: 'Alias (ej. Pastilla para el dolor de cabeza)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un alias';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Switch para "Es Permanente"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Es Permanente',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Switch(
                    value: _isPermanent,
                    onChanged: (bool value) {
                      setState(() {
                        _isPermanent = value; // Actualiza el estado del switch
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.primary, // Color del switch activo
                  ),
                ],
              ),
              const SizedBox(height: 24.0),

              // Botón para guardar el medicamento
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text('Guardar Medicamento'),
                onPressed: _saveMedicine, // Llama a la función para guardar
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  textStyle: const TextStyle(fontSize: 18.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0), // Bordes redondeados
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary, // Usa el color primario del tema
                  foregroundColor: Theme.of(context).colorScheme.onPrimary, // Color del texto/icono
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}