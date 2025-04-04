# Domï — Smart Inventory Tracker

Domï is a responsive, mobile-first inventory app designed to help users with memory difficulties keep track of household products. Built with Flutter (frontend) and FastAPI (backend), the app allows users to scan product barcodes, tag storage locations (like cupboards or rooms), and monitor quantities for easier online shopping and restocking.

## Features

- Scan product barcodes using a barcode API
- Store and tag product locations (e.g., “Bathroom Cupboard”)
- Track quantity of items and log when something runs out
- Fuzzy search for forgotten items or locations
- Mobile-first, fully responsive UI
- Accessible, simple design for clarity and ease of use

## Tech Stack

- **Frontend**: Flutter
- **Backend**: FastAPI
- **Database**: SQLite (local for MVP)
- **Deployment**: Fly.io (planned)
- **Version Control**: Git & GitHub

## MVP Status

This is an MVP (Minimum Viable Product) currently under development. The frontend is built and running locally. Backend development and full integration are underway. The goal is to eventually deploy to the App Store.

## Getting Started

To run the frontend:

```bash
cd frontend
flutter run -d chrome
```
