# Changelog

## [v1.4.0] - Current
### Added
- **AI Solar Calculator Engine:** System prompt engineered to allow Gemini to act as an advanced financial estimator (calculating Daily Yield, Monthly Savings, Annual Savings, and ROI using standard Philippine EPC metrics).
- **AI EPC Quotation Generator:** Instructed Gemini to automatically generate professional MHGo-branded Solar EPC Quotations, containing Scope of Work, BOMs, Cost Breakdowns, and Payment Terms.
- **AI PDF Export Engine:** Developed `AiPdfGenerator` to dynamically intercept `[GENERATE_PDF]` flags from Gemini, parsing its Markdown response into a highly professional A4 PDF (complete with company headers, stylized borders, and bullet points) ready for client delivery.
- **Dynamic Context Injection:** Automatically injects `DateTime.now()` into the AI's system prompt so it has real-time awareness for generating dated quotes.

### Fixed
- Fixed a bug where the Philippine Peso sign (`₱`) would render as a corrupted `[X]` box in the PDF package; the PDF generator now intercepts and gracefully falls back to `PHP `.

---

## [v1.3.0]
### Added
- **Global AI Assistant:** Integrated Gemini API (`gemini-3-flash-preview` over `v1beta` endpoint) to provide an interactive chatbot on the Dashboard.
- **RAG Architecture:** Added `DashboardContextBuilder` to automatically parse and serialize Isar database content (Projects, KPIs, Inventory, Surveys) into structured Markdown for grounded AI responses.
- **AI UI:** Developed `AiAssistantView` with an auto-scrolling chat interface, Markdown rendering for AI responses, and loading state management.

---

## [v1.2.3]
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
