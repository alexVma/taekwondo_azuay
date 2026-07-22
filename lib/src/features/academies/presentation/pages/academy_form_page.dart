import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/models/academy_model.dart';
import '../../domain/enums/academy_type.dart';
import '../../domain/enums/competition_level.dart';
import '../../domain/enums/academy_status.dart';
import '../cubit/academies_management_cubit.dart';

class AcademyFormPage extends StatefulWidget {
  final AcademyModel? academy;

  const AcademyFormPage({
    super.key,
    this.academy,
  });

  @override
  State<AcademyFormPage> createState() => _AcademyFormPageState();
}

class _AcademyFormPageState extends State<AcademyFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _representativeController;
  late TextEditingController _emailController;
  late TextEditingController _coachController;
  late TextEditingController _phoneController;
  late TextEditingController _scheduleController;

  late AcademyType _selectedType;
  late CompetitionLevel _selectedLevel;
  late AcademyStatus _selectedStatus;

  late GoogleMapController _mapController;
  late LatLng _selectedLocation;
  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  String? _imageUrl;
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.academy?.name ?? '');
    _addressController =
        TextEditingController(text: widget.academy?.address ?? '');
    _representativeController =
        TextEditingController(text: widget.academy?.representative ?? '');
    _emailController = TextEditingController(text: widget.academy?.email ?? '');
    _coachController = TextEditingController(text: widget.academy?.coach ?? '');
    _phoneController = TextEditingController(text: widget.academy?.phone ?? '');
    _scheduleController =
        TextEditingController(text: widget.academy?.schedule ?? '');

    _selectedType = widget.academy?.type ?? AcademyType.noAfiliado;
    _selectedLevel =
        widget.academy?.competitionLevel ?? CompetitionLevel.clubs;
    _selectedStatus = widget.academy?.status ?? AcademyStatus.activa;

    _selectedLocation = LatLng(
      widget.academy?.latitude ?? -2.9001,
      widget.academy?.longitude ?? -79.0059,
    );
    _imageUrl = widget.academy?.url;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _representativeController.dispose();
    _emailController.dispose();
    _coachController.dispose();
    _phoneController.dispose();
    _scheduleController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      } else {
        setState(() {
          _selectedImageFile = File(image.path);
        });
      }
      await _uploadImageToStorage();
    }
  }

  Future<void> _uploadImageToStorage() async {
    if (_selectedImageFile == null && _selectedImageBytes == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final fileName =
          'academies/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      if (kIsWeb) {
        await ref.putData(_selectedImageBytes!);
      } else {
        await ref.putFile(_selectedImageFile!);
      }

      final url = await ref.getDownloadURL();

      setState(() {
        _imageUrl = url;
        _isUploadingImage = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Imagen subida exitosamente')),
      );
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir imagen: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.academy == null ? 'Crear Academia' : 'Editar Academia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nombre
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nombre del Club',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo de Entidad
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
            const SizedBox(height: 16),

            // Nivel de Competencia
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
            const SizedBox(height: 16),

            // Estado
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
            const SizedBox(height: 16),

            // Dirección
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Dirección',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Representante
            TextField(
              controller: _representativeController,
              decoration: InputDecoration(
                labelText: 'Representante',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Correo',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Entrenador
            TextField(
              controller: _coachController,
              decoration: InputDecoration(
                labelText: 'Entrenador',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Teléfono
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Teléfono',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Horario
            TextField(
              controller: _scheduleController,
              decoration: InputDecoration(
                labelText: 'Horario',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Mapa para seleccionar coordenadas
            Text(
              'Seleccionar ubicación en el mapa',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: GoogleMap(
                onMapCreated: (controller) {
                  _mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: _selectedLocation,
                  zoom: 14,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId('selected'),
                    position: _selectedLocation,
                  ),
                },
                onTap: (LatLng location) {
                  setState(() {
                    _selectedLocation = location;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // Coordenadas
            Row(
              children: [
                Expanded(
                  child: Text('Lat: ${_selectedLocation.latitude.toStringAsFixed(4)}'),
                ),
                Expanded(
                  child: Text('Lng: ${_selectedLocation.longitude.toStringAsFixed(4)}'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Imagen
            Text(
              'Imagen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_selectedImageBytes != null && kIsWeb)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.memory(
                  _selectedImageBytes!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (_selectedImageFile != null && !kIsWeb)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  _selectedImageFile!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else if (_imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _imageUrl!,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      width: double.infinity,
                      color: EliteMartialColors.surfaceContainer,
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploadingImage ? null : _pickImage,
                icon: _isUploadingImage
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.image),
                label: Text(_isUploadingImage ? 'Subiendo...' : 'Seleccionar Imagen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EliteMartialColors.secondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
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
                    onPressed: () {
                      if (_nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('El nombre es requerido'),
                          ),
                        );
                        return;
                      }

                      final newAcademy = AcademyModel(
                        id: widget.academy?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        url: _imageUrl ?? '',
                        coach: _coachController.text,
                        address: _addressController.text,
                        phone: _phoneController.text,
                        schedule: _scheduleController.text,
                        badge: _selectedType.displayName,
                        latitude: _selectedLocation.latitude,
                        longitude: _selectedLocation.longitude,
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
