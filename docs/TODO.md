# Action Items & Future Enhancements

## High Priority
- [ ] **Strict Dropdown Validation Bounds:** Enforce `isExpanded: true` and `TextOverflow.ellipsis` on all remaining dropdown widgets to permanently eliminate right-side overflow crashes during form input.
- [ ] **Category CRUD Verification:** Ensure newly added or renamed categories (e.g. in Material BOMs or Progress milestones) accurately propagate down to the PDF reports without duplicating records.
- [ ] **RenderFlex Overflow Adjustments:** Perform a final viewport sweep on small Android devices (width < 360px) to verify the new `Wrap` implementation holds up against dense metadata strings.

## Medium Priority
- [ ] **Inventory Sync Logic:** Connect the Dashboard's low-stock alerts KPI to a functional standalone Materials/Inventory module.
- [ ] **Image Handling Compression:** Optimize the camera/gallery inputs in the Survey module to compress images before converting them to Base64 strings for Isar persistence to prevent memory out-of-bounds errors on large devices.
- [ ] **Progress PDF Exporter:** Create `ProgressPdfPreviewView` using the unified corporate logo header standard.

## Low Priority
- [ ] **Micro-Animations:** Add subtle Hero transitions between the Projects list and Project Details screens.
- [ ] **Dark Mode Polish:** Verify specific custom card variants contrast correctly against pure black backgrounds in the DAR list view.

## Future Enhancements
- [ ] **Firebase Cloud Synchronization:** Build a background sync engine that pushes local Isar modifications up to Firestore when the device detects a stable Wi-Fi connection.
- [ ] **Multi-User Collaboration:** Implement role-based access control (RBAC) preventing field engineers from modifying overarching Project cost settings.
