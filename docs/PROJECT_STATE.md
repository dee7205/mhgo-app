# Project State Matrix

This document tracks the current implementation status of MHGo modules and highlights known limitations.

## 1. Module Status Metrics

| Module | Status | Sync / DB Persistence | PDF Reporting |
|---|---|---|---|
| **Dashboard** | ✅ Complete | Fully Reactive | N/A |
| **Projects (CRM)** | ✅ Complete | Fully Reactive | ✅ Professional Header |
| **Survey (Assessments)** | ✅ Complete | Fully Reactive | ✅ Professional Header |
| **DAR (Daily Reports)** | ✅ Complete | Fully Reactive | ✅ Professional Header |
| **Materials (BOM)** | ✅ Complete | Embedded in Project | Included in Project PDF |
| **Progress** | 🟡 Partial | Fully Reactive | Pending |
| **AI Assistant** | ✅ Complete | Global Dashboard Context | N/A |

## 2. Implemented Features
- **Isar Database Pipeline:** Full offline CRUD operations for Projects, Surveys, DARs, and Progress.
- **Dynamic Dashboard KPIs:** Cross-module aggregation for Capacity Implemented (per stored unit) and Accumulated Total Cost.
- **PDF Generation Engine:** Standardized corporate logo headers (`assets/images/company_logo.png`) with clean A4 layout mechanics, tables, and signature blocks.
- **Material Requirements (BOM):** Custom Material 3 UI for on-grid tracking. Removed per-item costs in favor of a single `totalCost` Project field. Supports editable material names without creating duplicate system defaults.
- **Data Safety Validators:** Protection against `NaN` and `Infinity` mathematical errors on the UI. Default fallback handling for missing currencies (`₱0`) and capacities (`0 kWp`).
- **Zero-Flex Layouts:** Prevented `RenderFlex` overflows in mobile viewport constraints using `Wrap`, constrained `DropdownButtonFormField`, and `FittedBox` widgets.
- **Retrieval-Augmented Generation (RAG):** Implemented a global AI Assistant powered by the Gemini API. Uses `DashboardContextBuilder` to serialize offline Isar database models into contextual markdown prompts, allowing intelligent querying of local project data.

## 3. Pending Work
- **Progress PDF Engine:** Develop a standalone PDF exporter for the Progress module (Gantt-style milestone exports).
- **Inventory/Stock Module:** Flesh out the warehouse inventory tracking and low-stock alert mechanics which are currently stubbed in the Dashboard overview.
- **Authentication:** Integrate secure offline login and potential Firebase Auth syncing for multi-user device handoffs.

## 4. Known Limitations
- **Type-Safety Conversions:** Isar doesn't natively support highly nested complex objects or Maps. We currently store nested JSON lists as encoded Strings (e.g., `materialsJson`, `manpowerJson` in DAR). This requires careful serialization/deserialization mapping in `toEntity()` / `fromEntity()`.
- **HeroTag Conflicts:** Floating Action Buttons (FABs) in list views require explicit and unique `heroTag` definitions (or `null`) to prevent transition animation crashes when navigating between identical GoRouter paths.
- **Unit Conversions:** User inputs for capacity (`kWp`, `MWp`) are stored exactly as entered. We deliberately do not auto-convert them anymore to prevent precision loss and confusing UI discrepancies. The Dashboard simply sums them grouped by their declared string unit.
