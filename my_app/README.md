# OnIT — Flutter Mobile App

> A clean-code Flutter replica of the **OnIT** task marketplace home screen, built with design-pattern-driven architecture for maintainability, testability, and scalability.

---

## Table of Contents

- [Overview](#overview)
- [Screenshots Reference](#screenshots-reference)
- [Architecture & Design Patterns](#architecture--design-patterns)
- [Project Structure](#project-structure)
- [Design System](#design-system)
- [Component Inventory](#component-inventory)
- [Data Models](#data-models)
- [Navigation Architecture](#navigation-architecture)
- [Page Composition](#page-composition)
- [Getting Started](#getting-started)
- [Future Enhancements](#future-enhancements)

---

## Overview

**OnIT** is a local task marketplace app that connects users who need tasks done with skilled performers in their community. This project implements a pixel-accurate Flutter replica of the home screen UI, structured using industry-standard design patterns.

<img width="714" height="692" alt="image" src="https://github.com/user-attachments/assets/8781a374-8cc2-46bb-89ca-a7cf05c6d890" />
<img width="716" height="684" alt="image" src="https://github.com/user-attachments/assets/bcdbcb18-bc95-49c2-87ec-c1ca3238fed9" />
<img width="865" height="681" alt="image" src="https://github.com/user-attachments/assets/ddd60b76-918b-4d38-bec5-d802154fbbe5" />
<img width="720" height="684" alt="image" src="https://github.com/user-attachments/assets/ef39e303-38c5-4f78-99c9-a6f2d469e5e0" />
<img width="722" height="684" alt="image" src="https://github.com/user-attachments/assets/957c00b9-6dc1-4d5a-907b-3ffb90979885" />

### Key Goals

| Goal | How Achieved |
|------|-------------|
| Clean Code | Single Responsibility — each widget does one thing |
| Reusability | Extracted shared widgets with parameterized constructors |
| Theming | Centralized `AppColors` + `AppTheme` — zero hardcoded values in widgets |
| Scalability | MVC-like layers — easy to add new pages/features |
| Testability | Stateless widgets with injected data — easy to unit test |

---

## Architecture & Design Patterns

### Layer Diagram

```
┌─────────────────────────────────────────────┐
│                   main.dart                  │
│              (App Entry Point)               │
├─────────────────────────────────────────────┤
│              core/theme/                     │
│   AppColors (tokens)  │  AppTheme (config)   │
├─────────────────────────────────────────────┤
│               models/                        │
│  TaskTemplate  │  Performer  │  Testimonial  │
├─────────────────────────────────────────────┤
│          presentation/pages/                 │
│     MainShell (nav)  │  HomePage (layout)    │
├─────────────────────────────────────────────┤
│          presentation/widgets/               │
│  AddressHeader │ SearchBar │ HeroBanner │... │
└─────────────────────────────────────────────┘
```

### Design Patterns Applied

#### 1. Composite Pattern
**Where:** `HomePage` composes 10+ independent widgets into a single scrollable page.

```dart
// home_page.dart — composing small widgets into a full UI
Column(
  children: [
    const AddressHeader(),      // Component 1
    const SearchBarWidget(),    // Component 2
    const HeroBanner(),         // Component 3
    const FeaturedBanner(),     // Component 4
    const PromoRow(),           // Component 5
    // ... etc.
  ],
)
```

**Why:** Each section is an independent, testable widget. Adding/removing/reordering a section is a one-line change.

---

#### 2. Shell Pattern (Navigation)
**Where:** `MainShell` wraps the app with `IndexedStack` + `BottomNavigationBar`.

```dart
// main_shell.dart
Scaffold(
  body: IndexedStack(
    index: _currentIndex,
    children: _pages,    // [HomePage, MyTask, Post, Chat, Account]
  ),
  bottomNavigationBar: BottomNavigationBar(...),
)
```

**Why:** Pages maintain their state when switching tabs. New tabs can be added by simply appending to the `_pages` list and adding a `BottomNavigationBarItem`.

---

#### 3. Strategy Pattern (Theming)
**Where:** `AppTheme` provides a single `ThemeData` object consumed by `MaterialApp`.

```dart
// app_theme.dart
static ThemeData get lightTheme => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
  elevatedButtonTheme: ...,
  bottomNavigationBarTheme: ...,
);
```

**Why:** Swapping the entire visual style (e.g. dark mode) requires changing only the `AppTheme` class. Widgets never reference raw colors.

---

#### 4. Template Method Pattern
**Where:** Every widget follows the same contract — `StatelessWidget` → `build(BuildContext)`.

**Why:** Consistent, predictable structure across all 10+ widgets. New developers can read any widget and immediately understand its shape.

---

#### 5. Factory-Style Data Models
**Where:** `models/` directory — `TaskTemplate`, `Performer`, `Testimonial`.

```dart
class Performer {
  final String name;
  final String role;
  final double rating;
  final String description;
  const Performer({required this.name, required this.role, ...});
}
```

**Why:** Typed data classes replace raw `Map<String, dynamic>`. When the backend API is integrated, these models become the deserialization targets.

---

## Project Structure

```
lib/
│
├── main.dart                           # App entry point + MaterialApp config
│
├── core/
│   └── theme/
│       ├── app_colors.dart             # Color palette constants
│       └── app_theme.dart              # Centralized ThemeData
│
├── models/
│   ├── task_template.dart              # Task template data class
│   ├── performer.dart                  # Top performer data class
│   └── testimonial.dart                # Testimonial data class
│
├── pages/
│   └── client_page.dart                # Legacy placeholder (can be removed)
│
└── presentation/
    ├── pages/
    │   ├── main_shell.dart             # Bottom nav + IndexedStack routing
    │   └── home_page.dart              # Home screen — assembles all widgets
    │
    └── widgets/
        └── home_widgets.dart           # All reusable UI components
```

### Why This Structure?

| Directory | Responsibility | SOLID Principle |
|-----------|---------------|-----------------|
| `core/theme/` | Design tokens & theme config | **Open/Closed** — extend themes without modifying widgets |
| `models/` | Pure data classes with no UI logic | **Single Responsibility** |
| `presentation/pages/` | Page-level layout & composition | **Single Responsibility** |
| `presentation/widgets/` | Reusable, parameterized UI blocks | **Interface Segregation** — each does one job |

---

## Design System

### Color Palette

| Token | Hex | Usage |
|-------|-----|-------|
| `primaryGreen` | `#1EAD53` | Buttons, links, accents, nav highlight |
| `lightGreenBackground` | `#E8F8EE` | Card backgrounds, banners |
| `textPrimary` | `#1E1E1E` | Headings, body text |
| `textSecondary` | `#7A7A7A` | Subtitles, descriptions |
| `borderLight` | `#E0E0E0` | Card borders, dividers |

### Typography

| Style | Size | Weight | Color |
|-------|------|--------|-------|
| Page Title | 20sp | Bold | textPrimary |
| Section Title | 18sp | Bold | textPrimary |
| Card Title | 15sp | Bold | textPrimary |
| Body Text | 13sp | Regular | textSecondary |
| Small Label | 11sp | Regular | textSecondary |
| Button Text | 12sp | Medium | White |

### Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| Page Padding | 16px | Horizontal margin for all sections |
| Section Gap | 24px | Vertical space between major sections |
| Card Padding | 12-16px | Internal padding of cards |
| Card Border Radius | 14-20px | Rounded corners |

---

## Component Inventory

### Widgets in `home_widgets.dart`

| Widget | Type | Props | Description |
|--------|------|-------|-------------|
| `AddressHeader` | Stateless | — | Location pin + address text |
| `SearchBarWidget` | Stateless | — | Search input with mic icon + filter button |
| `HeroBanner` | Stateless | — | Green welcome card with "Get Started" CTA |
| `FeaturedBanner` | Stateless | — | "Post a task in seconds" feature highlight |
| `PromoRow` | Stateless | — | Horizontal scroll of `_PromoCard` widgets |
| `_PromoCard` | Stateless (private) | title, subtitle, icon, badgeText | Individual promo offer card |
| `SectionTitle` | Stateless | title | "Task Templates" / "Top Performers" header with "View more" link |
| `TaskTemplateCard` | Stateless | title, subtitle | Category card (Academic, Design, Literature) |
| `PerformerCard` | Stateless | name, role, rating, description | Performer profile with star rating + CTA |
| `TestimonialCard` | Stateless | name, role, content | Green card with overlapping avatar |
| `RewardSection` | Stateless | — | Refer & earn banner with "Get Link" button |
| `FooterBrand` | Stateless | — | "We're OnIT" branding footer |

---

## Data Models

### TaskTemplate

```dart
class TaskTemplate {
  final String title;       // e.g. "Academic Research"
  final String subtitle;    // e.g. "250+ taskers"
  final String? imageUrl;   // Optional thumbnail
}
```

### Performer

```dart
class Performer {
  final String name;        // e.g. "Anu Reddy"
  final String role;        // e.g. "Web Designer"
  final double rating;      // e.g. 4.7
  final String description; // Short bio
}
```

### Testimonial

```dart
class Testimonial {
  final String name;        // e.g. "Anu Reddy"
  final String role;        // e.g. "Web Designer"
  final String content;     // Review text
}
```

---

## Navigation Architecture

```
MainShell (StatefulWidget)
├── BottomNavigationBar
│   ├── Home      → HomePage (fully implemented)
│   ├── My Task   → PlaceholderPage
│   ├── Post      → PlaceholderPage (green circular + icon)
│   ├── Chat      → PlaceholderPage
│   └── Account   → PlaceholderPage
│
└── IndexedStack  → preserves page state across tab switches
```

The **Post** tab uses a custom circular green FAB-style icon in the navigation bar, matching the original design.

---

## Page Composition

`HomePage` assembles the sections in this order:

```
┌─────────────────────────────┐
│  📍 AddressHeader           │
├─────────────────────────────┤
│  🔍 SearchBarWidget         │
├─────────────────────────────┤
│  👋 HeroBanner              │
│  "Welcome Ananya!!"         │
├─────────────────────────────┤
│  📝 FeaturedBanner           │
│  "Post a task in seconds"   │
├─────────────────────────────┤
│  🎁 PromoRow (horizontal)   │
│  [50% OFF] [Free Boost]     │
├─────────────────────────────┤
│  📋 Task Templates          │
│  [Academic] [Design] [Lit]  │
├─────────────────────────────┤
│  ⭐ Top Performers           │
│  [Performer 1] [Performer 2]│
├─────────────────────────────┤
│  💬 TestimonialCard          │
├─────────────────────────────┤
│  🎉 RewardSection            │
│  "Refer and earn!"          │
├─────────────────────────────┤
│  🏢 FooterBrand              │
│  "We're OnIT"               │
└─────────────────────────────┘
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.9.2
- Dart SDK (bundled with Flutter)
- Windows / macOS / Linux / Android / iOS build tools

### Run the App

```bash
# Clone and navigate
cd onit_task/my_app

# Get dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Run on Windows desktop
flutter run -d windows

# Run on Chrome (web)
flutter run -d chrome
```

### Analyze Code

```bash
flutter analyze
```

---

## Future Enhancements

| Feature | Pattern to Use | Description |
|---------|---------------|-------------|
| State Management | Provider / Riverpod | Replace static data with reactive state |
| API Integration | Repository Pattern | Abstract data source behind interfaces |
| Dependency Injection | GetIt / Injectable | Wire services and repos at startup |
| Image Assets | Asset bundling | Replace icon placeholders with real images |
| Dark Mode | Strategy (AppTheme) | Add `darkTheme` to `AppTheme` class |
| Animations | Implicit/Explicit | Add entrance animations to cards and banners |
| Localization | intl package | Support Hindi, Telugu, and other Indian languages |
| Testing | Widget Tests | Test each widget independently with `pumpWidget` |

---

## License

This project is for educational / demonstration purposes.

---

> **Built with ❤️ using Flutter & Clean Architecture**
