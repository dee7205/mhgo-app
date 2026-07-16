# MHGo

**Built for MHG.**

MHGo is an **offline-first Solar EPC Project Management Platform** built with Flutter. It is designed to replace spreadsheets, paper forms, and scattered project files with a centralized application that helps manage the lifecycle of engineering projects.

> **Project Status:** 🚧 Active Development (Work in Progress)

---

## Overview

MHGo is currently being developed as a **personal project management application** focused on Android-first deployment while maintaining Windows compatibility.

The application follows an offline-first approach using a local database, allowing engineers to manage projects without requiring an internet connection.

---

## Tech Stack

### Frontend

* Flutter
* Material 3

### Architecture

* Feature-first Clean Architecture
* Riverpod
* GoRouter

### Local Database

* Isar

### Future Backend (Planned)

* Laravel
* PostgreSQL

---

## Current Features

### ✅ Authentication

* Login
* Forgot Password
* Theme support

### ✅ Dashboard

* Dynamic KPIs
* Active Projects
* Notifications
* Quick Actions
* Recent Activity

### ✅ Projects

* Portfolio Management
* Project CRUD
* Project Details
* Responsive layouts

### ✅ Daily Accomplishment Reports (DAR)

* Create Reports
* DAR History
* PDF Preview
* Responsive desktop/mobile UI

### ✅ QA/QC Site Inspections

* Inspection Management
* Inspection History
* Inspection Details

### ✅ Progress Tracking

* Project Progress
* Progress Categories
* Progress Analytics
* Offline CRUD
* Dashboard Synchronization

### 🚧 Materials & Inventory

Currently under development.

Planned:

* Inventory Management
* Project Materials
* Stock Monitoring

---

## Roadmap

* [x] Project Foundation
* [x] Dashboard
* [x] Projects
* [x] Daily Accomplishment Reports
* [x] QA/QC Inspections
* [x] Progress Tracking
* [ ] Materials & Inventory
* [ ] Punch Lists
* [ ] Documents
* [ ] Commissioning
* [ ] Settings & Offline Sync
* [ ] Final UI/UX Polish
* [ ] Backend Synchronization

---

## Design Principles

* Offline-first
* Android-first experience
* Windows compatible
* Responsive layouts
* Material 3
* Clean Architecture
* Reusable components
* Modern enterprise UI/UX

---

## Project Structure

```text
lib/
├── core/
├── shared/
├── features/
│   ├── authentication/
│   ├── dashboard/
│   ├── projects/
│   ├── dar/
│   ├── inspections/
│   ├── progress/
│   ├── materials/
│   ├── punchlist/
│   ├── documents/
│   ├── commissioning/
│   └── settings/
```

---

## Getting Started

### Requirements

* Flutter (latest stable)
* Dart SDK
* Android Studio or VS Code
* Android SDK

### Run

```bash
flutter pub get
flutter run -d android
```

### Build APK

```bash
flutter build apk
```

---

## Current Development Status

MHGo is under active development.

The application architecture is established, and the core project management workflow is functional. Remaining modules will be implemented incrementally while maintaining a consistent design system and offline-first architecture.

---

## License

This project is currently developed as a personal portfolio and learning project.

---

**MHGo — Built for MHG.**
