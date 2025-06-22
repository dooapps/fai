FAI - Finance Artificial Intelligence SDK

🚀 Overview

FAI is a Flutter/Dart SDK designed to handle secure data serialization, cryptography, and communication for financial applications powered by artificial intelligence. It serves as a high-level bridge between Flutter apps and the FinBberLink Protocol (FBBL), a performant Rust-based core that handles encryption, MAC validation, and frame serialization.

Features
	•	📊 Real-time Financial Data Collection from multiple market sources.
	•	🚀 Automatic Field Mapping to ensure compatibility across different APIs.
	•	🔄 Data Conversion for standardized formats, including numbers and lists.
	•	🔍 Detailed Logging for debugging and monitoring API requests.

 +----------------+       +----------------+       +----------------+
|    FinBo App   | <---> |      FAI       | <---> |      FBBL      |
| (Flutter/Dart) |       | (Flutter/Dart) |       | (Rust + FRB)   |
+----------------+       +----------------+       +----------------+

	•	FAI: Dart SDK. Handles API, models, business logic, and communication with Rust.
	•	FBBL: Rust protocol that implements encryption, MAC, payload handling, and binary serialization.
	•	FinBo App (or others): Consumes FAI to interact with the secure protocol.

  ✨ Features
	•	🔐 ID Encryption & Decryption — AES-GCM / ChaCha20-Poly1305
	•	🧠 Frame Serialization & Deserialization — Binary C-struct format
	•	✅ MAC Generation & Verification — Frame authenticity & integrity
	•	🔒 Payload Encryption for Numeric Vectors (f64)
	•	🪄 Seamless Bridge between Dart and Rust via FlutterRustBridge
	•	🏗️ High-level Dart Models & API for easy integration in apps

  /FINBBERLIK/
├── FAI/
    ├── bridge_generated.dart.    # FBBL    FlutterRustBridge loader
│   ├── fai.dart                  # Public API
│   ├── src/
│   │   ├── data_collector.dart   # Orchestrates Rust calls
│   │   ├── models/                # Data models (Frame, Payload, etc.)
│   │   └── utils/                 # Utilities and helpers
├── pubspec.yaml                   # Flutter/Dart config