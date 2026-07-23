# MHGo

![Version](https://img.shields.io/badge/version-v1.4.0-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-Material_3-02569B?logo=flutter)
![Database](https://img.shields.io/badge/Database-Isar_Offline-FF9900)
![AI](https://img.shields.io/badge/AI-Gemini_3_Flash-8E75B2?logo=google)

> **Built for MHG.**

MHGo is an **offline-first Solar EPC Project Management Platform** built with **Flutter** to streamline the complete lifecycle of solar engineering projects. It replaces spreadsheets, paper forms, and scattered communications with a centralized application for managing surveys, project execution, progress tracking, materials, and reporting.

> **Project Status:** 🚧 Active Development

---

# Overview

MHGo is a personal portfolio project inspired by real-world Solar EPC workflows. It is designed primarily for **Android** deployment while remaining compatible with **Windows** for desktop use.

The application follows an **offline-first** architecture using **Isar** as its local database, allowing field engineers and project managers to continue working without an internet connection.

Future versions will support optional cloud synchronization using **Laravel** and **PostgreSQL**.

---

# Tech Stack

### Frontend

- Flutter
- Material 3

### Architecture

- Feature-first Clean Architecture
- Riverpod
- GoRouter

### Local Database

- Isar

### Planned Backend

- Laravel
- PostgreSQL

---

# Current Features

## Authentication

- Login
- Forgot Password
- Theme Support

## Dashboard

- Dynamic KPIs
- Active Projects
- Portfolio Overview
- Recent Activity
- Notifications
- Quick Actions
- Live module synchronization
- **Global AI Assistant (Gemini API Integration)**

## Survey Module

Replaces the original QA/QC module with a client-focused pre-project workflow.

- Survey CRUD
- Client Management
- Proposal Information
- Technical Specifications
- Survey-to-Project Conversion
- PDF Preview & Export *(ongoing improvements)*

## Projects

- Portfolio Management
- Project CRUD
- Project Details
- Responsive Project Profiles
- Material Requirements
- Progress Integration

## Daily Accomplishment Reports (DAR)

- Create Reports
- DAR History
- PDF Preview
- Responsive Forms
- Offline Storage

## Progress Tracking

- Progress Categories
- Percentage Tracking
- Dashboard Synchronization
- Project Integration
- Offline CRUD

## Materials & Inventory

Currently in development.

Planned functionality includes:

- Inventory Management
- Material Requests
- Deliveries
- Stock Monitoring
- Project Material Requirements

## Site Inspections

- Comprehensive safety and quality checklists
- Pass/Fail/NA toggles with remarks
- Non-Conformance tracking (severity, deadlines, responsible persons)
- Offline CRUD and Dashboard Sync
- Dedicated PDF Reporting with Signatures

## AI Integration

- Global AI Assistant (Dashboard Scope)
- Secure API Key Management (.env)
- Project Context Builder (Database to Markdown)
- Powered by `gemini-3-flash-preview` model

---

# Development Roadmap

| Module | Status |
|---------|--------|
| Project Foundation | ✅ Complete |
| Dashboard | ✅ Complete |
| AI Assistant Integration | ✅ Complete |
| Survey Module | ✅ Complete *(ongoing refinements)* |
| Projects | ✅ Complete |
| Daily Accomplishment Reports | ✅ Complete |
| Progress Tracking | ✅ Complete |
| Site Inspections | ✅ Complete |
| Materials & Inventory | 🚧 In Progress |
| Punch Lists | ⏳ Planned |
| Documents | ⏳ Planned |
| Commissioning | ⏳ Planned |
| Settings | ⏳ Planned |
| Offline Synchronization | ⏳ Planned |
| UI/UX Polish | ⏳ Planned |
| Laravel Backend | ⏳ Planned |

---

# Design Principles

- Offline-first
- Android-first
- Windows compatible
- Material 3
- Feature-first Clean Architecture
- Responsive layouts
- Reusable components
- Enterprise-inspired UI/UX

---

# Project Structure

```text
lib/
├── core/
├── shared/
├── features/
│   ├── ai_assistant/
│   ├── authentication/
│   ├── dashboard/
│   ├── survey/
│   ├── projects/
│   ├── dar/
│   ├── progress/
│   ├── inspections/
│   ├── materials/
│   ├── punchlist/
│   ├── documents/
│   ├── commissioning/
│   └── settings/
```

---

# Getting Started

## Requirements

- Flutter (latest stable)
- Dart SDK
- Android Studio or VS Code
- Android SDK

## Run

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run -d android
```

## Build APK

```bash
flutter build apk
```

---

# Current Development

Current priorities include:

- Completing the Materials & Inventory warehouse logic
- Progress module standalone PDF exporter (Gantt-style)
- Multi-user authentication integration (Firebase Auth)
- Ongoing UI/UX polish for offline synchronization

---

# Future Plans

- Procurement Workflow
- BOQ Integration
- ROI Calculator
- Monthly Savings Calculator
- Document Management
- Commissioning Module
- Cloud Synchronization
- Multi-user Support
- Reporting & Analytics

---

# License

This project is currently developed as a **personal portfolio and learning project** and is not affiliated with MHG.

---

<div align="center">

### MHGo

**Built for MHG.**

*Offline-first Solar EPC Project Management Platform.*

</div>