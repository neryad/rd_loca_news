# Changelog

All notable changes to this project will be documented in this file.

## [1.1.1] - 2026-07-29

### 🛠️ SDK & Dependencies

- **Android targetSdkVersion updated to 36**: Google Play compliance for Android 16 (API level 36)

---

## [1.1.0+1782867387] - 2026-06-30

### 🛠️ SDK & Dependencies

- **Android SDK updated**: Kotlin 2.0.0, Java 17, AGP 8.6.0, Gradle 8.7
- `flutter_markdown` (discontinued) replaced with `flutter_markdown_plus`
- `google_mobile_ads` removed (unused code)
- SDK constraint in `pubspec.yaml` updated to `>=3.10.0-0`

### 🐛 Bug Fixes

- Pull-to-refresh now forces data reload (was returning cached data)
- Hero animations now work correctly between list and detail pages
- Loading dialog replaced with SnackBar loading for better UX
- `defaultColor` now persists correctly across app restarts
- Silenced `_launchUrl` errors now show user feedback

### ⚡ Performance

- `NetworkImage` replaced with `CachedNetworkImage` across the app (image caching)
- `MainApp.stateSet()` anti-pattern replaced with `ValueNotifier<ThemeMode>`
- `withOpacity()` migrated to `.withValues(alpha:)` (43 occurrences)

### 📱 UI/UX

- Improved loading skeletons with clearer indicators
- Error states now display the actual exception message
- `RadioListTile` migrated to `RadioGroup` (new Flutter 3.32+ API)

### 🔧 Code Quality

- `analysis_options.yaml` with strict-casts, strict-inference, strict-raw-types
- 5 unused imports removed
- `final` variables where applicable
- Typed `catch` clauses with `on Exception`
- `flutter analyze` — **0 issues**

---

## [1.0.0+1760752330] - 2025-10-17

### 🎨 Complete UI/UX Refactor

- Fully redesigned **HomePage**, **TabNewsPage**, **NewsCard**, **FavoritePage**, and **SettingsPage**.
- Added **professional animations** and smooth transitions across the app.
- **Modern, clean, and consistent** design focused on user experience.

### 🏗️ Improved Architecture

- Implemented **Singleton pattern** for services.
- Optimized **cache system** to significantly enhance performance.
- New and more **robust error handling** throughout the app.

### 🚀 New Features

- **Pull to refresh** to easily reload news.
- **Swipe to delete** in interactive sections.
- **Hero animations** between pages for smoother navigation.
- Added a new **“About” page** with project information.
- Improved **loading and error states** with clearer visual feedback.

### ⚡ Performance Optimization

- **Parallel service loading** for faster startup.
- **Persistent caching** of news and details for a quicker experience.
- **Singleton pattern for Dio** to reduce instances and boost efficiency.

---

## [0.4.3+1728097348] - 2024-10-04

### Added

- **Markdown File Reader**: Added functionality to read **Terms and Conditions** and **Privacy Policy** directly from within the app.
- **New Options**: Two new entries were added under the Information section:
  - Link to the project’s **GitHub Repository**.
  - **Donate** option to support ongoing app development.

## [0.4.2] - 2024-09-20

### Added

- **Advertisements**: Added a banner ad on the home screen to help fund and support ongoing development.

## [0.3.0] - 2024-08-26

### Added

- **New News Channel**: You can now access content from _El Hoy_ newspaper, providing an additional and reliable source of updated information.

### Improved

- **Dependency Removal**: The WebView package was removed to optimize performance and reduce app size.
- **General Optimization**: Various under-the-hood improvements were made to enhance performance and stability.

## [0.2.0] - 2024-08-16

### Improved

- Replaced WebView with a new and improved screen for reading detailed news articles.

### Fixed

- Fixed several spelling mistakes.

## [0.1.0] - 2024-08-09

### Added

- **Dark Mode**: Added dark theme for better readability in low-light conditions.
- **Push Notifications**: Integrated push notifications to alert users about the latest news and updates.
- **New Interface Design**: Updated the app’s interface for more intuitive and user-friendly navigation.

### Improved

- **Loading Speed**: Improved loading speed for articles and news feeds.
- **Accessibility**: Enhanced accessibility support, including compatibility with screen readers.

### Fixed

- **Favorite Saving Bug**: Fixed an issue where some articles weren’t being saved properly to favorites.
- **Compatibility Issues**: Resolved issues affecting older Android devices.

### Notes

- This version includes important improvements to user experience and stability.  
  It’s recommended that all users update to the latest version to enjoy the new features and enhancements.
