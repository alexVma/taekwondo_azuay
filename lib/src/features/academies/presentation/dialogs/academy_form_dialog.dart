import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/models/academy_model.dart';
import '../../domain/enums/academy_type.dart';
import '../../domain/enums/competition_level.dart';
import '../../domain/enums/academy_status.dart';
import '../cubit/academies_management_cubit.dart';

class AcademyFormDialog extends StatefulWidget {
  final AcademyModel? academy;

  const AcademyFormDialog({
    super.key,
    this.academy,
  });

  @override
  State<AcademyFormDialog> createState() => _AcademyFormDialogState();
}

class _AcademyFormDialogState extends State<AcademyFormDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _representativeController;
  late TextEditingController _emailController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;
  late TextEditingController _coachController;
  late TextEditingController _phoneController;
  late TextEditingController _scheduleController;
  late TextEditingController _imageUrlController;

  late AcademyType _selectedType;
  late CompetitionLevel _selectedLevel;
  late AcademyStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.academy?.name ?? '');
    _addressController =
        TextEditingController(text: widget.academy?.address ?? '');
    _representativeController =
        TextEditingController(text: widget.academy?.representative ?? '');
    _emailController = TextEditingController(text: widget.academy?.email ?? '');
    _latitudeController =
        TextEditingController(text: widget.academy?.latitude.toString() ?? '');
    _longitudeController =
        TextEditingController(text: widget.academy?.longitude.toString() ?? '');
    _coachController = TextEditingController(text: widget.academy?.coach ?? '');
    _phoneController = TextEditingController(text: widget.academy?.phone ?? '');
    _scheduleController =
        TextEditingController(text: widget.academy?.schedule ?? '');
    _imageUrlController = TextEditingController(text: widget.academy?.url ?? '');

    _selectedType = widget.academy?.type ?? AcademyType.noAfiliado;
    _selectedLevel =
        widget.academy?.competitionLevel ?? CompetitionLevel.clubs;
    _selectedStatus = widget.academy?.status ?? AcademyStatus.activa;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _representativeController.dispose();
    _emailController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _coachController.dispose();
    _phoneController.dispose();
    _scheduleController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.academy == null ? 'Crear Academia' : 'Editar Academia'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del Club',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AcademyType>(
              value: _selectedType,
              items: AcademyType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Entidad',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<CompetitionLevel>(
              value: _selectedLevel,
              items: CompetitionLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Text(level.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedLevel = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Nivel de Competencia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<AcademyStatus>(
              value: _selectedStatus,
              items: AcademyStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedStatus = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Estado',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _representativeController,
              decoration: InputDecoration(
                labelText: 'Representante',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _latitudeController,
                    decoration: InputDecoration(
                      labelText: 'Latitud',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _longitudeController,
                    decoration: InputDecoration(
                      labelText: 'Longitud',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _coachController,
              decoration: InputDecoration(
                labelText: 'Entrenador',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _scheduleController,
              decoration: InputDecoration(
                labelText: 'Horario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'URL de Imagen',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            final newAcademy = AcademyModel(
              id: widget.academy?.id ??
                  DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              url: _imageUrlController.text,
              coach: _coachController.text,
              address: _addressController.text,
              phone: _phoneController.text,
              schedule: _scheduleController.text,
              badge: _selectedType.displayName,
              latitude: double.tryParse(_latitudeController.text) ?? 0,
              longitude: double.tryParse(_longitudeController.text) ?? 0,
              type: _selectedType,
              competitionLevel: _selectedLevel,
              status: _selectedStatus,
              representative: _representativeController.text,
              email: _emailController.text,
            );

            if (widget.academy == null) {
              context
                  .read<AcademiesManagementCubit>()
                  .createAcademy(newAcademy);
            } else {
              context
                  .read<AcademiesManagementCubit>()
                  .updateAcademy(newAcademy);
            }
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: EliteMartialColors.secondaryContainer,
          ),
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
