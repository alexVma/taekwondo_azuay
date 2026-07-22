import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/datasources/event_firestore_datasource.dart';
import '../../data/datasources/event_inscription_datasource.dart';
import '../../data/models/event_inscription_model.dart';
import '../../data/models/event_model.dart';
import '../../../athletes/data/datasources/athlete_firestore_datasource.dart';
import '../../../athletes/data/models/athlete_model.dart';

class EventInscriptionsPage extends StatefulWidget {
  final String eventId;

  const EventInscriptionsPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventInscriptionsPage> createState() => _EventInscriptionsPageState();
}

class _EventInscriptionsPageState extends State<EventInscriptionsPage> {
  late EventInscriptionDatasource _inscriptionDatasource;
  late AthleteFirestoreDatasource _athletesDatasource;
  late EventFirestoreDatasource _eventsDatasource;
  late Future<List<EventInscriptionModel>> _inscriptionsFuture;
  late Future<List<AthleteModel>> _athletesFuture;
  late Future<Map<String, String>> _academiesFuture;

  TextEditingController _searchController = TextEditingController();
  List<AthleteModel> _filteredAthletes = [];
  EventModel? _event;

  @override
  void initState() {
    super.initState();
    _inscriptionDatasource = EventInscriptionDatasource(
      FirebaseFirestore.instance,
      eventId: widget.eventId,
    );
    _athletesDatasource = AthleteFirestoreDatasource(FirebaseFirestore.instance);
    _eventsDatasource = EventFirestoreDatasource(FirebaseFirestore.instance);

    _loadEvent();
    _loadInscriptions();
    _loadAthletes();
    _academiesFuture = _athletesDatasource.getAcademies();
  }

  void _loadEvent() async {
    final events = await _eventsDatasource.getAllEvents();
    _event = events.firstWhere((e) => e.id == widget.eventId, orElse: () => events.first);
  }

  void _loadInscriptions() {
    setState(() {
      _inscriptionsFuture = _inscriptionDatasource.getInscriptions();
    });
  }

  void _loadAthletes() {
    setState(() {
      _athletesFuture = _athletesDatasource.getAllAthletes();
    });
  }

  void _filterAthletes(String query) async {
    if (query.isEmpty) {
      setState(() {
        _filteredAthletes = [];
      });
      return;
    }

    final athletes = await _athletesFuture;
    final filtered = athletes
        .where((athlete) =>
            athlete.id.contains(query) ||
            athlete.names.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredAthletes = filtered;
    });
  }

  void _addInscription(AthleteModel athlete) async {
    try {
      final academies = await _academiesFuture;
      final academyName = academies[athlete.academy] ?? 'N/A';

      final inscription = EventInscriptionModel(
        athleteId: athlete.id,
        athleteName: athlete.names,
        academyName: academyName,
        isWeighed: false,
      );

      await _inscriptionDatasource.addInscription(inscription);
      _loadInscriptions();
      _searchController.clear();
      setState(() {
        _filteredAthletes = [];
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Deportista inscrito exitosamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al inscribir: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscripciones - ${_event?.name ?? 'Evento'}'),
      ),
      body: FutureBuilder<Map<String, String>>(
        future: _academiesFuture,
        builder: (context, academiesSnapshot) {
          final academies = academiesSnapshot.data ?? {};

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Buscar Deportista',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _searchController,
                      onChanged: _filterAthletes,
                      decoration: InputDecoration(
                        hintText: 'Buscar por cédula o nombre',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_filteredAthletes.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: EliteMartialColors.outlineVariant,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _filteredAthletes.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final athlete = _filteredAthletes[index];
                      return ListTile(
                        dense: true,
                        title: Text(athlete.names),
                        subtitle: Text(athlete.id),
                        trailing: ElevatedButton(
                          onPressed: () => _addInscription(athlete),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: EliteMartialColors.secondaryContainer,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                          child: const Text('Agregar'),
                        ),
                      );
                    },
                  ),
                ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Divider(),
              ),
              Expanded(
                child: FutureBuilder<List<EventInscriptionModel>>(
                  future: _inscriptionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}'),
                      );
                    }

                    final inscriptions = snapshot.data ?? [];

                    if (inscriptions.isEmpty) {
                      return const Center(
                        child: Text('No hay deportistas inscritos'),
                      );
                    }

                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Column(
                          children: [
                            Container(
                              color: EliteMartialColors.secondaryContainer,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: _buildHeaderCell('Cédula'),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: _buildHeaderCell('Nombre'),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _buildHeaderCell('Academia'),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _buildHeaderCell('Pesado'),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _buildHeaderCell('Acciones'),
                                  ),
                                ],
                              ),
                            ),
                            ...inscriptions.asMap().entries.map((entry) {
                              final index = entry.key;
                              final inscription = entry.value;
                              final isEven = index.isEven;

                              return Container(
                                color: isEven
                                    ? EliteMartialColors.surfaceContainerLowest
                                    : EliteMartialColors.surfaceContainer,
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: _buildCell(inscription.athleteId),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: _buildCell(inscription.athleteName),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: _buildCell(inscription.academyName),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Checkbox(
                                        value: inscription.isWeighed,
                                        onChanged: (value) async {
                                          final updated = EventInscriptionModel(
                                            athleteId: inscription.athleteId,
                                            athleteName: inscription.athleteName,
                                            academyName: inscription.academyName,
                                            isWeighed: value ?? false,
                                          );
                                          await _inscriptionDatasource
                                              .updateInscription(updated);
                                          _loadInscriptions();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: IconButton(
                                        icon: const Icon(Icons.delete),
                                        iconSize: 20,
                                        onPressed: () {
                                          _showDeleteDialog(inscription.athleteId,
                                              inscription.athleteName);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
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
        content:
            Text('¿Desea eliminar a "$athleteName" de las inscripciones?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _inscriptionDatasource.deleteInscription(athleteId);
              Navigator.pop(context);
              _loadInscriptions();
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
