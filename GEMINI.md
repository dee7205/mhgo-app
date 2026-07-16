# MHGo Gemini Agent Guidelines

This document outlines key rules, token-efficiency workflows, and layout safety principles for Antigravity (AGY) and other AI agents working on the MHGo codebase. 

---

## 1. Credit & Token Efficiency (Cost Optimization)

To achieve the best results while keeping credit consumption to a minimum, adhere strictly to these principles:

### A. Minimalist Code Inspection (Slice Reading)
* **Rule**: When using `view_file`, **never** load entire files unless absolutely necessary. Always specify `StartLine` and `EndLine` parameters to read only the lines relevant to your targeted task.
* **Benefit**: Saves context window input tokens, leading to faster response times and significantly reduced credit usage.

### B. Contiguous and Micro-Edits
* **Rule**: Use `replace_file_content` for single contiguous edits and `multi_replace_file_content` for multiple non-contiguous changes within the same file.
* **Warning**: **Never** replace the entire content of a file to modify a few lines. Rewriting hundreds of unchanged lines wastes output tokens and raises costs.

### C. Precision Command Executions
* **Rule**: Run targeted commands. Do not run general scripts or compilation loops repeatedly without applying fixes.
* **Rule**: Minimize background task spawn counts. Spawning subagents is powerful but consumes significant tokens. Give subagents clear, narrow scopes and terminate them immediately when done.

---

## 2. Zero-Overflow Layout Rules (Zero-Flex Overflow Guarantee)

MHGo is a mobile-first enterprise application optimized for Android that must remain fully compatible on Windows and desktop screens. Eliminate all layout violations by enforcing these widget rules:

### A. The Wrap Rule (Horizontal Flow Safety)
* **Constraint**: Any sequence of horizontal metadata tags, status chips, dates, priority flags, or names **must** use a `Wrap` widget instead of a `Row`.
* **Standard**: 
  ```dart
  Wrap(
    spacing: 8,
    runSpacing: 8,
    alignment: WrapAlignment.spaceBetween,
    children: [ ... ],
  )
  ```
* **Reason**: Preventing right-side pixel overflows on mobile/tablet viewports when horizontal layout dimensions shrink.

### B. The Expanded-in-Column Scroll Violation
* **Constraint**: **Never** place `Expanded` or `Flexible` widgets directly inside a `Column` that resides inside a scroll view (e.g., `SingleChildScrollView` or `ListView`) without a parent `SizedBox` or `Container` defining explicit height boundaries.
* **Reason**: This triggers an unbounded vertical height assertion (`Vertical viewport was given unbounded height`), crashing the rendering thread and freezing the screen.
* **Correction**: Stack items natively without `Expanded` in vertical scroll containers.

### C. The Bounded Dropdown Rule
* **Constraint**: Set `isExpanded: true` on **all** `DropdownButtonFormField` widgets.
* **Constraint**: Wrap the text elements inside `DropdownMenuItem`'s child in `Text(..., overflow: TextOverflow.ellipsis)`.
* **Reason**: Dropdowns without `isExpanded` will attempt to render their child text at full length, leading to right-side layout overflows when selections contain long string names.

### D. The Bounded Row Text Rule
* **Constraint**: Any `Text` widget inside a horizontal `Row` that display dynamic content (project names, section headers, remarks) **must** be wrapped in `Expanded` or `Flexible`.
* **Standard**:
  ```dart
  Row(
    children: [
      Icon(Icons.person),
      const SizedBox(width: 8),
      Expanded(
        child: Text(userName, overflow: TextOverflow.ellipsis),
      ),
    ],
  )
  ```

### E. Fixed-Width Print Scaling (FittedBox Protection)
* **Constraint**: Printable document frames with fixed pixel designs (e.g. A4 pages set to `width: 794`) **must** be wrapped in a `LayoutBuilder` constraint and scaled down utilizing `FittedBox`.
* **Standard**:
  ```dart
  LayoutBuilder(
    builder: (context, constraints) {
      final page = Container(width: 794, child: ...);
      if (constraints.maxWidth < 794) {
        return FittedBox(fit: BoxFit.scaleDown, child: page);
      }
      return page;
    },
  )
  ```

## 3. Data Integrity & Relational Resilience

When building or updating features using the Isar offline-first approach, ensure these safety nets are in place to prevent runtime exceptions:

### A. Lazy Initialization of Relational Records
* **Constraint**: When querying for a child module record (e.g. `ProgressReport` for a specific Project) that may not yet exist (e.g. newly created Projects), do **not** throw an exception if the report is null.
* **Standard**: Instead, fetch the parent record, initialize the missing child record with default values gracefully, and proceed with the intended update. This prevents crashes when users interact with newly created records.

### B. Action Button Routing
* **Constraint**: Dashboard Quick Actions or global navigation buttons must route the user (`context.push()`). Do not leave `ScaffoldMessenger` "triggered action" stubs in active features.

### C. Deprecated Flutter Properties
* **Constraint**: In newer Flutter versions, prefer `.withValues(alpha: ...)` instead of `.withOpacity(...)` to keep `dart analyze` logs completely clean.
