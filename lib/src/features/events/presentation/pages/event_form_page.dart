import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import '../../data/datasources/event_firestore_datasource.dart';
import '../../data/models/event_model.dart';
import '../../domain/enums/event_type.dart';
import '../../domain/enums/competition_type.dart';
import '../../domain/enums/ranking.dart';
import '../../domain/enums/event_level.dart';
import '../../domain/enums/event_status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventFormPage extends StatefulWidget {
  final EventModel? event;
  final VoidCallback onSaved;

  const EventFormPage({
    super.key,
    this.event,
    required this.onSaved,
  });

  @override
  State<EventFormPage> createState() => _EventFormPageState();
}

class _EventFormPageState extends State<EventFormPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _observationsController;
  late TextEditingController _directorController;
  late TextEditingController _scoreController;

  late EventType _selectedEventType;
  late CompetitionType _selectedCompetitionType;
  late Ranking _selectedRanking;
  late EventLevel _selectedLevel;
  late EventStatus _selectedStatus;
  late DateTime _selectedDate;
  late LatLng _selectedLocation;

  File? _selectedReglamentoFile;
  Uint8List? _selectedReglamentoBytes;
  String? _reglamentoUrl;

  File? _selectedImageFile;
  Uint8List? _selectedImageBytes;
  String? _imageUrl;

  bool? _isOfficial;
  bool _isUploadingFile = false;
  bool _isUploadingImage = false;

  late GoogleMapController _mapController;
  late EventFirestoreDatasource _datasource;

  @override
  void initState() {
    super.initState();
    _datasource = EventFirestoreDatasource(FirebaseFirestore.instance);

    _nameController = TextEditingController(text: widget.event?.name ?? '');
    _addressController =
        TextEditingController(text: widget.event?.address ?? '');
    _observationsController =
        TextEditingController(text: widget.event?.observations ?? '');
    _directorController =
        TextEditingController(text: widget.event?.director ?? '');
    _scoreController =
        TextEditingController(text: widget.event?.score?.toString() ?? '');

    _selectedEventType = widget.event?.eventType ?? EventType.campeonato;
    _selectedCompetitionType =
        widget.event?.competitionType ?? CompetitionType.abierto;
    _selectedRanking = widget.event?.ranking ?? Ranking.na;
    _selectedLevel = widget.event?.level ?? EventLevel.clubs;
    _selectedStatus = widget.event?.status ?? EventStatus.activo;
    _selectedDate = widget.event?.date ?? DateTime.now();
    _selectedLocation = LatLng(
      widget.event?.latitude ?? -2.9001,
      widget.event?.longitude ?? -79.0059,
    );
    _reglamentoUrl = widget.event?.reglamentoUrl;
    _imageUrl = widget.event?.imageUrl;
    _isOfficial = widget.event?.isOfficial;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _observationsController.dispose();
    _directorController.dispose();
    _scoreController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _pickReglamento() async {
    try {
      print('Picking file...');
      FilePickerResult?  result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      print('File picker result: $result');
      if (result == null) {
        print('File picker was cancelled');
        return;
      }

      print('Files count: ${result.files.length}');
      if (result.files.isEmpty) {
        print('No files selected');
        return;
      }

      final file = result.files.first;
      print('Selected file: ${file.name}');

      if (kIsWeb) {
        if (file.bytes != null) {
          final bytes = file.bytes!;
          if (bytes.isNotEmpty) {
            setState(() {
              _selectedReglamentoBytes = bytes;
            });
          } else {
            throw Exception('File bytes are empty');
          }
        } else {
          throw Exception('No bytes available for web');
        }
      } else {
        print('Mobile platform detected');
        final path = file.path;
        print('File path: $path');
        if (path != null && path.isNotEmpty) {
          setState(() {
            _selectedReglamentoFile = File(path);
          });
          print('File assigned to state');
        }
      }

      await _uploadReglamento();
    } catch (e) {
      print('Error in _pickReglamento: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al seleccionar archivo: $e')),
      );
    }
  }

  Future<void> _uploadReglamento() async {
    if (_selectedReglamentoFile == null && _selectedReglamentoBytes == null) {
      print('No file selected');
      return;
    }

    setState(() {
      _isUploadingFile = true;
    });

    try {
      final fileName = 'eventos/${DateTime.now().millisecondsSinceEpoch}.pdf';
      print('Uploading to: $fileName');
      final ref = FirebaseStorage.instance.ref().child(fileName);

      if (kIsWeb) {
        print('Web upload, bytes length: ${_selectedReglamentoBytes?.length}');
        if (_selectedReglamentoBytes == null) {
          throw Exception('No bytes available');
        }
        final task = await ref.putData(_selectedReglamentoBytes!);
        print('Upload task completed: ${task.state}');
      } else {
        print('Mobile upload, file path: ${_selectedReglamentoFile!.path}');
        await ref.putFile(_selectedReglamentoFile!);
      }

      print('Getting download URL...');
      final url = await ref.getDownloadURL();
      print('Download URL: $url');

      setState(() {
        _reglamentoUrl = url;
        _isUploadingFile = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reglamento cargado exitosamente')),
      );
    } catch (e) {
      print('Error uploading: $e');
      setState(() {
        _isUploadingFile = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir reglamento: $e')),
      );
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImageFile == null && _selectedImageBytes == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final fileName = 'eventos/${DateTime.now().millisecondsSinceEpoch}.jpg';
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
        const SnackBar(content: Text('Imagen cargada exitosamente')),
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
        title: Text(widget.event == null ? 'Crear Evento' : 'Editar Evento'),
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
                labelText: 'Nombre del Evento',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo de Evento
            DropdownButtonFormField<EventType>(
              value: _selectedEventType,
              items: EventType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedEventType = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Evento',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Tipo de Competencia
            DropdownButtonFormField<CompetitionType>(
              value: _selectedCompetitionType,
              items: CompetitionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCompetitionType = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Tipo de Competencia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Ranking
            DropdownButtonFormField<Ranking>(
              value: _selectedRanking,
              items: Ranking.values.map((ranking) {
                return DropdownMenuItem(
                  value: ranking,
                  child: Text(ranking.displayName),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRanking = value;
                  });
                }
              },
              decoration: InputDecoration(
                labelText: 'Ranking',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nivel
            DropdownButtonFormField<EventLevel>(
              value: _selectedLevel,
              items: EventLevel.values.map((level) {
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
                labelText: 'Nivel',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Fecha
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Fecha: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                ),
                ElevatedButton(
                  onPressed: _selectDate,
                  child: const Text('Seleccionar Fecha'),
                ),
              ],
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

            // Imagen
            Text(
              'Imagen del Evento',
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
            const SizedBox(height: 16),

            // Estado
            DropdownButtonFormField<EventStatus>(
              value: _selectedStatus,
              items: EventStatus.values.map((status) {
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

            // Reglamento
            Text(
              'Reglamento (PDF)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (_reglamentoUrl != null && _reglamentoUrl!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  '✓ Reglamento cargado',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isUploadingFile ? null : _pickReglamento,
                icon: _isUploadingFile
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.file_upload),
                label: Text(_isUploadingFile
                    ? 'Subiendo...'
                    : 'Seleccionar Reglamento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: EliteMartialColors.secondaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Observaciones
            TextField(
              controller: _observationsController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Observaciones',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Evento Abierto - Director
            if (_selectedCompetitionType == CompetitionType.abierto) ...[
              TextField(
                controller: _directorController,
                decoration: InputDecoration(
                  labelText: 'Director',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Puntuación
              TextField(
                controller: _scoreController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Puntuación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Oficial
              Row(
                children: [
                  const Text('¿Oficial?'),
                  const SizedBox(width: 16),
                  Radio<bool>(
                    value: true,
                    groupValue: _isOfficial,
                    onChanged: (value) {
                      setState(() {
                        _isOfficial = value;
                      });
                    },
                  ),
                  const Text('Sí'),
                  Radio<bool>(
                    value: false,
                    groupValue: _isOfficial,
                    onChanged: (value) {
                      setState(() {
                        _isOfficial = value;
                      });
                    },
                  ),
                  const Text('No'),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Mapa
            Text(
              'Seleccionar ubicación',
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
                      if (_nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('El nombre es requerido'),
                          ),
                        );
                        return;
                      }

                      final newEvent = EventModel(
                        id: widget.event?.id ??
                            DateTime.now().millisecondsSinceEpoch.toString(),
                        name: _nameController.text,
                        eventType: _selectedEventType,
                        competitionType: _selectedCompetitionType,
                        ranking: _selectedRanking,
                        level: _selectedLevel,
                        date: _selectedDate,
                        address: _addressController.text,
                        status: _selectedStatus,
                        reglamentoUrl: _reglamentoUrl ?? '',
                        imageUrl: _imageUrl ?? '',
                        observations: _observationsController.text,
                        director: _directorController.text.isNotEmpty
                            ? _directorController.text
                            : null,
                        score: int.tryParse(_scoreController.text),
                        isOfficial: _isOfficial,
                        latitude: _selectedLocation.latitude,
                        longitude: _selectedLocation.longitude,
                      );

                      bool success;
                      if (widget.event == null) {
                        success = await _datasource.createEvent(newEvent);
                      } else {
                        success = await _datasource.updateEvent(newEvent);
                      }

                      if (success) {
                        widget.onSaved();
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al guardar el evento'),
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
