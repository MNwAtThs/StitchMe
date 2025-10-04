# StitchMe

![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white)
![Node.js](https://img.shields.io/badge/node.js-6DA55F?style=flat&logo=node.js&logoColor=white)
![Python](https://img.shields.io/badge/python-3670A0?style=flat&logo=python&logoColor=ffdd54)
![FastAPI](https://img.shields.io/badge/FastAPI-005571?style=flat&logo=fastapi)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat&logo=supabase&logoColor=white)

AI-powered wound assessment and treatment device with cross-platform applications for the University of Texas at San Antonio Senior Design capstone project. Transforms traditional wound care into an intelligent, automated system that combines computer vision, LiDAR scanning, and telemedicine capabilities.

## 🎯 Project Purpose

StitchMe revolutionizes wound care by creating an intelligent medical device that:

- **AI-Powered Assessment**: Computer vision analyzes wound severity and recommends treatment
- **Cross-Platform Control**: Flutter apps for iOS, Android, Web, Windows, macOS, and Linux
- **LiDAR 3D Scanning**: iPhone LiDAR creates precise wound measurements and 3D models  
- **Telemedicine Ready**: Video calling connects patients with healthcare professionals
- **Device Integration**: Bluetooth/WiFi pairing between mobile apps and treatment device
- **HIPAA Compliant**: Secure data handling for medical information

## 🚀 Quick Start

```bash
# Clone and setup
git clone <repository-url>
cd StitchMe

# Run setup script
chmod +x scripts/setup-dev.sh
./scripts/setup-dev.sh

# Start Flutter app
cd apps/flutter_app && flutter run -d chrome
# Visit http://localhost:8080
```

## 🏗️ Architecture

```
StitchMe/
├── apps/
│   ├── flutter_app/         # Flutter app (Mobile + Desktop + Web)
│   ├── native_modules/      # iOS LiDAR & Bluetooth integration
│   └── device/              # Embedded device code (Python/Arduino)
├── services/
│   ├── api/                 # Node.js + Express API server
│   ├── ai-service/          # Python + FastAPI AI microservice
│   └── realtime/            # WebRTC signaling server
├── packages/
│   ├── shared_models/       # Dart data models
│   ├── core_utils/          # Utilities & validators
│   ├── ui_kit/              # UI components & themes
│   └── device_sdk/          # Device communication SDK
└── infrastructure/          # Docker, deployment configs
```

## ✅ Development Status

### **Phase 1 — Foundation** ✅ **COMPLETE**
- Monorepo structure with apps/, services/, and packages/
- Flutter cross-platform app with authentication UI
- Backend API structure with Node.js and Python services
- Development environment and build scripts ready

### **Phase 2 — Core Features** 🔄 **IN PROGRESS**
- Camera integration and image processing
- iOS LiDAR 3D scanning with ARKit
- Basic AI wound detection and analysis
- Supabase backend integration

### **Phase 3 — AI & Intelligence** ⏳ **PLANNED**
- Advanced wound classification models (PyTorch)
- Treatment recommendation engine
- Mobile model optimization (TensorFlow Lite)
- Vital signs analysis integration

### **Phase 4 — Communication** ⏳ **PLANNED**
- WebRTC video calling system
- Device pairing and control protocols
- Real-time data synchronization
- Healthcare provider dashboard

### **Phase 5 — Production** ⏳ **PLANNED**
- HIPAA compliance and security audit
- Performance optimization and testing
- Deployment infrastructure and monitoring

## 🛠️ Technology Stack & Why

### **Our Choice: Flutter + Node.js + Python Hybrid**

**Why This Combination?**

- **Flutter**: Single codebase for iOS, Android, Web, Desktop - perfect for medical device control
- **Node.js API**: Fast, scalable backend with excellent WebRTC support for telemedicine
- **Python AI Service**: PyTorch and OpenCV for advanced computer vision and ML
- **Supabase**: Managed database, auth, and real-time features with HIPAA compliance options

### **Frontend Framework Comparison**

| Framework | Platforms | LiDAR Support | Development Speed | Performance | Medical Device Fit |
|-----------|-----------|---------------|-------------------|-------------|-------------------|
| **Flutter** ✅ | iOS, Android, Web, Desktop | ✅ iOS ARKit | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ✅ **Perfect** |
| React Native | iOS, Android, (Web) | ✅ iOS ARKit | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⚠️ Limited desktop |
| Native (Swift/Kotlin) | Platform-specific | ✅ Full access | ⭐⭐ | ⭐⭐⭐⭐⭐ | ❌ Too complex |
| Xamarin | iOS, Android, Windows | ⚠️ Limited | ⭐⭐⭐ | ⭐⭐⭐ | ⚠️ Microsoft dependency |
| Ionic/Cordova | iOS, Android, Web | ❌ No access | ⭐⭐⭐⭐ | ⭐⭐ | ❌ Hardware limitations |
| Electron + Web | Desktop, Web | ❌ No mobile | ⭐⭐⭐⭐⭐ | ⭐⭐ | ❌ No mobile support |

### **Backend Technology Comparison**

| Technology | Pros | Cons | Medical Use Case Fit |
|------------|------|------|---------------------|
| **Node.js + Express** ✅ | Fast development, great WebRTC support, huge ecosystem | Single-threaded limitations | ✅ **Excellent for APIs** |
| **Python + FastAPI** ✅ | Perfect for AI/ML, automatic docs, type hints | Slower than Node.js | ✅ **Perfect for AI services** |
| Java Spring Boot | Enterprise-grade, robust | Verbose, slower development | ⚠️ Overkill for MVP |
| .NET Core | Strong typing, good performance | Microsoft ecosystem lock-in | ⚠️ Platform limitations |
| Go | Excellent performance, simple deployment | Smaller ecosystem, learning curve | ⚠️ Limited AI libraries |
| Ruby on Rails | Rapid development | Performance limitations | ❌ Not suitable for real-time |

### **Database & Backend Services Comparison**

| Service | Pros | Cons | Medical Device Fit |
|---------|------|------|-------------------|
| **Supabase** ✅ | PostgreSQL, real-time, auth, HIPAA options | Newer service | ✅ **Perfect for MVP** |
| Firebase | Google ecosystem, real-time | NoSQL limitations, vendor lock-in | ⚠️ Limited complex queries |
| AWS Amplify | Full AWS integration | Complex setup, expensive | ⚠️ Overkill for students |
| Custom PostgreSQL | Full control, proven | Infrastructure management | ❌ Too much overhead |
| MongoDB Atlas | Flexible schema | NoSQL learning curve | ⚠️ Medical data needs structure |

### **AI/ML Framework Comparison**

| Framework | Strengths | Medical Vision Use | Mobile Deployment | Learning Curve |
|-----------|-----------|-------------------|-------------------|----------------|
| **PyTorch** ✅ | Research-friendly, dynamic graphs | ✅ Excellent | ✅ TorchScript | ⭐⭐⭐ |
| **TensorFlow** ✅ | Production-ready, TF Lite | ✅ Excellent | ✅ TensorFlow Lite | ⭐⭐⭐⭐ |
| OpenCV | Computer vision focus | ✅ Perfect for preprocessing | ✅ Mobile support | ⭐⭐ |
| Scikit-learn | Traditional ML | ⚠️ Limited for vision | ❌ Not for deep learning | ⭐ |
| Keras | Beginner-friendly | ✅ Good | ✅ Via TensorFlow | ⭐ |
| ONNX | Cross-platform inference | ✅ Good | ✅ Mobile runtimes | ⭐⭐⭐ |

### **Key Advantages for Medical Applications**

**Security & Compliance**
- End-to-end encryption for medical data
- HIPAA-compliant data handling
- Secure video calling with WebRTC
- Role-based access control (patients vs providers)

**Cross-Platform Deployment**
- Single Flutter codebase for all platforms
- Consistent medical UI/UX across devices
- Easy deployment to hospitals and clinics

**Hardware Integration**
- iOS LiDAR for precise wound measurement
- Bluetooth/WiFi device pairing
- Camera integration for wound photography
- Real-time sensor data processing

**Maintainability**
- Modern frameworks familiar to developers
- Component-based architecture for easy feature additions
- Docker containerization for consistent deployments

## 🎯 Key Features

### **Mobile Apps (iOS/Android) - Phase 2** 🔄
- **Wound Scanning**: Camera + LiDAR integration for 3D wound mapping
- **Device Pairing**: Bluetooth/WiFi connection with animated pairing process
- **AI Analysis**: Real-time wound assessment and treatment recommendations
- **Video Calling**: Direct connection to healthcare professionals
- **Patient Profiles**: Secure medical history and vital signs tracking

### **Desktop Apps (Windows/macOS/Linux) - Phase 4** ⏳
- **Device Management**: Control and monitor StitchMe devices
- **Healthcare Dashboard**: Provider interface for patient management
- **Video Consultations**: Professional telemedicine interface
- **Analytics**: Wound healing progress and treatment outcomes

### **Web Dashboard - Phase 4** ⏳
- **Hospital Integration**: EMR system compatibility
- **Multi-Device Management**: Control multiple StitchMe units
- **Reporting**: Compliance and analytics dashboards
- **Admin Panel**: User management and system configuration

### **AI & Hardware Integration**

```python
# AI Service Endpoints
POST /analyze-wound     # Computer vision wound analysis
POST /process-lidar     # 3D LiDAR data processing  
POST /analyze-vitals    # Vital signs assessment
POST /recommend-treatment # Treatment recommendation engine
```

## 🛠️ Development

```bash
# Flutter app development
cd apps/flutter_app
flutter run -d chrome        # Web
flutter run -d ios          # iOS simulator
flutter run -d android      # Android emulator

# Backend services
cd services/api && npm run dev              # Node.js API
cd services/ai-service && python main.py   # Python AI service

# All services with Docker
docker-compose up -d
```

## 🏥 Medical Device Deployment

### **Hardware Requirements**
- **Mobile**: iPhone 12 Pro+ (LiDAR), Android 8.0+
- **Desktop**: 8GB RAM, modern CPU, camera for video calls
- **StitchMe Device**: Raspberry Pi 4 or Jetson Nano, cameras, sensors
- **Network**: WiFi/Bluetooth for device communication

### **Security & Compliance Features**
- **HIPAA Compliance**: Encrypted data storage and transmission
- **Role-Based Access**: Patient vs healthcare provider permissions
- **Audit Logging**: Complete medical data access tracking
- **Secure Communication**: End-to-end encrypted video calls
- **Data Retention**: Configurable medical record retention policies

### **StitchMe Device Integration**

```bash
# Device Communication Protocols
bluetooth/pair          # Device pairing process
wifi/control           # Remote device control
sensors/vitals         # Vital signs monitoring
camera/wound-scan      # Wound imaging and analysis
actuator/treatment     # Automated treatment application
```

## 🧪 Testing

- **Development**: `flutter run -d chrome` → http://localhost:8080
- **API Testing**: Postman collection for all endpoints
- **AI Models**: Jupyter notebooks for model training and validation
- **Device Simulation**: Mock device for testing without hardware
- **Video Calling**: WebRTC test suite for telemedicine features

## 🎓 Academic Project

**University of Texas at San Antonio - Senior Design Capstone**
- **Course**: ECE Senior Design I & II (Fall 2024 - Spring 2025)
- **Team**: 4-5 Electrical and Computer Engineering students
- **Objective**: Design and build innovative medical device with AI integration
- **Timeline**: 2 semesters (design → prototype → testing)

### **Project Scope**
- **Semester 1**: Software development, AI model training, system design
- **Semester 2**: Hardware integration, device assembly, clinical testing
- **Deliverables**: Working prototype, technical documentation, presentation

## 📄 License

Licensed under the MIT License - see LICENSE file for details.

---

**Ready for clinical testing** 🏥 | **AI-powered diagnostics** 🤖 | **Cross-platform deployment** 📱💻🌐