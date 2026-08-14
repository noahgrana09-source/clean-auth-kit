# Clean Auth Kit

A production-grade authentication feature for Flutter, built with Clean Architecture. Email/password and Google Sign-In on Firebase, adaptive Material/Cupertino UI, an animated Rive illustration wired to real auth state, native autofill support, and full English/Spanish localization.

**Live demo:** https://product-searcher-5e109.web.app *(best experienced as a native Android/iOS build — see [Known limitations](#known-limitations))*

## Demo

| Google Sign-In | Email login | Registration |
|---|---|---|
| <video src="assets/gifs/google_auth.mp4" controls muted loop playsinline width="260"></video> | <video src="assets/gifs/login.mp4" controls muted loop playsinline width="260"></video> | <video src="assets/gifs/register.mp4" controls muted loop playsinline width="260"></video> |

## Table of contents

- [What this project is](#what-this-project-is)
- [Architecture and domain entity](#architecture-and-domain-entity)
- [Engineering highlights](#engineering-highlights)
- [Project structure](#project-structure)
- [Main dependencies](#main-dependencies)
- [Running the project](#running-the-project)
- [Testing](#testing)
- [Extra commands](#extra-commands)
- [Known limitations](#known-limitations)
- [License](#license)

## What this project is

This started as a broader "product searcher" app idea and, over the course of development, narrowed down into what turned out to be the most interesting engineering problem in it: **authentication done right**. There's no product search here — the repository name is a leftover of that original scope. What remains is a focused, deeply-tested auth feature: sign up, sign in, Google Sign-In, session persistence, and everything that goes wrong around them in a real app (orphaned accounts, stale error state, cancelled OAuth flows, token refresh).

It's meant to be read as a portfolio piece — a demonstration of how a single feature gets built when correctness and maintainability are the actual goal, not just "does it work once."

## Architecture and domain entity

The code follows **Clean Architecture**, split into three layers per feature:

- **`domain/`** — pure Dart, no Flutter or Firebase imports. Defines the business rules: the `UserEntity`, the `AuthRepository` contract, and one use case per action (`SignInWithEmailUseCase`, `SignInWithGoogleUseCase`, `SignUpWithEmailUseCase`, `SignOutUseCase`, `GetCurrentUserUseCase`).
- **`data/`** — implements the domain contracts against real services (Firebase Auth, Firestore, Google Sign-In). Translates platform exceptions into typed `Failure`s so nothing above this layer ever touches a `FirebaseAuthException` directly.
- **`presentation/`** — Riverpod providers/notifiers and widgets. Never talks to Firebase directly; only calls use cases.

The domain entity, `UserEntity`, is the single business concept the whole app revolves around:

```dart
UserEntity({
  required String uid,
  required String email,
  String? displayName,
  String? photoUrl,
  bool isEmailVerified,
  required DateTime createdAt,
})
```

A `UserEntity` is created once, in Firestore, at sign-up/first Google sign-in, and is treated as immutable afterward — the security rules only allow a user to `read`/`create` their own document, never `update`/`delete` it (`firestore.rules`).

## Engineering highlights

A few decisions worth calling out specifically, since they're the parts most likely to matter to someone evaluating this code:

- **Compensating-transaction rollback.** If writing the user's profile to Firestore fails right after Firebase Auth creates the account, the just-created Auth account is deleted to avoid an orphaned account with no profile. For Google Sign-In, this only happens if the sign-in *just* created the account (`isNewUser`) — an existing user is never deleted over a transient read/write failure.
- **Typed failures with codes.** Every `Failure` carries a `code` (mirroring the originating Firebase error code where applicable), so the presentation layer can make precise UI decisions (e.g. "wrong password" vs. "network error") without string-matching error messages.
- **Native autofill integration.** Correct `AutofillHints` per field (`username`+`email` combined on the login identifier field, `newPassword` on both password fields at registration, `newUsername`+`email` on the registration email field) so the OS password manager actually offers to save credentials.
- **Full i18n**, using Flutter's official `flutter_localizations` + ARB pipeline — not a hand-rolled string-switching helper.
- **A Rive state machine wired to real app state**, not just decoration: the illustration reacts to password-field focus and fires success/failure triggers based on the actual `AuthState`.
- **Real test coverage** with `mocktail` across use cases, the repository, and the remote data source — including the trickier cases (mocking exceptions thrown by static Firebase methods, Google Sign-In cancellation).

## Project structure

```
lib/
├── main.dart                          # Entry point: Firebase/Rive init, MaterialApp, i18n wiring
├── firebase_options.dart              # Generated by FlutterFire CLI (Android/iOS/Web)
├── core/
│   ├── error/failures.dart            # Failure hierarchy (AuthFailure, GoogleSignInFailure, ServerFailure, UserPersistenceFailure)
│   ├── l10n/                          # ARB source files + generated AppLocalizations
│   ├── theme/                         # Colors, text styles, light/dark ThemeData
│   ├── usecases/usecase.dart          # Base UseCase<Type, Params> contract
│   └── utils/platform_utils.dart      # Material vs. Cupertino platform detection
└── features/auth/
    ├── domain/
    │   ├── entities/user_entity.dart
    │   ├── repositories/auth_repository.dart      # Abstract contract
    │   └── usecases/                              # One class per action
    ├── data/
    │   ├── datasources/auth_remote_datasource.dart # Firebase Auth + Firestore + Google Sign-In
    │   ├── models/user_model.dart                  # Firestore/Firebase (de)serialization
    │   └── repositories/auth_repository_impl.dart  # Exception → Failure translation
    └── presentation/
        ├── providers/         # Riverpod notifier, state, DI providers (code-generated)
        ├── screens/           # LoginScreen, RegisterScreen, AuthWrapper
        └── widgets/           # Adaptive form fields/buttons, Rive illustration, error banner

test/features/auth/
├── domain/usecases/           # One test file per use case
└── data/                      # Repository and data source tests, with shared mock setups

android/, ios/, web/            # Platform shells (Android and iOS are the primary targets)
firestore.rules, firebase.json  # Firestore security rules + Hosting config
```

## Main dependencies

| Package | Role |
|---|---|
| `firebase_core`, `firebase_auth`, `cloud_firestore` | Firebase SDK: app init, authentication, user profile storage |
| `google_sign_in` (7.2.0) | Google OAuth flow, new singleton (`GoogleSignIn.instance`) reactive API |
| `flutter_riverpod`, `riverpod_annotation` | State management and dependency injection, with code generation |
| `dartz` | `Either<Failure, T>` for functional, exception-free error handling across layers |
| `freezed_annotation`, `json_annotation` | Immutable data classes, `copyWith`, value equality, and JSON (de)serialization via code generation |
| `equatable` | Value equality for use case parameter objects |
| `rive` | Runtime for the animated login/register illustration, driven by a state machine |
| `flutter_svg` | Renders the Google logo (embedded as an SVG string, no external asset) |
| `flutter_localizations`, `intl` | Official Flutter i18n pipeline (ARB → generated `AppLocalizations`) |
| `mocktail` *(dev)* | Mocking for unit tests |
| `build_runner`, `freezed`, `json_serializable`, `riverpod_generator` *(dev)* | Code generation |

## Running the project

There are three ways to try this project, depending on how much you want to set up:

### 1. Web demo (no install)

https://product-searcher-5e109.web.app — connects to the project's own Firebase backend, ready to use.

### 2. Download the Android APK (no Flutter SDK needed)

Grab the latest `app-release.apk` from the [Releases](../../releases) page and sideload it on any Android device. It's signed and connects to the same Firebase backend as the web demo — no setup required.

### 3. Build from source (your own Firebase project)

**Prerequisites:** Flutter SDK (`^3.11.1` per `pubspec.yaml`), and your own Firebase project (Authentication with Email/Password + Google providers enabled, and Cloud Firestore).

1. Clone the repo and run `flutter pub get`.
2. Install the [FlutterFire CLI](https://firebase.google.com/docs/flutter/setup) and run `flutterfire configure` against your own Firebase project — this regenerates `lib/firebase_options.dart` and the platform config files (`google-services.json` / `GoogleService-Info.plist`) for your project. This repo's own Firebase project is not something you can configure into your own build.
3. Deploy `firestore.rules` to your project: `firebase deploy --only firestore:rules`.
4. Run the app: `flutter run` (pick a device — Android, iOS, or Chrome).

## Testing

```
flutter test
```

Coverage focuses on the domain and data layers (use cases, repository, remote data source) — the layers where the actual business logic and error-handling decisions live.

## Extra commands

- **Toggle the Rive illustration at build time:**
  ```
  flutter run --dart-define=USE_APP_ILLUSTRATION=true
  ```
- **Build and deploy the web version** (requires the Firebase CLI, authenticated against your own project):
  ```
  flutter build web
  firebase deploy --only hosting
  ```

## Known limitations

Said plainly, since a portfolio project is more useful when its gaps are visible rather than discovered:

- **No widget/integration tests** — coverage stops at the domain and data layers; screens and widgets aren't tested.
- **iOS has never been built on real hardware.** Development happened entirely on Linux; the iOS configuration exists (`firebase_options.dart`, `Info.plist`) but has only been reasoned about, never run.
- **Flutter Web has real, known performance overhead** on Firebase Auth/Firestore calls (the JS-interop SDK layer is slower than the native SDKs Android/iOS use) — the web build is a convenience demo, not the intended primary experience.

## License

MIT — see [LICENSE](LICENSE).
