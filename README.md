![TrainTrack](https://github.com/user-attachments/assets/9e8b7443-5e36-4cb4-813f-940974403a54)
# TrainTrack – Tu asistente de entrenamiento personalizado
TrainTrack es una aplicación móvil desarrollada con Flutter y Firebase, pensada para ser el compañero ideal de quienes entrenan en el gimnasio. Está diseñada para ayudar a los usuarios a planificar, registrar y analizar su progreso físico de manera sencilla, eficiente y totalmente personalizada.

## Objetivo del proyecto
El propósito de TrainTrack es facilitar la creación y seguimiento de rutinas de entrenamiento, centralizar los datos del progreso del usuario (como marcas personales y sesiones pasadas), y ofrecer estadísticas visuales claras para motivar y orientar el rendimiento a lo largo del tiempo, todo ello sin publicidad y con un límite muy amplio para almacenar rutinas personalizadas.

Este proyecto ha sido desarrollado como proyecto de fin de ciclo del grado superior en Desarrollo de Aplicaciones Multiplataforma (DAM), aplicando una arquitectura limpia y buenas prácticas modernas en desarrollo móvil.

## Estado actual
¡Ya la puedes encontrar en Play Store!, Actualmente está publicada en Producción, ya se han implementado múltiples mejoras sugeridas por los usuarios que ejercieron de beta testers y hay una lista de nuevas características que se seguirán añadiendo con el paso del tiempo.

---

## Tecnologías utilizadas

- **Flutter** + **Dart** – Desarrollo móvil multiplataforma.
- **Firebase**:
  - Authentication
  - Cloud Firestore
  - Firebase Crashlytics
- **Riverpod** – Gestión de estado moderna y escalable.
- **Local Storage** – Para ejercicios personalizados.

## Estructura del proyecto

Al registrarse, cada usuario tiene un documento dentro de la colección `usuarios` en Firestore. Este documento contiene subcolecciones organizadas así:

- `rutinas`: Rutinas de entrenamiento creadas o asignadas.
- `historial`: Registro de entrenamientos realizados.

Los **ejercicios personalizados** se almacenan localmente.

## Funcionalidades principales

### Registro y autenticación
- Registro e inicio de sesión con correo y contraseña.
- Creación automática del documento base en Firestore al registrarse.

### Gestión de rutinas y ejercicios
- Crear rutinas personalizadas por días.
- Consultar, editar y registrar entrenamientos.
- Registro de series, repeticiones y pesos.

### Ejercicios personalizados
- Añadir ejercicios no incluidos por defecto.
- Selección de imagen desde galería.
- Guardado en almacenamiento local.

### Estadísticas visuales
- Gráfica heptagonal con número de entrenamientos por grupo muscular.
- Filtro por mes para observar progresos.

## Interfaz de usuario

- UI moderna, minimalista e intuitiva.
- Arquitectura desacoplada usando **Riverpod**.
- Navegación dividida en secciones: Rutinas, Historial, Estadísticas y Perfil.

## Arquitectura y buenas prácticas

- Arquitectura limpia con separación por capas:
  - Presentación
  - Lógica de negocio
  - Acceso a datos
- Código modular, escalable y testeable.
- Uso de `hooks` y proveedores para el estado.

---

## Configuración del proyecto
Al clonar este repositorio, hay dos archivos que **no están incluidos** por motivos de seguridad, ya que contienen claves API sensibles:

- `android/app/google-services.json`
- `lib/config/firebase/firebase_options.dart`

### Pasos para configurar el entorno:
1. **Generar el archivo `google-services.json`**
   - Accede a [Firebase Console](https://console.firebase.google.com/).
   - Selecciona tu proyecto y ve a la configuración de Android.
   - Descarga el archivo `google-services.json` y colócalo en `android/app/`.

2. **Configurar `firebase_options.dart`**
   - Ejecuta el siguiente comando para generar automáticamente el archivo:
     ```sh
     flutterfire configure
     ```
   - Asegúrate de seleccionar el proyecto correcto en Firebase.
   - El archivo generado se ubicará en `lib/config/firebase/`.

## Instalación y ejecución
### 1. Clonar el repositorio
```sh
git clone https://github.com/tu-usuario/traintrack.git
cd traintrack
```

### 2. Instalar dependencias
```sh
flutter pub get
```

### 3. Ejecutar la aplicación
Para ejecutar en un emulador o dispositivo físico:
```sh
flutter run
```

## Contribución
Si deseas contribuir a este proyecto, puedes hacer un **fork** del repositorio y enviar un **pull request** con tus mejoras.

## Licencia
Este proyecto se encuentra bajo la licencia MIT.


