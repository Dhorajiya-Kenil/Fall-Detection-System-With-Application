# Fall Detection & Emergency Alert System

A Flutter-based fall detection and personal safety application designed
to help people quickly notify a trusted contact when an emergency may
have occurred.

The application combines **phone motion sensors**, **GPS location**,
**Firebase**, and **Twilio SMS** to provide an automatic emergency-alert
workflow. It is particularly useful for **elderly people who may fall
when nobody is nearby**, while also providing a manual location-sharing
option for anyone who feels unsafe.

------------------------------------------------------------------------

## Project Overview

The Fall Detection System continuously monitors relevant phone motion
data to detect movement patterns that may indicate a fall.

When a possible fall is detected:

1.  The application detects unusual motion using the device's
    **accelerometer and gyroscope**.
2.  A **10-second cancellation window** appears.
3.  The user can cancel the alert if the movement was accidental or no
    help is required.
4.  If the alert is not cancelled, the application obtains the user's
    **current location**.
5.  An emergency **SMS containing a live/location-sharing link** is sent
    to the user's selected emergency contact through **Twilio**.

The application also supports **manual location sharing**. A user can
open the contact list, select a contact, and use the location action to
send their current location without waiting for fall detection.

------------------------------------------------------------------------

## Main Goals

-   Automatically detect a possible fall using smartphone motion
    sensors.
-   Give the user a short opportunity to cancel false alarms.
-   Automatically obtain the user's location during an emergency.
-   Send an emergency notification through Twilio.
-   Allow users to configure trusted/emergency contacts.
-   Provide a manual way to share location when the user feels unsafe.
-   Store required user information using Firebase.
-   Provide an accessible safety workflow for elderly users and other
    people who may need quick assistance.

------------------------------------------------------------------------

## Key Features

### Automatic Fall Detection

The application uses smartphone motion sensors to monitor movement.

-   **Accelerometer** data is used to observe changes in device
    movement.
-   **Gyroscope** data is used to observe rotational movement.
-   A configurable motion threshold is used to determine when a possible
    fall event has occurred.
-   The current implementation includes a fall/shake detection workflow
    rather than relying on a single sensor value.

### 10-Second Alert Cancellation

Accidental movements can happen, so the application provides a
**10-second cancellation period** before sending an emergency SMS.

For example:

> If the user accidentally shakes or drops/moves the phone and a fall is
> detected, they can press **Cancel** during the countdown to prevent
> the message from being sent.

This helps reduce unnecessary alerts.

### Location Sharing

When an emergency alert is triggered, the application obtains the user's
location using the device's location services.

The location can then be included in the Twilio message so the emergency
contact can identify where assistance may be needed.

### Automatic SMS Through Twilio

The project uses **Twilio** to send emergency SMS notifications.

A typical emergency message can contain information such as:

-   Emergency/fall alert
-   User/contact information configured by the application
-   Current latitude and longitude
-   A map/location link

> The exact SMS content depends on the implementation and Twilio
> configuration.

### Emergency Contacts

Users can add trusted contacts who should receive emergency
notifications.

These contacts are used by the emergency-alert workflow when a possible
fall is confirmed.

### Manual Location Sharing

The application can also be used without a detected fall.

For example, if a user feels uncomfortable or unsafe while walking
somewhere, they can:

1.  Open the application.
2.  Open the contact list.
3.  Select the appropriate contact.
4.  Tap the **location icon**.
5.  Send their current location through SMS.

This provides a quick manual safety feature in addition to automatic
fall detection.

### Firebase Integration

Firebase is used for application user data.

It can support the project's user/contact data workflow and provide
cloud-backed storage for information required by the application.

The exact Firebase services used should match the Firebase configuration
included in the project.

------------------------------------------------------------------------

## Technology Stack

  Technology          Purpose
  ------------------- -----------------------------------------------------------
  **Flutter**         Cross-platform mobile application development
  **Dart**            Application programming language
  **Firebase**        User/application data storage
  **Twilio**          Emergency SMS delivery
  **Accelerometer**   Detects changes in linear phone movement
  **Gyroscope**       Detects rotational movement
  **Geolocator**      Obtains device location
  **HTTP**            Communicates with external services/APIs
  **GetX**            State management/navigation utilities used by the project

### Main Flutter Packages

The project currently uses packages/components including:

-   `sensors_plus`
-   `geolocator`
-   `http`
-   `get`
-   Firebase-related Flutter configuration/packages

See `pubspec.yaml` for the complete and authoritative dependency list.

------------------------------------------------------------------------

## Application Workflow

``` text
                    ┌──────────────────────┐
                    │   User opens app     │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │ Monitor phone motion │
                    │ Accelerometer +      │
                    │ Gyroscope            │
                    └──────────┬───────────┘
                               │
                     Possible fall detected
                               │
                               ▼
                    ┌──────────────────────┐
                    │ 10-second countdown  │
                    │ / Cancel option      │
                    └───────┬───────┬──────┘
                            │       │
                       Cancel       │ No cancellation
                            │       │
                            ▼       ▼
                         Stop   ┌─────────────────┐
                                │ Get current GPS │
                                │ location        │
                                └────────┬────────┘
                                         │
                                         ▼
                                ┌─────────────────┐
                                │ Twilio sends SMS│
                                │ to emergency    │
                                │ contact         │
                                └────────┬────────┘
                                         │
                                         ▼
                                ┌─────────────────┐
                                │ Contact receives│
                                │ emergency +     │
                                │ location info   │
                                └─────────────────┘
```

------------------------------------------------------------------------

## Manual Safety Workflow

The application can also send a location manually:

``` text
Open Application
       │
       ▼
Open Contact List
       │
       ▼
Select Trusted Contact
       │
       ▼
Tap Location Icon
       │
       ▼
Get Current Location
       │
       ▼
Send SMS Through Twilio
       │
       ▼
Contact Receives Location
```

This makes the application useful not only for fall detection, but also
as a simple personal safety/location-sharing tool.

------------------------------------------------------------------------

## Project Structure

The project follows a standard Flutter structure.

``` text
fall_detection/
├── android/
├── assets/
├── ios/
├── lib/
│   ├── main.dart
│   ├── LoginPage.dart
│   ├── FallDetected.dart
│   ├── NotificationsPage.dart
│   ├── Dashboard.dart
│   ├── Contact.dart
│   └── ...
├── test/
├── web/
├── linux/
├── macos/
├── windows/
├── pubspec.yaml
├── pubspec.lock
├── firebase.json
├── .gitignore
├── .metadata
├── analtsis_options.yaml
└── README.md
```

> File names and folders may change as the project evolves. The current
> repository structure should be treated as the source of truth.

------------------------------------------------------------------------

## Getting Started

### Prerequisites

Before running the project, install:

-   [Flutter SDK](https://flutter.dev/)
-   Dart SDK (included with Flutter)
-   Android Studio and/or another Flutter-compatible IDE
-   Android Emulator or a physical Android device
-   A Firebase project
-   A Twilio account with SMS capability
-   A device with location and motion-sensor support

A **physical device is recommended** for testing fall detection because
emulator sensor behavior may not accurately represent real-world
movement.

### 1. Clone the Repository

``` bash
git clone <your-repository-url>
cd fall_detection
```

### 2. Install Dependencies

``` bash
flutter pub get
```

### 3. Configure Firebase

Create/configure a Firebase project and connect it to the Flutter
application.

Depending on the project's current Firebase setup, this may include:

-   Android Firebase configuration
-   iOS Firebase configuration
-   Firebase project initialization
-   Required database/security configuration

Do not commit private credentials or sensitive Firebase configuration
that should remain secret.

### 4. Configure Twilio

Create a Twilio account and configure the SMS functionality required by
the application.

The application needs the appropriate Twilio configuration for sending
SMS messages.

**Do not hard-code sensitive Twilio credentials into source code.**

For production, use a secure backend/server-side approach or protected
environment configuration for secrets such as:

``` text
TWILIO_ACCOUNT_SID
TWILIO_AUTH_TOKEN
TWILIO_PHONE_NUMBER
```

> Never expose a Twilio Auth Token in a public Flutter application.
> Client-side applications can be reverse-engineered, so sensitive
> credentials should be protected on a trusted server.

### 5. Configure Location Permissions

Location permission must be configured for the target platforms.

For Android, verify the required permissions in:

``` text
android/app/src/main/AndroidManifest.xml
```

For iOS, configure the appropriate location usage descriptions in:

``` text
ios/Runner/Info.plist
```

The exact permissions should match the location behavior implemented by
the application.

### 6. Run the Application

Check connected devices:

``` bash
flutter devices
```

Then run:

``` bash
flutter run
```

------------------------------------------------------------------------

## Fall Detection Logic

The fall detection workflow uses sensor readings to identify unusual
motion.

The project contains a configurable threshold similar to:

``` dart
static const double shakeThreshold = 13.0;
```

The exact detection behavior depends on the sensor values and logic
implemented in `main.dart`.

A production fall-detection system should be tested extensively with
real devices because:

-   Different phones have different sensors.
-   Sensor readings can vary between manufacturers.
-   Carrying position affects sensor data.
-   Normal activities can resemble falls.
-   A single threshold may not reliably identify every real-world fall.

For these reasons, the threshold and detection algorithm should be
treated as configurable project parameters rather than universal
medical-grade values.

------------------------------------------------------------------------

## Security Considerations

This application handles potentially sensitive information, including
user data, contact information, and location data.

Recommended security practices include:

-   Never store Twilio secrets directly in the Flutter client.
-   Never commit API keys or authentication tokens to Git.
-   Apply appropriate Firebase security rules.
-   Limit access to user/contact records.
-   Protect location data as sensitive information.
-   Use HTTPS for network communication.
-   Validate user input before storing or sending it.
-   Avoid logging personal location information in production.
-   Use the minimum permissions required by the application.

------------------------------------------------------------------------

## Testing

Testing should cover both normal operation and emergency scenarios.

### Fall Detection

Test scenarios such as:

-   Normal walking
-   Sitting down
-   Standing up
-   Running
-   Placing the phone on a surface
-   Accidental phone movement
-   Simulated fall-like motion
-   Different phone orientations

### Cancellation

Verify that:

-   The 10-second countdown appears.
-   The user can cancel the alert.
-   Cancellation prevents the SMS from being sent.
-   The application returns to its normal state afterward.

### Emergency SMS

Verify that:

-   The correct contact receives the SMS.
-   The message contains the expected information.
-   The location link is valid.
-   Twilio errors are handled appropriately.
-   Network failures do not leave the application in an inconsistent
    state.

### Manual Location Sharing

Verify that:

-   Contacts are displayed correctly.
-   The location button works.
-   Location permission is handled correctly.
-   The correct contact receives the message.
-   Location information is generated correctly.

------------------------------------------------------------------------

## Real-World Usage

The system is designed around situations where a person may not be able
to manually call for help.

### Example: Elderly User

An elderly person falls at home or somewhere outside while nobody is
nearby.

``` text
Fall
 ↓
Phone detects unusual motion
 ↓
10-second cancellation period
 ↓
No cancellation
 ↓
Location obtained
 ↓
Emergency SMS sent
 ↓
Trusted contact receives location
```

The goal is to reduce the time between a possible fall and notification
of a trusted person.

### Example: Personal Safety

A person is walking somewhere and feels uncomfortable or unsafe.

Instead of waiting for automatic detection, they can manually open the
application, choose a trusted contact, and send their current location.

------------------------------------------------------------------------

## Important Limitations

This project is a **software safety tool and not a guaranteed
emergency-response system or medical device**.

Its ability to send an alert depends on several external conditions,
including:

-   The phone being powered on.
-   The application having the required permissions.
-   GPS/location services being available.
-   Internet or mobile connectivity being available.
-   Twilio being available and correctly configured.
-   The recipient being reachable.
-   The phone's sensors producing usable readings.

Automatic fall detection can also produce **false positives** or
**missed detections**. The 10-second cancellation step is included to
reduce accidental alerts, but it cannot eliminate all false alarms.

For serious emergencies, users should also use appropriate local
emergency services.

------------------------------------------------------------------------

## Privacy

Because the application can process location and contact information,
privacy should be considered throughout development and deployment.

Before releasing the application publicly, define:

-   What user data is collected.
-   Why the data is collected.
-   Where it is stored.
-   How long it is retained.
-   Who can access it.
-   How users can delete or update their information.
-   How location data is protected.

A production release should also include an appropriate privacy policy
and comply with applicable data-protection requirements.

------------------------------------------------------------------------

## Future Improvements

Potential future improvements include:

-   More advanced fall-detection algorithms using multiple sensor
    signals.
-   Machine-learning-based activity/fall classification.
-   Configurable countdown duration.
-   Multiple emergency contacts.
-   Push notifications in addition to SMS.
-   Automatic contact escalation if the first contact does not respond.
-   Improved background monitoring.
-   Battery-efficient sensor processing.
-   Fall-event history and reporting.
-   Better offline/network failure handling.
-   Emergency contact confirmation.
-   Improved accessibility for elderly users.
-   Localization and multiple language support.
-   More detailed analytics for false-positive/false-negative testing.

------------------------------------------------------------------------

## License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file included in this repository.

Please read the `LICENSE` file for the complete license terms and conditions.

------------------------------------------------------------------------

## Project Summary

**Fall Detection & Emergency Alert System** is a Flutter application
focused on helping users quickly notify trusted contacts during possible
falls or personal-safety situations.

The core workflow combines:

**Motion Detection → 10-Second Cancellation → GPS Location → Twilio SMS
→ Trusted Contact**

The project is especially focused on situations where an elderly person
or another user may need assistance but cannot immediately reach a phone
or manually request help.
