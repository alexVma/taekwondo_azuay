import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_spacing.dart';
import 'package:taekwondo_azuay/src/features/ranking/domain/entities/ranking_athlete.dart';
import 'package:taekwondo_azuay/src/features/ranking/presentation/atoms/ranking_filter_chip.dart';
import 'package:taekwondo_azuay/src/features/ranking/presentation/molecules/ranking_athlete_card.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  late Future<List<String>> _primaryFilters;
  late Future<List<String>> _categoryFilters;
  late Future<List<String>> _beltFilters;
  late Future<List<String>> _gendersFilters;

  @override
  void initState() {
    super.initState();
    _primaryFilters = _cargarCatalogo("tiposParticipante");
    _categoryFilters = _cargarCatalogo("categorias");
    _beltFilters = _cargarCatalogo("grupos");
    _gendersFilters = _cargarCatalogo("generos");
  }

  Future<List<String>> _cargarCatalogo(String coleccion) async {
    try {
      final snapshot = await db.collection(coleccion).get();
      final filtros = snapshot.docs
          .map((doc) => doc['nombre'] as String)
          .toList();
      return filtros;
    } catch (e) {
      print('Error cargando catálogo $coleccion: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: EliteMartialColors.surfaceContainerLowest,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  'Ranking Provincial',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: EliteMartialColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: EliteMartialSpacing.sm),
                Text(
                  'Clasificacion oficial acumulada',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: EliteMartialColors.onSurfaceVariant,
                        height: 1.25,
                      ),
                ),
                const SizedBox(height: EliteMartialSpacing.xl),
                _BuildFilterRow(future: _primaryFilters, selectedIndex: 0),
                const SizedBox(height: EliteMartialSpacing.sm),
                _BuildFilterRow(future: _categoryFilters, selectedIndex: 1),
                const SizedBox(height: EliteMartialSpacing.sm),
                _BuildFilterRow(future: _beltFilters, selectedIndex: 1),
                const SizedBox(height: EliteMartialSpacing.sm),
                _BuildFilterRow(future: _gendersFilters, selectedIndex: 1),
                const SizedBox(height: EliteMartialSpacing.xl),
                for (final athlete in RankingAthlete.cadets) ...[
                  RankingAthleteCard(athlete: athlete),
                  const SizedBox(height: EliteMartialSpacing.md),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildFilterRow extends StatelessWidget {
  const _BuildFilterRow({
    required this.future,
    required this.selectedIndex,
  });

  final Future<List<String>> future;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SizedBox(
              height: 40,
              child: Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'No hay filtros disponibles',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: EliteMartialColors.onSurfaceVariant,
                  ),
            ),
          );
        }

        final labels = snapshot.data!;
        return _FilterRow(labels: labels, selectedIndex: selectedIndex);
      },
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.labels,
    required this.selectedIndex,
  });

  final List<String> labels;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in labels.indexed) ...[
            RankingFilterChip(
              label: entry.$2,
              isSelected: entry.$1 == selectedIndex,
            ),
            const SizedBox(width: EliteMartialSpacing.sm),
          ],
        ],
      ),
    );
  }
}
