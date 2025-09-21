import 'dart:io';

// class ServerConstants {
//   static String get serverURL {
//     // For Android Emulator
//     if (Platform.isAndroid) {
//       return 'http://10.0.2.2:8000'; // For Android emulators
//     }

//     // For iOS Simulator
//     if (Platform.isIOS) {
//       return 'http://127.0.0.1:8000'; // For iOS Simulators
//     }

//     // For Physical Devices (both Android & iOS)
//     return 'http://192.168.75.35:8000'; // Replace with your machine's IP address
//   }
// }


class ServerConstants {
static String get serverURL {
    if (Platform.isAndroid || Platform.isIOS) {
        return 'http://192.168.35.35:8000';  // Use physical device IP directly for testing
    }
    return 'http://127.0.0.1:8000';  // For emulators/simulators
}
}










// import 'dart:io';

// class ServerConstants {
//   static String serverURL = Platform.isAndroid ? 'http://10.0.2.2:8000': 'http://127.0.0.1:800';
// }

