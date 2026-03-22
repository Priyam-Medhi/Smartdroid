WakeUp+ : Active-Dismissal Alarm Application
Overview
WakeUp+ is a Flutter-based mobile application designed to solve the problem of alarm circumvention. Instead of a standard dismissal button, the application enforces wakefulness by requiring the user to complete a randomized cognitive puzzle before the system-level alarm and hardware vibration can be deactivated.

Key Features
Dynamic Challenge Engine: Generates randomized puzzles across three categories: Mathematical Operations, Educational Trivia, and Cognitive Color-Matching (Stroop Test).

Anti-Memorization Logic: Automatically regenerates a completely new challenge if the user submits an incorrect answer, preventing bypass via guessing or muscle memory.

Hardware Integration: Utilizes native Android APIs to trigger system-level alarm audio and continuous hardware vibration simultaneously.

Navigation Locking: Overrides the Android hardware back-button during an active alarm, ensuring the user cannot exit the application without completing the assigned task.

Technology Stack
Framework: Flutter

Language: Dart

System Integrations: * flutter_ringtone_player (Native audio channel interface)

vibration (Hardware haptic feedback interface)

Target Platform: Android

Architecture & State Management
Routing: Implements named route navigation (/, /alarm, /challenge) for strict state transitions.

State Management: Utilizes StatefulWidget and localized setState to dynamically rebuild the UI layer upon challenge generation or user failure.

Data Modeling: Employs strongly typed Dart classes (e.g., TriviaQuestion) to securely structure question banks, multiple-choice arrays, and validation logic.

Security: Uses PopScope widgets to intercept and block system-level pop requests during critical application states.

Local Installation & Execution
Clone this repository to your local environment.

Ensure the Flutter SDK is installed and properly configured.

Open a terminal in the project root directory and execute the following commands:

Bash
flutter pub get
flutter run
