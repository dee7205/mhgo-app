# System Architecture & Data Flow

This document details the reactive module integration and data flow mechanisms powering MHGo.

## 1. System Data Flow Map

MHGo strictly enforces a Clean Architecture pipeline using Riverpod for dependency injection and reactivity.

### The Pipeline
1. **UI View (Flutter Widget)**: Displays data and receives user input. It uses `ref.watch()` to react to state changes and `ref.read().notifier` to trigger actions.
2. **Riverpod Provider (StateNotifier / AsyncNotifier)**: Orchestrates business logic and maintains state. It calls UseCases.
3. **UseCase (Domain Layer)**: Encapsulates a specific business rule (e.g., `SaveProject`, `GetDashboardOverview`). It communicates via abstract Repository interfaces.
4. **Repository Implementation (Data Layer)**: Handles data transformation between Domain Entities and Data Models.
5. **Local DataSource (Isar Service)**: Executes the actual disk I/O operations (`put`, `delete`, `filter`) on the Isar `.g.dart` collections.

## 2. Module Integration Flow

Updates in MHGo propagate reactively. Because the database is purely local, we use Riverpod invalidation (`ref.invalidate()`) to simulate real-time synchronization across modules.

### Flow Examples:
- **Survey ➔ Projects:**
  When a Survey is approved and converted to a Project:
  1. The `survey_provider` creates a new Project via the `projects_repository`.
  2. The provider explicitly calls `ref.invalidate(projectsListProvider)` and `ref.invalidate(dashboardStateProvider)`.
  3. The Projects list and Dashboard KPIs update instantly without app reload.
- **Projects ➔ Progress & Materials:**
  Creating a Project automatically initializes empty Progress modules and default Material Requirements (BOM).
- **Projects ➔ Dashboard:**
  When a Project's `totalCost` or `capacity` is edited, invalidating `dashboardStateProvider` immediately recalculates the "Accumulated Value" and "Capacity Implemented" KPIs for all active projects.
- **PDF Generation:**
  The PDF preview screens generate documents dynamically based on the current in-memory Entity state, bypassing intermediate storage. They use `assets/images/company_logo.png` for corporate headers securely loaded via `rootBundle`.

## 3. GoRouter Named Routing Matrix

MHGo uses `go_router` for declarative navigation. Below is the active routing tree:

- `/` ➔ ShellRoute (Main Layout with Drawer)
  - `/dashboard` ➔ DashboardView
  - `/projects` ➔ ProjectsListView
    - `/projects/:id` ➔ ProjectDetailsView
  - `/survey` ➔ SurveyListView
    - `/survey/new` ➔ SurveyCreateEditView
    - `/survey/:id` ➔ SurveyDetailsView
  - `/dar` ➔ DarListView
    - `/dar/new` ➔ DarCreateEditView
    - `/dar/:id` ➔ DarDetailsView
  - `/materials` ➔ MaterialsListView
  - `/progress` ➔ ProgressListView

*Note: Navigating to nested routes uses `context.go()` to maintain deep linking and browser history (if compiled to Web).*
