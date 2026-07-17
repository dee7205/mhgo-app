# MHGo - Project Handoff & Context Document

## 1. Project Overview
**Name**: MHGo
**Type**: Mobile-first Enterprise Application (Optimized for Android/Tablets, Desktop compatible)
**Domain**: Solar Portfolio & Construction Project Management
**Architecture**: Clean Architecture (Domain / Data / Presentation layers, Feature-first)
**Tech Stack**: 
- **Framework**: Flutter (Material 3)
- **Local Database**: Isar (Offline-first approach)
- **State Management**: Riverpod (`NotifierProvider`, `FutureProvider`)
- **Routing**: GoRouter (`StatefulShellRoute` with persistent bottom navigation)
- **PDF Generation**: `pdf` and `printing` packages

## 2. Implemented Modules (Current Status)
1. **Dashboard Module**:
   - Layout is responsive (Mobile, Tablet, Desktop).
   - **Projects List Prominence**: Active Projects list is located at the top of the dashboard for immediate visibility.
   - **KPIs & Alerts**: Summaries for projects, DARs, inventory low-stock alerts, and urgent tasks.
2. **Projects Module**:
   - Comprehensive project creation and detailed viewing tabs.
   - **Timeline**: Auto-updates milestones natively from `ProgressModel` entries. 
   - **Team Management**: Contains full Add/Edit/Delete functionality for team members which serializes into Isar via `teamMembersJson`.
3. **Survey (Site Assessment) Module**:
   - Handles solar site parameters (roof capacity, budget, system details).
   - **Native PDF Printing**: Includes native PDF generation and print previews directly wired to `app_router.dart` (`/survey/pdf/:uuid`).
4. **DAR (Daily Accomplishment Report) Module**:
   - Custom Isar mapping for complex JSON structures (manpower, equipment, materials, delays, photos).
   - Tracks site conditions, weather, and detailed tabular accomplishment data.
5. **Progress & Inspections Modules**:
   - **Progress**: Tracks engineering/civil categories and syncs data to Project Timelines.
   - **Inspections**: Offline-first QA/QC inspection forms with pass/fail checklists and Non-Conformance (NCR) reports.

## 3. Strict Architectural Rules & Constraints
*All future agents must strictly adhere to these rules when modifying the codebase.*

### A. Zero-Flex Overflow Guarantee (Mobile Safety)
1. **The Wrap Rule**: Horizontal tag lists, status chips, or dates MUST use `Wrap` instead of `Row` to prevent pixel overflows on smaller mobile viewports.
2. **Scroll View Bounding**: NEVER place an `Expanded` or `Flexible` widget directly inside a `Column` that is inside a scrollable container (`SingleChildScrollView`, `ListView`) without explicit height boundaries.
3. **Dropdown Bounds**: ALL `DropdownButtonFormField` widgets must have `isExpanded: true`, and their inner text must be wrapped with `Text(..., overflow: TextOverflow.ellipsis)`.
4. **Row Text Wrap**: Dynamic `Text` inside a `Row` MUST be wrapped in `Expanded` or `Flexible` to truncate long strings.
5. **Fixed-Width Print Constraints**: PDF Layouts or fixed-width document views (e.g., A4 `width: 794`) must use `LayoutBuilder` and `FittedBox(fit: BoxFit.scaleDown)` to shrink to fit smaller screens.

### B. Routing & Navigation
1. **GoRouter Strict Paths**: Always register nested paths correctly. Missing path definitions cause "Route Boundary Catch" `errorBuilder` exceptions. 
2. **Action Buttons**: Use `context.push()` for navigation instead of relying on `ScaffoldMessenger` placeholders.
3. **Hero Tag Collisions**: FloatingActionButtons in different GoRouter tabs WILL crash the app on navigation if they share the same default Hero tag. Ensure every FAB has a explicitly declared, unique `heroTag: 'xyz_fab'`.

### C. Offline-First Relational Resilience
1. **Lazy Initialization**: If querying for a child module record (e.g. `ProgressReport` for a Project) that doesn't exist yet, do not throw exceptions. Catch nulls, initialize gracefully with default values, and proceed.
2. **Data Storage**: Complex nested list data (e.g., team members, materials, manpower) within Isar models should be mapped using `jsonEncode` and `jsonDecode` into `String` properties (e.g. `teamMembersJson`), as Isar doesn't natively support deep nested entity lists well.
3. **Legacy Null Tolerance (Schema Changes)**: When making an existing Isar model field nullable (e.g., changing `late String` to `String?`) to accommodate older records that lack the new field, **ALWAYS provide a fallback string** in the UI (e.g., `Text(project.stage ?? 'N/A')`). Dart's strict non-nullable widgets (like `Text`) will crash if they unexpectedly receive `null`. Always run `dart run build_runner build -d` immediately after making a model field nullable so Isar generates the tolerant adapters.
4. **Defensive String/List Parsing**: Always apply defensive bounds checks (e.g., `mat.uuid.length >= 8`) when applying `.substring()` or `.take()` to local database properties, as mock data or unmigrated UUIDs being empty/short will instantly throw unhandled `RangeError (end)` or `RangeError (index)` exceptions and crash the entire Riverpod sync pipeline.
5. **Dashboard Sync Fail-Safes**: All overarching provider pipelines (e.g., `dashboardStateProvider`) that watch multiple local repository sources MUST wrap their `await` resolutions in a `try...catch`. If Isar throws deserialization errors due to schema mismatches, catch them and return empty lists `[]` rather than crashing the dashboard with "EPC Database Offline Sync Failure".

### D. Native Quirks (PDFs & Fonts)
1. **Currency Typography**: The native PDF `printing` library's default fonts (e.g., Helvetica) will crash if forced to render unmapped Unicode symbols (like the Philippine Peso `₱` / U+20b1). 
   - *Fix*: Either use a fallback mapping (e.g. replacing `₱` with `'PHP '`) or explicitly load a TTF font that supports the glyph.

### E. Flutter & Code Quality Standards
1. Use `.withValues(alpha: ...)` instead of the deprecated `.withOpacity(...)`.
2. Ensure strict linting compliance using `dart analyze`.

## 4. Work Flow & Cost Optimization (Agent Protocol)
- **Slice Reading**: Use `StartLine` and `EndLine` parameters when viewing files to minimize token context.
- **Precision Modifications**: Use contiguous micro-edits instead of full-file overwrites. 
- **Avoid Repeated Commands**: Only execute necessary compilation/tests commands after logical blocks of fixes.

---
**End of Document** - *Use this as the source of truth for MHGo context going forward.*
