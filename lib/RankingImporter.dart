import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class RankingImporter {

  final FirebaseFirestore db = FirebaseFirestore.instance;
  final Map<String, String> categoriasCache = {};
  final Map<String, String> gruposCache = {};
  final Map<String, String> generosCache = {};
  final Map<String, String> tiposCache = {};

  String normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll("á", "a")
        .replaceAll("é", "e")
        .replaceAll("í", "i")
        .replaceAll("ó", "o")
        .replaceAll("ú", "u")
        .replaceAll("ñ", "n")
        .replaceAll(RegExp(r'[^a-z0-9]+'), "_")
        .replaceAll(RegExp(r'_+'), "_")
        .replaceAll(RegExp(r'^_|_$'), "");
  }

  double toDouble(String value) {
    return double.parse(value.replaceAll(".", "").replaceAll(",", "."));
  }

  Future<void> importar() async {
    final jsonString = await rootBundle.loadString("assets/ranking.json");
    final List<dynamic> data = jsonDecode(jsonString);
    WriteBatch batch = db.batch();
    int operaciones = 0;

    Future<void> commitSiNecesario() async {
      if (operaciones >= 450) {
        await batch.commit();
        batch = db.batch();
        operaciones = 0;
      }
    }

    for (final bloque in data) {
      //=========================
      // CATÁLOGOS
      //=========================
      final tipoId = await obtenerOCrearCatalogo(
        "tiposParticipante",
        bloque["tipoParticipante"],
        tiposCache
      );

      final categoriaId = await obtenerOCrearCatalogo(
        "categorias",
        bloque["categoria"],
        categoriasCache
      );

      final grupoId = await obtenerOCrearCatalogo(
        "grupos",
        bloque["grupo"],
        gruposCache
      );

      final generoId = await obtenerOCrearCatalogo(
        "generos",
        bloque["genero"],
        generosCache
      );


      for (final atleta in bloque["ranking"]) {

        final cedula = atleta["cedula"];

        //----------------------------------------------------
        // Deportista
        //----------------------------------------------------
        batch.set(
          db.collection("deportistas").doc(cedula),
          {
            "cedula": cedula,
            "nombre": atleta["nombre"]
          },
          SetOptions(merge: true),
        );

        operaciones++;

        //----------------------------------------------------
        // Ranking
        //----------------------------------------------------
        batch.set(
          db.collection("rankings").doc(),
          {
            "cedula": cedula,
            "nombre": atleta["nombre"],

            "tipoParticipanteId": tipoId,
            "categoriaId": categoriaId,
            "grupoId": grupoId,
            "generoId": generoId,

            "puesto": atleta["puesto"],
            "acumulado": toDouble(atleta["acumulado"]),
          },
          SetOptions(merge: true),
        );

        operaciones++;

        //----------------------------------------------------
        // Participaciones
        //----------------------------------------------------

        for (final h in atleta["historial"]) {

          final participacionId =
              "${cedula}_${normalize(h["evento"])}_${h["anio"]}";

          batch.set(
            db.collection("participaciones").doc(participacionId),
            {
              "cedula": cedula,
              "nombre": atleta["nombre"],

              "anio": int.parse(h["anio"]),

              "evento": h["evento"],

              "ubicacion": int.parse(h["ubicacion"]),

              "puntos": toDouble(h["puntos"]),

              "acumulado": toDouble(h["acumulado"])
            },
            SetOptions(merge: true),
          );

          operaciones++;
        }

        await commitSiNecesario();
      }
    }

    if (operaciones > 0) {
      await batch.commit();
    }

    print("IMPORTACIÓN TERMINADA");
  }

  Future<String> obtenerOCrearCatalogo(
      String coleccion,
      String nombre,
      Map<String, String> cache,
      ) async {

    // 1. Ya está en memoria
    if (cache.containsKey(nombre)) {
      return cache[nombre]!;
    }

    final doc = db.collection(coleccion).doc();

    await doc.set({
      "nombre": nombre,
      "activo": true,
      "fechaCreacion": FieldValue.serverTimestamp(),
    });

    cache[nombre] = doc.id;

    return doc.id;
  }

}