# Fotolou

Base Flutter structurée en **Feature-First Clean Architecture** pour une application mobile Android/iOS maintenable, testable et évolutive.

## Architecture

Le code applicatif est organisé par fonctionnalités. Chaque feature garde ses responsabilités dans trois couches :

```text
lib/
  app/                  # bootstrap, configuration, routes, thème
  core/                 # briques transverses réutilisables
  features/
    authentication/
      data/             # modèles, DTO, datasources, repositories implémentés
      domain/           # entités, contrats, use cases, règles métier
      presentation/     # pages, widgets, états, controllers Riverpod
  shared/               # modèles/extensions/widgets vraiment partagés
```

Règle de dépendance stricte :

```text
presentation -> domain
data -> domain
domain -> aucune dépendance vers data, presentation ou Flutter
```

La couche `domain` ne connaît ni Dio, ni Flutter, ni stockage local. Les contrats de repositories y sont déclarés, les implémentations techniques restent dans `data`.

## Principaux Dossiers

- `lib/app/bootstrap.dart` : initialisation Flutter, configuration d’environnement, erreurs globales, lancement de l’application.
- `lib/app/routes/` : configuration GoRouter, routes nommées, redirections d’authentification, page 404.
- `lib/app/theme/` : design tokens, thème clair/sombre, boutons et champs.
- `lib/core/dependency_injection/providers.dart` : providers Riverpod centralisés pour clients HTTP, storage, datasources, repositories, use cases et controllers.
- `lib/core/network/` : client Dio encapsulé, interceptors, timeout, logs dev, transformation Dio vers exceptions métier.
- `lib/core/errors/`, `lib/core/exceptions/`, `lib/core/failures/` : séparation exceptions techniques et failures métier.
- `lib/core/utils/result.dart` : type `Result<T>` explicite pour éviter les exceptions qui traversent les couches.
- `lib/features/authentication/` : feature complète de référence.

## Dépendances

- `flutter_riverpod` : injection de dépendances et state management.
- `go_router` : navigation centralisée et routes protégées.
- `dio` : client HTTP.
- `flutter_secure_storage` : stockage sécurisé des tokens.
- `flutter_svg` : rendu local des icônes et illustrations SVG exportées depuis Figma.
- `connectivity_plus` : vérification réseau avant requête.
- `equatable` : égalité fiable des entités, states et failures.
- `logger` : logs applicatifs contrôlés par environnement.
- `mocktail` : mocks de tests sans génération.
- `build_runner`, `json_annotation` et `json_serializable` : génération JSON des modèles/DTO data.

## Commandes

Le projet est aligné sur Flutter `3.38.3` (Dart `3.10.1`). Avec FVM :

```bash
fvm install
fvm flutter pub get
```

Installation :

```bash
flutter pub get
```

Lancer en développement :

```bash
flutter run --dart-define=APP_ENV=development
```

Environnements disponibles :

```bash
flutter run --dart-define=APP_ENV=development
flutter run --dart-define=APP_ENV=staging
flutter run --dart-define=APP_ENV=production
```

Génération de code si des modèles annotés sont ajoutés :

```bash
dart run build_runner build
```

Qualité :

```bash
dart format .
flutter analyze
flutter test
```

## Authentification de Référence

La feature `authentication` contient :

- `UserEntity`, `LoginCredentials`, `AuthRepository`, `LoginUseCase`, `LogoutUseCase`, `GetCurrentUserUseCase`.
- `UserModel`, `LoginRequestDto`, `AuthSessionModel`, `AuthRemoteDataSource`, `AuthLocalDataSource`, `AuthRepositoryImpl`.
- Génération JSON concrète avec `json_serializable` pour les modèles et DTO de la couche data.
- `AuthState`, `AuthController`, `LoginPage`, `LoginForm`.

Par défaut, `development` utilise `MockAuthRemoteDataSource`. Pour brancher une vraie API, désactiver `useMockAuthentication` dans `AppConfig`, puis adapter uniquement `DioAuthRemoteDataSource` au contrat backend. Le domaine et les widgets ne changent pas.

## Onboarding

Les écrans Figma intégrés dans `lib/features/onboarding/` couvrent :

- `/splash` : splash Fotolou.
- `/onboarding` : trois slides d’onboarding.
- `/phone-login` : saisie du numéro de téléphone.
- `/otp` : vérification du code OTP.

## Ajouter Une Feature

Créer la structure :

```text
lib/features/catalog/
  data/
    datasources/
    models/
    repositories/
  domain/
    entities/
    repositories/
    usecases/
  presentation/
    controllers/
    pages/
    states/
    widgets/
```

Procédure :

1. Définir les entités et contrats dans `domain`.
2. Créer un use case par action métier.
3. Implémenter les modèles, mappers et datasources dans `data`.
4. Implémenter le repository concret dans `data/repositories`.
5. Déclarer les providers dans `core/dependency_injection/providers.dart` ou dans un module de DI dédié à la feature si le fichier devient trop grand.
6. Construire les pages/widgets dans `presentation` sans appel HTTP direct.
7. Ajouter les tests unitaires et widgets avant de connecter l’écran final.

Exemple : une feature `catalog` aurait `GetProductsUseCase`, `CatalogRepository`, `ProductModel`, `ProductEntity`, `CatalogController` et `CatalogPage`. `CatalogPage` lit `CatalogController`; le controller appelle le use case; le use case dépend du contrat `CatalogRepository`; l’implémentation data choisit l’API ou un cache.

## Conventions

- Un fichier par classe principale lorsque cela améliore la lisibilité.
- Suffixes explicites : `Entity`, `Model`, `Dto`, `UseCase`, `Repository`, `DataSource`, `Controller`, `State`.
- Imports via `package:fotolou/...`.
- Widgets sans logique métier.
- `const` et `final` dès que possible.
- Pas de classe `Helper` générale, pas de `utils.dart` fourre-tout.
- Exceptions techniques dans `data/core`, failures lisibles côté domaine/presentation.

## Erreurs À Éviter

- Importer Flutter dans `domain`.
- Appeler Dio, SharedPreferences ou FlutterSecureStorage depuis un widget ou un use case.
- Retourner une `DioException` hors du client réseau.
- Mélanger entité métier et sérialisation JSON.
- Ajouter un composant dans `shared/widgets` s’il n’est utilisé que par une feature.
- Créer une interface trop large pour plusieurs besoins distincts.
- Stocker un secret sensible dans le code source.

## Tests

Exemples inclus :

- use case : `test/features/authentication/domain/usecases/login_use_case_test.dart`
- repository : `test/features/authentication/data/repositories/auth_repository_impl_test.dart`
- data source : `test/features/authentication/data/datasources/auth_remote_data_source_test.dart`
- controller Riverpod : `test/features/authentication/presentation/controllers/auth_controller_test.dart`
- widget : `test/features/authentication/presentation/widgets/login_form_test.dart`
- mapper : `test/features/authentication/data/models/user_model_mapper_test.dart`
