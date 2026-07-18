# Changelog

## [v1.1.2] - Current
### Added
- Standardized corporate logo (`assets/images/company_logo.png`) header across Project, Survey, and DAR PDF generators.
- Built a fallback mechanism in PDF previews preventing crashes if branding assets are temporarily missing.

### Changed
- Dashboard KPIs now sum capacity strictly based on user-entered units (e.g., grouped by `kWp` and `MWp` independently) to prevent arbitrary mathematical conversions.
- Dashboard Total Cost KPI now correctly sweeps all active project states (planning, construction, om, commissioning, completed) rather than a narrow subset.
- Completely rebuilt the Material Requirements (BOM) data model. Removed per-item costs in favor of a unified Project-level `totalCost` field. 
- Material Name fields are now freely editable without disrupting global schema templates.

### Fixed
- Eradicated `NaN` and `Infinity` mathematical bleed-throughs across the UI. Null capacities and costs gracefully fall back to 0.
- Resolved analyzer warnings regarding missing `dashboardStateProvider` imports in Project/Survey views.
- Fixed a corrupted string parsing block inside `project_pdf_preview_view.dart`.

---

## [v1.1.1]
### Changed
- Migrated DAR offline persistence completely to Isar.
- Converted Survey data forms to Material 3 standard layouts preventing bottom-sheet clipping.

### Fixed
- Fixed unbounded height `RenderFlex` exceptions inside scrollable `Column`s by replacing loose `Expanded` constraints with deterministic widget heights.
- Resolved HeroTag crashes when navigating repeatedly between the Dashboard and Project lists.

---

## [v1.1.0]
### Added
- Initial Isar database scaffolding.
- Projects CRM base CRUD functionality.
- Initial GoRouter named routing implementation.
- Core Material 3 unified `AppTheme` definitions.
