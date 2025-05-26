![TrainTrack](https://github.com/user-attachments/assets/9e8b7443-5e36-4cb4-813f-940974403a54)
## Descripción
TrainTrack es un asistente de entrenamiento diseñado para personas que buscan una aplicación cómoda y ágil para planificar su propio entrenamiento. La aplicación ofrece una experiencia sin publicidad, con un límite amplio de ejercicios y una interfaz agradable.

Este proyecto será presentado como Trabajo de Fin de Grado (TFG) en Desarrollo de Aplicaciones Multiplataforma (DAM), pero el objetivo es continuar su desarrollo y mejora a largo plazo.

## Características principales
- Planificación de entrenamientos de manera sencilla y eficiente.
- Sin anuncios ni interrupciones.
- Amplia capacidad para almacenar rutinas personalizadas.
- Interfaz moderna y amigable para el usuario.
- Rutinas e historial almacenados en la nube.
- Estadísticas gráficas.
- Añade tus propios ejercicios con nombre e imagen personalizada.
- Integración con Firebase para autenticación y almacenamiento de datos.

## Estado actual
¡Ya la puedes encontrar en Play Store!, Actualmente está publicada en Producción, ya se han implementado múltiples mejoras sugeridas por los usuarios que ejercieron de beta testers y hay una lista de nuevas características que se seguirán añadiendo con el paso del tiempo.

## Estructura del proyecto
El proyecto sigue una arquitectura limpia pero reducida, utilizando **Flutter** para el desarrollo multiplataforma y **Firebase** para la gestión de usuarios y almacenamiento de datos.

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


