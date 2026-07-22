import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/datasources/athlete_firestore_datasource.dart';
import '../../data/models/athlete_model.dart';

class AthleteFormPage extends StatefulWidget {
  final AthleteModel? athlete;
  final VoidCallback onSaved;

  const AthleteFormPage({
    super.key,
    this.athlete,
    required this.onSaved,
  });

  @override
  State<AthleteFormPage> createState() => _AthleteFormPageState();
}

class _AthleteFormPageState extends State<AthleteFormPage> {
  late TextEditingController _idController;
  late TextEditingController _namesController;

  late AthleteFirestoreDatasource _datasource;

  String? _selectedClassification;
  String? _selectedCategory;
  String? _selectedWeight;
  String? _selectedGender;
  String? _selectedAcademy;

  late Future<List<String>> _classificationsFuture;
  late Future<List<String>> _categoriesFuture;
  late Future<List<String>> _weightsFuture;
  late Future<List<String>> _gendersFuture;
  late Future<Map<String, String>> _academiesFuture;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _datasource = AthleteFirestoreDatasource(FirebaseFirestore.instance);

    _isEditing = widget.athlete != null;
    _idController = TextEditingController(text: widget.athlete?.id ?? '');
    _namesController = TextEditingController(text: widget.athlete?.names ?? '');

    _selectedClassification = widget.athlete?.classification?.isNotEmpty == true ? widget.athlete?.classification : null;
    _selectedCategory = widget.athlete?.category?.isNotEmpty == true ? widget.athlete?.category : null;
    _selectedWeight = widget.athlete?.weight?.isNotEmpty == true ? widget.athlete?.weight : null;
    _selectedGender = widget.athlete?.gender?.isNotEmpty == true ? widget.athlete?.gender : null;
    _selectedAcademy = widget.athlete?.academy?.isNotEmpty == true ? widget.athlete?.academy : null;

    _classificationsFuture = _datasource.getClassifications();
    _categoriesFuture = _datasource.getCategories();
    _weightsFuture = _datasource.getWeights();
    _gendersFuture = _datasource.getGenders();
    _academiesFuture = _datasource.getAcademies();
  }

  @override
  void dispose() {
    _idController.dispose();
    _namesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.athlete == null ? 'Nuevo Deportista' : 'Editar Deportista'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identificación (Cédula)
            TextField(
              controller: _idController,
              enabled: !_isEditing,
              decoration: InputDecoration(
                labelText: 'Identificación (Cédula)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Nombres
            TextField(
              controller: _namesController,
              decoration: InputDecoration(
                labelText: 'Nombres',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Clasificación
            FutureBuilder<List<String>>(
              future: _classificationsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final classifications = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedClassification,
                  items: classifications.map((classification) {
                    return DropdownMenuItem(
                      value: classification,
                      child: Text(classification),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedClassification = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Clasificación',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Categoría
            FutureBuilder<List<String>>(
              future: _categoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final categories = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Categoría',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Peso
            FutureBuilder<List<String>>(
              future: _weightsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final weights = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedWeight,
                  items: weights.map((weight) {
                    return DropdownMenuItem(
                      value: weight,
                      child: Text(weight),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedWeight = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Peso (Kg)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Género
            FutureBuilder<List<String>>(
              future: _gendersFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final genders = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedGender,
                  items: genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Género',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Academia
            FutureBuilder<Map<String, String>>(
              future: _academiesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                final academies = snapshot.data ?? {};
                return DropdownButtonFormField<String>(
                  value: _selectedAcademy,
                  items: academies.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAcademy = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Academia',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Botones
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_idController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('La cédula es requerida'),
                          ),
                        );
                        return;
                      }

                      if (_namesController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Los nombres son requeridos'),
                          ),
                        );
                        return;
                      }

                      final newAthlete = AthleteModel(
                        id: _idController.text,
                        names: _namesController.text,
                        classification: _selectedClassification ?? '',
                        category: _selectedCategory ?? '',
                        weight: _selectedWeight ?? '',
                        gender: _selectedGender ?? '',
                        academy: _selectedAcademy ?? '',
                      );

                      bool success;
                      if (widget.athlete == null) {
                        success = await _datasource.createAthlete(newAthlete);
                      } else {
                        success = await _datasource.updateAthlete(newAthlete);
                      }

                      if (success) {
                        widget.onSaved();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al guardar el deportista'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: EliteMartialColors.secondaryContainer,
                    ),
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
