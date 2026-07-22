import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:taekwondo_azuay/src/core/theme/elite_martial_colors.dart';
import 'package:taekwondo_azuay/src/features/academies/domain/entities/academy.dart';
import 'package:taekwondo_azuay/src/features/academies/presentation/organisms/academy_bottom_sheet.dart';

import '../../data/models/academy_model.dart';
import '../cubit/academies_cubit.dart';
import '../cubit/academies_state.dart';


class AcademiesMapPage extends StatefulWidget {
  const AcademiesMapPage({super.key});

  @override
  State<AcademiesMapPage> createState() => _AcademiesMapPageState();
}

class _AcademiesMapPageState extends State<AcademiesMapPage> {
  Academy? _selectedAcademy;
  BitmapDescriptor? academyIcon;

  @override
  void initState() {
    super.initState();
    _loadMarker();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AcademiesCubit, AcademiesState>(
      builder: (context, state) {
        switch (state.status) {
          case AcademiesStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );

          case AcademiesStatus.error:
            return Center(
              child: Text(state.errorMessage),
            );

          case AcademiesStatus.success:
            return Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-2.9001, -79.0059),
                    zoom: 14,
                  ),
                  markers: _buildMarkers(state.academies),
                ),

                if (_selectedAcademy != null) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAcademy = null;
                        });
                      },
                      child: ColoredBox(
                        color: EliteMartialColors.primary
                            .withValues(alpha: .18),
                      ),
                    ),
                  ),

                  if (kIsWeb)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: AcademyBottomSheet(
                          academy: _selectedAcademy!,
                        ),
                      ),
                    )
                  else
                    AcademyBottomSheet(
                      academy: _selectedAcademy!,
                    ),
                ]
              ],
            );
          default:
            return const SizedBox();
        }

      },
    );
  }

  Future<void> _loadMarker() async {
    academyIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(32, 32)),
      'assets/img/map_icon.png',
    );
    setState(() {});
  }

  Set<Marker> _buildMarkers(
      List<Academy> academies,
      ) {
    return academies.map((academy) {
      return Marker(
        markerId: MarkerId(academy.id),
        position: LatLng(
          academy.latitude,
          academy.longitude,
        ),
        icon: academyIcon ?? BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(
          title: academy.name,
        ),
        onTap: () {
          setState(() {
            _selectedAcademy = academy;
          });
        },
      );
    }).toSet();
  }
}
