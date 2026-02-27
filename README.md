# Kigali City Services & Places Directory

## Overview

Kigali City Services & Places Directory is a Flutter mobile application designed to help residents locate and navigate to essential public services and lifestyle locations such as hospitals, restaurants, cafés, parks, libraries, and other public facilities.

The application integrates Firebase Authentication and Cloud Firestore to provide real-time backend connectivity, secure user access, and cloud-based data persistence.

This project demonstrates clean architecture, state management using Provider, and real-time Firestore integration.

---

## Features

### 1. User Authentication (Firebase Auth)
- Email & Password sign up
- Secure login & logout
- Email verification required before access
- Firestore user profile creation using UID

### 2. Listings Management (Firestore CRUD)
Users can:

- Create a new service/location listing
- View all listings in a shared directory
- Update listings they created
- Delete listings they created

Each listing includes:
- Name
- Category
- Address
- Contact number
- Description
- Created By (User UID)

All updates reflect instantly due to real-time Firestore listeners.

---

### 3. Search & Category Filtering
- Live search by listing name
- Category filtering (Hospital, Restaurant, Café, Park, Library, etc.)
- Combined search + filter functionality
- Dynamic UI updates via Provider state management

---

### 4. Listing Detail Page
When a listing is selected:
- A detailed information screen opens
- Embedded Google Map displays the exact location
- A marker indicates the service location
- A navigation button launches Google Maps directions

---

### 5. Navigation Structure
The application uses a BottomNavigationBar with four screens:

- Directory
- My Listings
- Map View
- Settings

---

### 6. Settings Screen
- Displays authenticated user email
- Logout functionality
- Structured for notification preference expansion

---

## Firestore Database Structure

The application uses two primary collections:

### Collection: users

Each document ID is the Firebase Authentication UID.

Fields:
- `email` (String)
- `createdAt` (Timestamp)

---

### Collection: listings

Each document represents a service/location entry.

Fields:
- `name` (String)
- `category` (String)
- `address` (String)
- `contact` (String)
- `description` (String)
- `latitude` (Double)
- `longitude` (Double)
- `createdBy` (String - UID reference)
- `timestamp` (Firestore Timestamp)

---

## Data Modeling

A `ListingModel` class is used to convert Firestore documents into structured Dart objects using a factory constructor. This ensures separation between raw database data and UI representation.

---

## State Management Approach

This application uses **Provider** for state management.

### Why Provider?

Provider was selected because it:

- Separates business logic from UI
- Allows real-time updates through ChangeNotifier
- Ensures UI rebuilds automatically when Firestore data changes
- Improves code organization and scalability

### How It Works

All Firestore operations are handled inside `ListingProvider`.

Responsibilities of ListingProvider:
- Listen to Firestore real-time snapshots
- Manage search query state
- Manage selected category state
- Handle add and delete operations
- Provide filtered listing data to UI

UI widgets subscribe to changes using:

```dart
context.watch<ListingProvider>()

**### Project Architecture**
lib/
 ├── models/
 ├── services/
 ├── providers/
 ├── screens/
 │    ├── auth/
 │    ├── home/
 └── main.dart
models → Data representation classes

services → Firebase authentication logic

providers → Firestore and state management logic

screens → UI components

This structure improves maintainability and scalability.

**Technologies Used**

Flutter

Firebase Authentication

Cloud Firestore

Google Maps Flutter

Provider (State Management)

URL Launcher

**Setup Instructions**

Clone repository

Add your google-services.json file inside android/app

Add your Google Maps API key inside AndroidManifest.xml

**Run:**
flutter pub get
flutter run
