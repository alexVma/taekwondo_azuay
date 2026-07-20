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

  Future<void> borrarColecciones() async {
    print("🗑️  Borrando colecciones existentes...");

    final colecciones = ["deportistas", "rankings", "participaciones", "categorias", "grupos", "generos", "tiposParticipante"];

    for (final coleccion in colecciones) {
      try {
        final docs = await db.collection(coleccion).get();
        print("   • Borrando ${docs.docs.length} documentos de '$coleccion'");

        WriteBatch batch = db.batch();
        int operaciones = 0;

        for (final doc in docs.docs) {
          batch.delete(doc.reference);
          operaciones++;

          if (operaciones >= 450) {
            await batch.commit();
            batch = db.batch();
            operaciones = 0;
          }
        }

        if (operaciones > 0) {
          await batch.commit();
        }
      } catch (e) {
        print("   ⚠️  Error al borrar '$coleccion': $e");
      }
    }

    print("✅ Colecciones limpiadas\n");
    categoriasCache.clear();
    gruposCache.clear();
    generosCache.clear();
    tiposCache.clear();
  }

  Future<void> importar() async {
    try {
      print("🚀 Iniciando importación de ranking...");
      await borrarColecciones();

      final jsonString = await rootBundle.loadString("assets/ranking.json");
      final List<dynamic> data = jsonDecode(jsonString);

      WriteBatch batch = db.batch();
      int operaciones = 0;
      int atletesTotales = 0;
      int participacionesTotales = 0;

      Future<void> commitSiNecesario() async {
        if (operaciones >= 450) {
          await batch.commit();
          batch = db.batch();
          operaciones = 0;
          print("✅ Batch committeado");
        }
      }

      for (int bloqueIdx = 0; bloqueIdx < data.length; bloqueIdx++) {
        final bloque = data[bloqueIdx];

        if (bloque["tipoParticipante"] == null ||
            bloque["categoria"] == null ||
            bloque["grupo"] == null ||
            bloque["genero"] == null ||
            bloque["ranking"] == null) {
          print("⚠️ Bloque $bloqueIdx inválido, saltando...");
          continue;
        }

        if ((bloque["ranking"] as List).isEmpty) {
          print("⏭️  Bloque ${bloqueIdx + 1}/${data.length}: ${bloque["categoria"]} (ranking vacío, saltando)");
          continue;
        }

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

        print("📦 Procesando bloque ${bloqueIdx + 1}/${data.length}: ${bloque["categoria"]} (${(bloque["ranking"] as List).length} atletas)");

        for (final atleta in bloque["ranking"]) {
          if (atleta["cedula"] == null || atleta["nombre"] == null) {
            print("⚠️ Atleta inválido en bloque $bloqueIdx, saltando...");
            continue;
          }

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
          atletesTotales++;

          //----------------------------------------------------
          // Participaciones
          //----------------------------------------------------

          if (atleta["historial"] != null) {
            for (final h in atleta["historial"]) {
              if (h["evento"] == null || h["anio"] == null || h["ubicacion"] == null || h["puntos"] == null || h["acumulado"] == null) {
                print("⚠️ Participación inválida para atleta $cedula, saltando...");
                continue;
              }

              final participacionId =
                  "${cedula}_${normalize(h["evento"])}_${h["anio"]}";

              batch.set(
                db.collection("participaciones").doc(participacionId),
                {
                  "cedula": cedula,
                  "nombre": atleta["nombre"],

                  "anio": int.parse(h["anio"].toString()),

                  "evento": h["evento"],

                  "ubicacion": int.parse(h["ubicacion"].toString()),

                  "puntos": toDouble(h["puntos"].toString()),

                  "acumulado": toDouble(h["acumulado"].toString())
                },
                SetOptions(merge: true),
              );

              operaciones++;
              participacionesTotales++;
            }
          }

          await commitSiNecesario();
        }
      }

      if (operaciones > 0) {
        await batch.commit();
        print("✅ Batch final committeado");
      }

      print("\n✅ IMPORTACIÓN COMPLETADA");
      print("📊 Resumen:");
      print("   • Atletas importados: $atletesTotales");
      print("   • Participaciones importadas: $participacionesTotales");
      print("   • Catálogos creados: ${categoriasCache.length + gruposCache.length + generosCache.length + tiposCache.length}");
    } catch (e) {
      print("\n❌ ERROR EN IMPORTACIÓN: $e");
      rethrow;
    }
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