
# ClassMaster Flutter Project

This is a Flutter application designed with a clean architecture approach, modular features, and a well-organized folder structure. It serves as a foundation for building scalable and maintainable mobile applications.

## Table of Contents

- [Folder Structure](#folder-structure)
- [Project Description](#project-description)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)
- [Contributing](#contributing)
- [License](#license)

## Folder Structure

The project follows a clean architecture pattern with separation of concerns across core, features, route, services, and UI directories.

```
lib/
├── core/
│   ├── constant/
│   │   └── constant.dart              # Constants like API base URL
│   ├── local_data/
│   │   ├── api_cache_manager.dart     # Local caching logic
│   │   └── local_data.dart            # Local storage utilities
│   └── export_core.dart               # Core exports (e.g., AppException)
├── features/
│   ├── account_features/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── account_request.dart  # API and cache operations
│   │   │   └── models/
│   │   │       ├── account_models.dart   # Account data models
│   │   │       └── account_update.dart   # Account update model
│   │   ├── domain/
│   │   │   ├── providers/
│   │   │   │   └── account_providers.dart # Riverpod providers
│   │   │   └── repositories/
│   │   │       └── account_repository.dart # Abstract repository
│   │   └── presentation/
│   │       └── utils/
│   │           └── edit_account_validation.dart # Form validation
│   ├── authentication_features/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_request.dart    # Authentication API calls
│   │   │   └── models/
│   │   │       ├── auth_models.dart    # Authentication models [Placeholder]
│   │   ├── domain/
│   │   │   ├── providers/
│   │   │   │   └── auth_providers.dart  # Auth providers [Placeholder]
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart  # Auth repository [Placeholder]
│   │   └── presentation/
│   │       └── utils/
│   │           └── auth_validation.dart  # Auth validation [Placeholder]
│   ├── collection_features/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── collection_request.dart # Collection API calls [Placeholder]
│   │   │   └── models/
│   │   │       ├── collection_models.dart # Collection models [Placeholder]
│   │   ├── domain/
│   │   │   ├── providers/
│   │   │   │   └── collection_providers.dart # Collection providers [Placeholder]
│   │   │   └── repositories/
│   │   │       └── collection_repository.dart # Collection repository [Placeholder]
│   │   └── presentation/
│   │       └── utils/
│   │           └── collection_utils.dart  # Collection utils [Placeholder]
│   ├── home_features/
│   │   └── presentation/
│   │       └── utils/
│   │           └── utils.dart  # Home feature utilities
│   └── notice_features/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── notice_request.dart # Notice API calls [Placeholder]
│       │   └── models/
│       │       ├── notice_models.dart  # Notice models [Placeholder]
│       ├── domain/
│       │   ├── providers/
│       │   │   └── notice_providers.dart  # Notice providers [Placeholder]
│       │   └── repositories/
│       │       └── notice_repository.dart  # Notice repository [Placeholder]
│       └── presentation/
│           └── utils/
│               └── notice_utils.dart # Notice utils [Placeholder]
├── route/
│   ├── helper/
│   │   └── route_helper.dart # Routing utilities
│   ├── app_router.dart # App routing configuration
│   └── route_constant.dart # Route constants
├── services/
│   ├── firebase/
│   │   ├── firebase_analytics_service.dart # Firebase analytics
│   │   └── firebase_options.dart  # Firebase configuration
│   ├── notification_services/
│   │   ├── awn_package.dart   # AWN package integration
│   │   ├── models.dart        # Notification models
│   │   └── notification.dart  # Notification logic
│   └── one_signal/
│       └── onesignal_services.dart  # OneSignal integration
├── ui/
│   ├── bottom_navbar.dart     # Bottom navigation bar widget
│   ├── bottom_navbar_items/
│   │   └── bottom_navbar_items.dart # Navbar item definitions
│   └── main.dart             # App entry point
```

## Directory Table

| **Directory** | **Purpose** |
| --- | --- |
| `core/` | Core utilities, constants, and exceptions |
| `features/` | Feature-specific modules (account, auth, etc.) |
| `route/` | Navigation and routing logic |
| `services/` | External services (Firebase, notifications) |
| `ui/` | Global UI components and entry point |

## Project Description

This Flutter project implements a clean architecture with the following key features:

- **Modular Design**: Features are separated into account, authentication, collection, home, and notice modules.
- **State Management**: Uses Riverpod for dependency injection and state management.
- **Error Handling**: Leverages `fpdart`’s Either for functional error handling.
- **Local Caching**: Implements caching with `api_cache_manager.dart`.
- **Services**: Integrates Firebase Analytics, OneSignal, and custom notification services.

## Getting Started

### Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/classmate.git
cd classmate
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

### Resources

- [Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Useful Flutter samples](https://flutter.dev/docs/cookbook)
- [Flutter Documentation](https://flutter.dev/docs)

## Dependencies

Key dependencies used in this project (update as per your `pubspec.yaml`):

- `flutter_riverpod`: State management and dependency injection
- `fpdart`: Functional programming utilities (e.g., Either)
- `http`: HTTP requests
- `firebase_core`, `firebase_analytics`: Firebase integration
- `onesignal_flutter`: OneSignal notifications

Run `flutter pub get` to install all dependencies.

## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/your-feature`).
3. Commit your changes (`git commit -m "Add your feature"`).
4. Push to the branch (`git push origin feature/your-feature`).
5. Open a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.



