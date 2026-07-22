import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/tournaments/domain/entities/tournament_event.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/molecules/featured_tournament_card.dart';
import 'package:taekwondo_azuay/src/features/tournaments/presentation/molecules/tournament_list_card.dart';
import 'package:taekwondo_azuay/src/features/events/data/datasources/event_firestore_datasource.dart';
import 'package:taekwondo_azuay/src/features/events/data/models/event_model.dart';

class TournamentsPage extends StatefulWidget {
  const TournamentsPage({super.key});

  @override
  State<TournamentsPage> createState() => _TournamentsPageState();
}

class _TournamentsPageState extends State<TournamentsPage> {
  late EventFirestoreDatasource _datasource;
  late Future<List<EventModel>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _datasource = EventFirestoreDatasource(FirebaseFirestore.instance);
    _eventsFuture = _datasource.getAllEvents();
  }

  TournamentEvent _convertEventToTournament(EventModel event) {
    return TournamentEvent(
      title: event.name,
      date: '${event.date.day}/${event.date.month}',
      location: event.address,
      modality: event.eventType.displayName,
      status: event.status.displayName == 'ACTIVO'
          ? TournamentStatus.active
          : event.status.displayName == 'SUSPENDIDO'
              ? TournamentStatus.upcoming
              : TournamentStatus.finished,
      imageSeed: _getColorForEventType(event.eventType.displayName),
      isFeatured: false,
      imageUrl: event.imageUrl.isNotEmpty ? event.imageUrl : null,
      eventDate: event.date,
    );
  }

  Color _getColorForEventType(String eventType) {
    return switch (eventType) {
      'CAMPEONATO' => const Color(0xff15384d),
      'CURSO' => const Color(0xff102d42),
      'CAMPAMENTO' => const Color(0xff3d3d3d),
      _ => const Color(0xff15384d),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventModel>>(
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
          return const Center(child: Text('No hay eventos disponibles'));
        }

        final tournaments =
            events.map((e) => _convertEventToTournament(e)).toList();
        final featured = tournaments.isNotEmpty ? tournaments.first : null;
        final secondaryEvents = tournaments.length > 1
            ? tournaments.sublist(1)
            : <TournamentEvent>[];

        return ColoredBox(
          color: EliteMartialColors.surfaceContainerLowest,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate.fixed([
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Proximos Eventos',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: EliteMartialColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: EliteMartialSpacing.xs),
                              Text(
                                'Calendario',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color:
                                          EliteMartialColors.onSurfaceVariant,
                                      height: 1.25,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.circle_outlined,
                          color: EliteMartialColors.outlineVariant,
                          size: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: EliteMartialSpacing.xl),
                    if (featured != null) ...[
                      FeaturedTournamentCard(event: featured),
                      const SizedBox(height: EliteMartialSpacing.lg),
                    ],
                    for (final event in secondaryEvents) ...[
                      TournamentListCard(event: event),
                      const SizedBox(height: EliteMartialSpacing.md),
                    ],
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
