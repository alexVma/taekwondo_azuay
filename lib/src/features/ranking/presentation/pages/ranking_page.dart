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

  late Future<Map<String, String>> _primaryFilters;
  late Future<Map<String, String>> _categoryFilters;
  late Future<Map<String, String>> _beltFilters;
  late Future<Map<String, String>> _gendersFilters;

  String? _selectedTypeId;
  String? _selectedCategoryId;
  String? _selectedGroupId;
  String? _selectedGenderId;

  @override
  void initState() {
    super.initState();
    _primaryFilters = _cargarCatalogo("tiposParticipante");
    _categoryFilters = _cargarCatalogo("categorias");
    _beltFilters = _cargarCatalogo("grupos");
    _gendersFilters = _cargarCatalogo("generos");
  }

  Future<Map<String, String>> _cargarCatalogo(String coleccion) async {
    try {
      final snapshot = await db.collection(coleccion).get();
      final filtros = <String, String>{};
      for (final doc in snapshot.docs) {
        filtros[doc['nombre'] as String] = doc.id;
      }
      return filtros;
    } catch (e) {
      print('Error cargando catálogo $coleccion: $e');
      return {};
    }
  }

  Future<List<RankingAthlete>> _cargarAtletas() async {
    try {
      final snapshot = await db
          .collection("rankings")
          .orderBy("puesto")
          .get();

      var athletes = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        final position = data['puesto'] as int? ?? 0;

        return (
          athlete: RankingAthlete(
            position: position,
            name: data['nombre'] as String? ?? 'Sin nombre',
            academy: 'Academia',
            points: (data['acumulado'] as num?)?.toInt() ?? 0,
            badgeColor: _getBadgeColor(position),
            isChampion: position == 1,
            imageUrl: data['imageUrl'] as String?,
          ),
          typeId: data['tipoParticipanteId'] as String?,
          categoryId: data['categoriaId'] as String?,
          groupId: data['grupoId'] as String?,
          genderId: data['generoId'] as String?,
        );
      }).toList();

      athletes = athletes.where((item) {
        if (_selectedTypeId != null && item.typeId != _selectedTypeId) {
          return false;
        }
        if (_selectedCategoryId != null && item.categoryId != _selectedCategoryId) {
          return false;
        }
        if (_selectedGroupId != null && item.groupId != _selectedGroupId) {
          return false;
        }
        if (_selectedGenderId != null && item.genderId != _selectedGenderId) {
          return false;
        }
        return true;
      }).toList();

      return athletes.map((item) => item.athlete).toList();
    } catch (e) {
      print('Error cargando atletas: $e');
      return [];
    }
  }

  Color _getBadgeColor(int position) {
    return switch (position) {
      1 => const Color(0xffffc400),
      2 => const Color(0xffb8b8b8),
      3 => const Color(0xffc47a2c),
      _ => const Color(0xff8b8b8b),
    };
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
                _BuildFilterRow(
                  future: _primaryFilters,
                  onSelected: (id) => setState(() => _selectedTypeId = id),
                ),
                const SizedBox(height: EliteMartialSpacing.sm),
                _BuildFilterRow(
                  future: _categoryFilters,
                  onSelected: (id) => setState(() => _selectedCategoryId = id),
                ),
                const SizedBox(height: EliteMartialSpacing.sm),
                _BuildFilterRow(
                  future: _beltFilters,
                  onSelected: (id) => setState(() => _selectedGroupId = id),
                ),
                const SizedBox(height: EliteMartialSpacing.sm),
                _BuildFilterRow(
                  future: _gendersFilters,
                  onSelected: (id) => setState(() => _selectedGenderId = id),
                ),
                const SizedBox(height: EliteMartialSpacing.xl),
                _AthletesListBuilder(future: _cargarAtletas()),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuildFilterRow extends StatefulWidget {
  const _BuildFilterRow({
    required this.future,
    required this.onSelected,
  });

  final Future<Map<String, String>> future;
  final Function(String?) onSelected;

  @override
  State<_BuildFilterRow> createState() => _BuildFilterRowState();
}

class _BuildFilterRowState extends State<_BuildFilterRow> {
  String? _selectedId;
  bool _firstLoadDone = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: widget.future,
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

        final filtros = snapshot.data!;

        if (!_firstLoadDone && _selectedId == null) {
          _firstLoadDone = true;
          final firstId = filtros.values.first;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _selectedId = firstId);
            widget.onSelected(firstId);
          });
        }

        return _FilterRow(
          filtros: filtros,
          selectedId: _selectedId,
          onSelectionChanged: (id) {
            setState(() => _selectedId = id);
            widget.onSelected(id);
          },
        );
      },
    );
  }
}

class _AthletesListBuilder extends StatelessWidget {
  const _AthletesListBuilder({required this.future});

  final Future<List<RankingAthlete>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<RankingAthlete>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'Error cargando atletas',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: EliteMartialColors.onSurfaceVariant,
                  ),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'No hay atletas disponibles',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: EliteMartialColors.onSurfaceVariant,
                  ),
            ),
          );
        }

        final athletes = snapshot.data!;
        return Column(
          children: [
            for (final athlete in athletes) ...[
              RankingAthleteCard(athlete: athlete),
              const SizedBox(height: EliteMartialSpacing.md),
            ],
          ],
        );
      },
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({
    required this.filtros,
    required this.selectedId,
    required this.onSelectionChanged,
  });

  final Map<String, String> filtros;
  final String? selectedId;
  final Function(String?) onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final entries = filtros.entries.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final entry in entries) ...[
            GestureDetector(
              onTap: () {
                if (selectedId == entry.value) {
                  onSelectionChanged(null);
                } else {
                  onSelectionChanged(entry.value);
                }
              },
              child: RankingFilterChip(
                label: entry.key,
                isSelected: selectedId == entry.value,
              ),
            ),
            const SizedBox(width: EliteMartialSpacing.sm),
          ],
        ],
      ),
    );
  }
}
