# MHGo Project Handoff Guide

**Project Version:** v1.1.2

Welcome to the MHGo project. This document serves as the "Read This First" guide for future AI assistants, engineers, and maintainers working on this codebase.

## 1. System Overview
MHGo is a comprehensive, offline-first enterprise mobile/desktop application designed for Solar EPC (Engineering, Procurement, and Construction) project management. It tracks the entire lifecycle of a solar installation project, from initial site assessment (Surveys) and planning, to execution (DARs, Progress), logistics (Material Requirements), and finally commissioning.

The application operates completely offline using a local database and provides robust PDF reporting capabilities for technical and administrative documentation.

## 2. Tech Stack & Dependencies
- **Framework:** Flutter (Mobile-first, optimized for Android & Desktop viewports)
- **State Management:** Riverpod (`flutter_riverpod`) using `AsyncNotifier` and `FutureProvider`.
- **Routing:** GoRouter (`go_router`) for declarative URL-based navigation.
- **Local Database:** Isar Database (`isar`, `isar_flutter_libs`) for high-performance offline persistence.
- **PDF Generation:** Printing (`printing`, `pdf`) for generating professional reports with native Philippine Peso (₱) symbols and corporate headers.
- **Charts:** FL Chart (`fl_chart`) for Dashboard analytics.

## 3. Structural Mapping (Feature-First)
The codebase strictly adheres to a **Feature-First Clean Architecture** layout.

```text
lib/
├── core/                   # Shared utilities, database config, theme, and common widgets
│   ├── database/           # Isar schemas (.g.dart) and IsarService
│   ├── theme/              # Material 3 theme definitions
│   └── widgets/            # Reusable UI components (AppCard, AppButton, AppTextField)
├── features/               # Independent feature modules
│   ├── dashboard/          # Aggregated KPIs and quick actions
│   ├── dar/                # Daily Accomplishment Reports
│   ├── materials/          # Material Requirements (BOM) & Inventory
│   ├── progress/           # Project progression and milestones
│   ├── projects/           # Core project CRM and profiles
│   └── survey/             # Initial site assessments
```

Inside each feature folder, the Clean Architecture is maintained:
- `domain/`: Entities, UseCases, and Repository Interfaces (No Flutter dependencies).
- `data/`: Models (Isar annotations), Data Sources, and Repository Implementations.
- `presentation/`: Riverpod Providers, State Notifiers, Views (Screens), and Widgets.

## 4. Coding Rules & Architecture Constraints

### Strict Clean Architecture Boundaries
- **UI Views** must only communicate with **Riverpod Providers**.
- **Providers** must fetch data via **UseCases** or **Repositories**.
- **Domain Entities** must remain pure and oblivious to Isar annotations.
- **Data Models** handle the Isar `@collection` annotations and must provide `toEntity()` and `fromEntity()` mappers.

### Offline-First Behavior
- All CRUD operations write immediately to the local Isar database.
- Providers must be invalidated (`ref.invalidate(...)`) after `put()` operations to trigger reactive UI updates.
- Do not rely on cloud or network requests for core functionality.

### Layout Safety (Zero-Flex Overflow Guarantee)
- **Wrap Rule:** Horizontal elements (chips, metadata) must use `Wrap` instead of `Row` to prevent mobile overflows.
- **Expanded in Scroll:** Never place `Expanded`/`Flexible` widgets directly inside a `Column` inside a `SingleChildScrollView`.
- **Dropdown Bounds:** Always set `isExpanded: true` on Dropdowns and wrap their text in `TextOverflow.ellipsis`.
- **Print Scaling:** PDF or print-preview frames must use `LayoutBuilder` and `FittedBox` when constrained.

### UI / UX Principles
- **Material 3:** Use the defined `AppTheme` colors, typography, and spacing. 
- **No Invalid Data:** Do not display `NaN`, `Infinity`, or `null`. Default to `0`, `0.00`, or `0%` safely using `??` operators.
- **Preserve User Intent:** Do not aggressively auto-convert user inputs unless explicitly requested (e.g., preserve exactly `14.8 kWp` vs `1.2 MWp`).

### Regression Prevention
- Always run `dart analyze` before committing.
- Do not remove existing Isar collections or fields without writing proper migration logic, or unless explicitly rebuilding a feature in development.
- Target updates narrowly using isolated provider invalidation rather than global app resets.
