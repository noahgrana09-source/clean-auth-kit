# product_searcher

A new Flutter project.

## Configuración

### Ilustración de las pantallas de autenticación

Por defecto, `LoginScreen` y `RegisterScreen` muestran una animación de
[Rive](https://rive.app) (`assets/rive/robot_sign_in.riv`), controlable en
tiempo real por el estado de autenticación de la app.

Para usar en su lugar la ilustración propia (un candado animado, sin
dependencia de Rive), corré la app con el flag `USE_APP_ILLUSTRATION`:

```bash
flutter run --dart-define=USE_APP_ILLUSTRATION=true
```

Sin el flag (o con `USE_APP_ILLUSTRATION=false`), se usa la animación de
Rive. El flag se resuelve en tiempo de compilación — no hay forma de
alternar entre ambas dentro de la app en ejecución, hay que volver a
correr/compilar con el valor deseado.
