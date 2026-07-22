import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/datasources/athlete_firestore_datasource.dart';
import '../../data/models/athlete_model.dart';
import 'athlete_form_page.dart';

class AthletesManagementPage extends StatefulWidget {
  const AthletesManagementPage({super.key});

  @override
  State<AthletesManagementPage> createState() => _AthletesManagementPageState();
}

class _AthletesManagementPageState extends State<AthletesManagementPage> {
  late AthleteFirestoreDatasource _datasource;
  late Future<List<AthleteModel>> _athletesFuture;
  late Future<Map<String, String>> _academiesFuture;

  @override
  void initState() {
    super.initState();
    _datasource = AthleteFirestoreDatasource(FirebaseFirestore.instance);
    _academiesFuture = _datasource.getAcademies();
    _loadAthletes();
  }

  void _loadAthletes() {
    setState(() {
      _athletesFuture = _datasource.getAllAthletes();
    });
  }

  String _getAcademyName(String academyId, Map<String, String> academies) {
    return academies[academyId] ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Deportistas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AthleteFormPage(
                onSaved: _loadAthletes,
              ),
            ),
          ).then((_) => _loadAthletes());
        },
        backgroundColor: EliteMartialColors.secondaryContainer,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _academiesFuture,
        builder: (context, academiesSnapshot) {
          if (academiesSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final academies = academiesSnapshot.data ?? {};

          return FutureBuilder<List<AthleteModel>>(
            future: _athletesFuture,
            builder: (context, athletesSnapshot) {
              if (athletesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (athletesSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${athletesSnapshot.error}'),
                );
              }

              final athletes = athletesSnapshot.data ?? [];

              if (athletes.isEmpty) {
                return const Center(
                  child: Text('No hay deportistas registrados'),
                );
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Container(
                          color: EliteMartialColors.secondaryContainer,
                          width: constraints.maxWidth,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _buildHeaderCell('Cédula'),
                              ),
                              Expanded(
                                flex: 2,
                                child: _buildHeaderCell('Nombres'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildHeaderCell('Categoría'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildHeaderCell('Academia'),
                              ),
                              Expanded(
                                flex: 1,
                                child: _buildHeaderCell('Acciones'),
                              ),
                            ],
                          ),
                        ),
                        ...athletes.asMap().entries.map((entry) {
                          final index = entry.key;
                          final athlete = entry.value;
                          final isEven = index.isEven;
                          final academyName = _getAcademyName(athlete.academy, academies);
                          return Container(
                            color: isEven
                                ? EliteMartialColors.surfaceContainerLowest
                                : EliteMartialColors.surfaceContainer,
                            width: constraints.maxWidth,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: _buildCell(athlete.id),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: _buildCell(athlete.names),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _buildCell(athlete.category),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: _buildCell(academyName),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: PopupMenuButton(
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        child: const Text('Editar'),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AthleteFormPage(
                                                athlete: athlete,
                                                onSaved: _loadAthletes,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      PopupMenuItem(
                                        child: const Text('Eliminar'),
                                        onTap: () {
                                          _showDeleteDialog(athlete.id, athlete.names);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(String athleteId, String athleteName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de que desea eliminar a "$athleteName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _datasource.deleteAthlete(athleteId);
              Navigator.pop(context);
              _loadAthletes();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String label) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: EliteMartialColors.onSecondaryContainer,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
