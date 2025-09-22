# Postly App - The Ultimate Flutter App

**Postly** is a Flutter-powered blogging application designed for seamless content browsing and interaction. With offline-first support, favorites management, live search, and responsive design for both mobile and tablet devices, Postly makes discovering, reading, and managing posts effortless and engaging from any device.

## Supported Platforms

- Android
- iOS

## Features

- **Posts List:** Scrollable list displaying title, snippet, tags, and reactions (likes/dislikes).
- **Search:** Live search filtering posts.
- **Post Details:** Full post content with "See More" toggle and related posts section.
- **Favorites:** Mark/unmark posts as favorites, view favorites on a dedicated page, delete favorites.
- **Offline-First:** Cached posts displayed when offline with an offline banner indicator.
- **Responsive UI:** Works on both mobile and tablet with modern card-based layout.
- **Splash Screen:** Branded splash with app logo.

## Architecture

The app follows **Clean Architecture** principles:

UI (Screens & Widgets)
↓
Cubit/Bloc (Presentation Layer)
↓
Usecases (Domain Layer)
↓
Repository Interface (Domain Layer)
↓
Repository Implementation (Data Layer)
↓
Data Sources (Remote & Local)

- **Presentation Layer:** Cubits handle state management for posts, post details, and favorites.
- **Domain Layer:** Usecases encapsulate business logic.
- **Data Layer:** Repository handles API calls and local storage via Hive.

## Project Structure

lib/
├── core/
│ ├── theme/ # Custom colors and text styles
│ └── network/ # Dio client, API URLs
├── features/
│ ├── posts/ # Post list feature
│ ├── postDetails/ # Post detail feature
│ └── favourites/ # Favorites feature
├── presentation/
│ └── pages/ # Splash screen and shared UI
└── main.dart

## Getting Started

### Prerequisites

- Flutter SDK >= 3.24.5
- Dart >= 3.5.4

### Installation

1. Clone the repository:

bash
git clone https://github.com/<your-username>/postly_flutter.git
cd postly_flutter

2. Install dependencies:

```bash
flutter pub get
```

3. Generate JSON serialization code:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:

```bash
flutter run
```

## Dependencies

```yaml
dependencies:
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  dio: ^5.9.0
  get_it: ^8.2.0
  injectable: ^2.5.1
  hive_flutter: ^2.2.3
  google_fonts: ^5.0.0
  json_annotation: ^6.7.0
  connectivity_plus: ^4.0.2
  cached_network_image: ^3.2.3

dev_dependencies:
  build_runner: ^2.5.0
  hive_generator: ^2.0.0
```

## Author

**Sambriddha Jung Shah**

- GitHub: [https://github.com/SambriddhaShah](https://github.com/<your-username>)
- Email: [sambriddhajungshah@gmail.com](mailto:your.email@example.com)

---

## Notes

- The app supports offline-first functionality using Hive for caching.
- Favorites are persisted locally and can be removed from the Favorites page.
- The app is fully responsive and optimized for both mobile phones and tablets.
- Clean architecture ensures modularity and scalability for future features.
