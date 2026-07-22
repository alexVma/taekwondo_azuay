import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../cubit/academies_management_cubit.dart';
import '../cubit/academies_management_state.dart';
import 'academy_form_page.dart';

class AcademiesManagementPage extends StatefulWidget {
  const AcademiesManagementPage({super.key});

  @override
  State<AcademiesManagementPage> createState() =>
      _AcademiesManagementPageState();
}

class _AcademiesManagementPageState extends State<AcademiesManagementPage> {
  @override
  void initState() {
    super.initState();
    context.read<AcademiesManagementCubit>().loadAcademies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Academias'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final cubit = context.read<AcademiesManagementCubit>();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider.value(
                value: cubit,
                child: const AcademyFormPage(),
              ),
            ),
          );
        },
        backgroundColor: EliteMartialColors.secondaryContainer,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<AcademiesManagementCubit, AcademiesManagementState>(
        builder: (context, state) {
          if (state.status == AcademiesManagementStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == AcademiesManagementStatus.error) {
            return Center(
              child: Text(state.errorMessage ?? 'Error'),
            );
          }

          if (state.academies.isEmpty) {
            return const Center(
              child: Text('No hay academias'),
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
                            child: _buildHeaderCell('Estado'),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Competencia'),
                          ),
                          Expanded(
                            flex: 2,
                            child: _buildHeaderCell('Tipo'),
                          ),
                          Expanded(
                            flex: 1,
                            child: _buildHeaderCell('Acciones'),
                          ),
                        ],
                      ),
                    ),
                    ...state.academies.asMap().entries.map((entry) {
                      final index = entry.key;
                      final academy = entry.value;
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
                              child: _buildCell(academy.name),
                            ),
                            Expanded(
                              flex: 1,
                              child: _buildCell(academy.status.displayName),
                            ),
                            Expanded(
                              flex: 2,
                              child:
                                  _buildCell(academy.competitionLevel.displayName),
                            ),
                            Expanded(
                              flex: 2,
                              child: _buildCell(academy.type.displayName),
                            ),
                            Expanded(
                              flex: 1,
                              child: PopupMenuButton(
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: const Text('Editar'),
                                    onTap: () {
                                      final cubit = context.read<
                                          AcademiesManagementCubit>();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BlocProvider.value(
                                            value: cubit,
                                            child: AcademyFormPage(
                                              academy: academy,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  PopupMenuItem(
                                    child: const Text('Eliminar'),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                              'Confirmar eliminación'),
                                          content: Text(
                                              '¿Está seguro de que desea eliminar a ${academy.name}?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                context
                                                    .read<
                                                        AcademiesManagementCubit>()
                                                    .deleteAcademy(academy.id);
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Eliminar'),
                                            ),
                                          ],
                                        ),
                                      );
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
