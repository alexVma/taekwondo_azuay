# Taekwondo Azuay

Aplicación móvil para gestión y visualización de rankings provinciales de Taekwondo en Azuay, Ecuador.

## 📋 Descripción

Taekwondo Azuay es una aplicación Flutter multiplataforma que proporciona una plataforma centralizada para:

- **Gestión de Rankings**: Visualización de rankings provinciales acumulados ordenados por posición
- **Filtrado Dinámico**: Filtros por tipo de participante, categoría, grupo y género
- **Datos en Tiempo Real**: Integración con Firebase Firestore para actualización dinámica
- **Perfiles de Atletas**: Visualización de información detallada de deportistas con avatares

## 🎯 Características Principales

- ✅ Ranking provincial con posiciones y puntuaciones acumuladas
- ✅ Filtros dinámicos cargados desde Firebase
- ✅ Avatares con soporte para imágenes en caché desde URL
- ✅ Información de eventos y participaciones históricas
- ✅ Diseño responsivo y consistente con tema Elite Martial
- ✅ Manejo robusto de estados de carga y errores
- ✅ Arquitectura limpia con separación de capas

## 🛠️ Stack Tecnológico

- **Framework**: Flutter 3.x+
- **Lenguaje**: Dart
- **Backend**: Firebase Firestore
- **Arquitectura**: Domain-Driven Design (DDD)
- **Estado**: StatefulWidget con FutureBuilder
- **Caché de Imágenes**: cached_network_image

## 📦 Requisitos Previos

- Flutter 3.0.0 o superior
- Dart 3.0.0 o superior
- Xcode 14.0+ (para iOS)
- Android Studio (para Android)
- Proyecto Firebase configurado
- Git

## 🚀 Instalación

### 1. Clonar el repositorio

```bash
git clone https://gitlab.com/tu-usuario/taekwondo-azuay.git
cd taekwondo-azuay
```

### 2. Instalar dependencias

```bash
flutter pub get
```

### 3. Configurar Firebase

1. Crear un proyecto en [Firebase Console](https://console.firebase.google.com)
2. Habilitar Firestore Database
3. Descargar `google-services.json` (Android) y `GoogleService-Info.plist` (iOS)
4. Colocar los archivos en sus respectivas carpetas:
   - Android: `android/app/`
   - iOS: `ios/Runner/`

### 4. Ejecutar la aplicación

```bash
# Desarrollo
flutter run

# Con modo verbose
flutter run -v

# Para plataforma específica
flutter run -d macos
flutter run -d iphone
```

## 📁 Estructura del Proyecto

```
lib/
├── src/
│   ├── core/
│   │   └── theme/
│   │       ├── elite_martial_colors.dart
│   │       ├── elite_martial_radii.dart
│   │       └── elite_martial_spacing.dart
│   └── features/
│       ├── home/
│       │   ├── domain/
│       │   │   └── entities/
│       │   └── presentation/
│       └── ranking/
│           ├── domain/
│           │   └── entities/
│           │       └── ranking_athlete.dart
│           ├── presentation/
│           │   ├── atoms/
│           │   │   └── ranking_filter_chip.dart
│           │   ├── molecules/
│           │   │   └── ranking_athlete_card.dart
│           │   └── pages/
│           │       └── ranking_page.dart
└── main.dart
```

## 🗄️ Estructura de Firestore

### Colecciones Principales

#### `rankings`
Documento de ranking de atleta
```json
{
  "cedula": "1234567890",
  "nombre": "Nombre del Atleta",
  "tipoParticipanteId": "doc_id",
  "categoriaId": "doc_id",
  "grupoId": "doc_id",
  "generoId": "doc_id",
  "puesto": 1,
  "acumulado": 850.5,
  "imageUrl": "https://url-imagen.com/atleta.jpg"
}
```

#### `tiposParticipante`
```json
{
  "nombre": "Individual",
  "activo": true,
  "fechaCreacion": "timestamp"
}
```

#### `categorias`
```json
{
  "nombre": "Cadetes",
  "activo": true,
  "fechaCreacion": "timestamp"
}
```

#### `grupos`
```json
{
  "nombre": "Gup (Colores)",
  "activo": true,
  "fechaCreacion": "timestamp"
}
```

#### `generos`
```json
{
  "nombre": "Masculino",
  "activo": true,
  "fechaCreacion": "timestamp"
}
```

#### `deportistas`
```json
{
  "cedula": "1234567890",
  "nombre": "Nombre del Atleta"
}
```

#### `participaciones`
```json
{
  "cedula": "1234567890",
  "nombre": "Nombre del Atleta",
  "anio": 2024,
  "evento": "Campeonato Nacional",
  "ubicacion": 1,
  "puntos": 100.5,
  "acumulado": 250.5
}
```

## 📊 Migración de Datos

### Importar Rankings desde JSON

Se incluye la clase `RankingImporter` para importar datos desde `assets/ranking.json`:

```dart
// En main.dart o en un botón de administración
final importer = RankingImporter();
await importer.importar();
```

### Proceso de Importación

1. **Limpieza**: Borra todas las colecciones existentes
2. **Creación de Catálogos**: Crea registros únicos en tiposParticipante, categorias, grupos, generos
3. **Importación de Atletas**: Crea documentos en deportistas y rankings
4. **Historial de Participaciones**: Crea registros en participaciones

### Formato del JSON

```json
[
  {
    "tipoParticipante": "Individual",
    "categoria": "Cadetes",
    "grupo": "Gup (Colores)",
    "genero": "Masculino",
    "ranking": [
      {
        "cedula": "1234567890",
        "nombre": "Mateo Sebastian Jaramillo",
        "puesto": 1,
        "acumulado": "850,50",
        "historial": [
          {
            "evento": "Campeonato Nacional",
            "anio": "2024",
            "ubicacion": "1",
            "puntos": "100,50",
            "acumulado": "850,50"
          }
        ]
      }
    ]
  }
]
```

## 🎨 Tema y Estilos

El proyecto utiliza un sistema de temas personalizado basado en Material Design 3:

- **Colores**: `EliteMartialColors`
- **Espaciado**: `EliteMartialSpacing`
- **Bordes**: `EliteMartialRadii`

Para personalizar, editar:
- `lib/src/core/theme/elite_martial_colors.dart`
- `lib/src/core/theme/elite_martial_spacing.dart`
- `lib/src/core/theme/elite_martial_radii.dart`

## 🔍 Filtrado de Rankings

Los atletas se filtran dinámicamente basándose en:

1. **Tipo de Participante**: Individual, Pareja, Equipo
2. **Categoría**: Pre-Cadetes, Cadetes, Junior, etc.
3. **Grupo/Cinturón**: Gup (Colores), Poom/Dan (Negro)
4. **Género**: Masculino, Femenino

Los filtros se preseleccionan automáticamente en la primera carga, mostrando solo los atletas que coinciden con la primera opción de cada categoría.

## 🐛 Manejo de Errores

- **Errores de Carga**: Mensajes amigables al usuario
- **Campos Faltantes**: Valores por defecto configurados
- **Imágenes No Disponibles**: Muestra ícono de persona como fallback
- **Conexión Firebase**: Reintentos automáticos

## 📱 Compatibilidad

- **iOS**: 11.0+
- **Android**: API 21+
- **Web**: Chrome, Firefox, Safari
- **Desktop**: macOS, Windows, Linux

## 🧪 Testing

Para ejecutar pruebas unitarias:

```bash
flutter test
```

## 📚 Documentación Adicional

- [Flutter Docs](https://flutter.dev/docs)
- [Firebase Docs](https://firebase.google.com/docs)
- [Dart Docs](https://dart.dev/guides)

## 🔐 Variables de Entorno

Crear archivo `.env` en la raíz del proyecto (si es necesario):

```env
FIREBASE_PROJECT_ID=azuaytkd
FIREBASE_API_KEY=your_api_key
```

## 🚢 Deployment

### iOS
```bash
flutter build ios --release
```

### Android
```bash
flutter build apk --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contribución

Las contribuciones son bienvenidas. Por favor:

1. Fork el proyecto
2. Crear una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abrir un Pull Request

## 📝 Guía de Código

- Usar nombres descriptivos en inglés
- Comentar solo la lógica compleja
- Mantener funciones pequeñas y enfocadas
- Usar análisis estático: `flutter analyze`

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver archivo `LICENSE` para más detalles.

## 👥 Autores

- **Alex Mingaarias** - Desarrollo inicial

## 📧 Contacto

Para preguntas o sugerencias, contactar a:
- Email: ClaudeGDA6@netlife.net.ec

## 🎉 Agradecimientos

- Firebase por la infraestructura
- Flutter por el framework
- Material Design por la guía de diseño

---

**Versión**: 1.0.0  
**Última Actualización**: 2026-07-20  
**Estado**: En Desarrollo
