import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/datasources/event_firestore_datasource.dart';
import '../../data/models/event_model.dart';
import 'event_form_page.dart';

class EventsListPage extends StatefulWidget {
  const EventsListPage({super.key});

  @override
  State<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends State<EventsListPage> {
  late EventFirestoreDatasource _datasource;
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _datasource = EventFirestoreDatasource(FirebaseFirestore.instance);
    _loadEvents();
  }

  void _loadEvents() {
    setState(() {
      _eventsFuture = _datasource.getAllEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Eventos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventFormPage(
                onSaved: _loadEvents,
              ),
            ),
          ).then((_) => _loadEvents());
        },
        backgroundColor: EliteMartialColors.secondaryContainer,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<EventModel>>(
        future: _eventsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final events = snapshot.data ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text('No hay eventos'),
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
                            flex: 2,
                            child: _buildHeaderCell('Nombre'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeaderCell('Tipo'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeaderCell('Estado'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeaderCell('Fecha'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeaderCell('Acciones'),
                          ),
                        ],
                      ),
                    ),
                    ...events.asMap().entries.map((entry) {
                      final index = entry.key;
                      final event = entry.value;
                      final isEven = index.isEven;
                      return Container(
                        color: isEven
                            ? EliteMartialColors.surfaceContainerLowest
                            : EliteMartialColors.surfaceContainer,
                        width: constraints.maxWidth,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildCell(event.name),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildCell(event.eventType.displayName),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildCell(event.status.displayName),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildCell(
                                '${event.date.day}/${event.date.month}/${event.date.year}',
                              ),
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
                                          builder: (context) =>
                                              EventFormPage(
                                            event: event,
                                            onSaved: _loadEvents,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Eliminar'),
                                    onTap: () {
                                      _showDeleteDialog(event.id, event.name);
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
      ),
    );
  }

  void _showDeleteDialog(String eventId, String eventName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Está seguro de que desea eliminar "$eventName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _datasource.deleteEvent(eventId);
              Navigator.pop(context);
              _loadEvents();
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
