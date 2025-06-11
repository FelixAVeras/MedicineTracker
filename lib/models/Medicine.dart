class Medicine {
  int? id; // El ID será autogenerado por la base de datos
  String name;
  String dose;
  String frequency;
  String alias;
  bool isPermanent;

  Medicine({
    this.id,
    required this.name,
    required this.dose,
    required this.frequency,
    required this.alias,
    required this.isPermanent,
  });

  // Convierte un objeto Medicine en un Map.
  // Útil para insertar o actualizar datos en la base de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'frequency': frequency,
      'alias': alias,
      'isPermanent': isPermanent ? 1 : 0, // SQLite no tiene booleans, usa 1 o 0
    };
  }

  // Crea un objeto Medicine a partir de un Map.
  // Útil para leer datos de la base de datos.
  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dose: map['dose'],
      frequency: map['frequency'],
      alias: map['alias'],
      isPermanent: map['isPermanent'] == 1,
    );
  }

  @override
  String toString() {
    return 'Medicine{id: $id, name: $name, dose: $dose, frequency: $frequency, alias: $alias, isPermanent: $isPermanent}';
  }
}