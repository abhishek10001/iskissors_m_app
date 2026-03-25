# iScissors - Salon Booking App

A modern Flutter-based salon booking application that connects users with nearby salons and barbershops. This app features a dynamic map interface, real-time seat availability, and a seamless booking workflow.

## Features

- **Dynamic Map View**: Interactive map displaying salon locations with custom pins.
- **Real-Time Availability**: Check salon seat availability before booking.
- **Category Filtering**: Filter salons by service type (Hair, Nails, Facial, etc.).
- **User Authentication**: Secure login and signup process.
- **Home Dashboard**: Curated list of featured salons and popular services.
- **Booking System**: Simple and intuitive booking flow.

## Getting Started

### Prerequisites

- **Flutter**: Version 3.0.0 or higher.
- **Dart**: Version 2.17.0 or higher.
- **Android Studio / VS Code**: With Flutter and Dart plugins.
- **Android Emulator / Physical Device**: Running Android 6.0 (Marshmallow) or higher.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone <repository-url>
    cd iskissors_app
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Run the application**:
    ```bash
    flutter run -d emulator-5554
    ```
    *(Replace `emulator-5554` with your device ID if needed)*

## Project Structure

- `lib/main.dart`: Entry point of the application.
- `lib/presentation/`: Contains all UI screens and widgets.
- `lib/providers/`: Riverpod state management providers.
- `lib/data/`: Data models and repositories.
- `lib/core/`: Core utilities and theme configurations.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
