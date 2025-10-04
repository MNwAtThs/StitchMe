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

### **Phase 3 — AI & Communication** ⏳ **PLANNED**
- Advanced wound classification models (PyTorch)
- WebRTC video calling system
- Device pairing and control protocols
- HIPAA compliance and security audit

## 🛠️ Technology Stack & Why

### **Our Choice: Flutter + Node.js + Python Hybrid**

| Component | Technology | Why Chosen |
|-----------|------------|------------|
| **Frontend** | Flutter | Single codebase for all platforms + LiDAR support |
| **API Server** | Node.js + Express | Fast development + excellent WebRTC support |
| **AI Service** | Python + FastAPI | Perfect for ML/CV + automatic API docs |
| **Database** | Supabase | Managed PostgreSQL + auth + HIPAA options |
| **ML/AI** | PyTorch + OpenCV | Research-friendly + proven computer vision |

### **Key Alternatives Considered**

| Alternative | Pros | Why Not Chosen |
|-------------|------|----------------|
| React Native | Great mobile development | Limited desktop support |
| Native Apps | Maximum performance | Too complex for team size |
| Firebase | Google ecosystem | NoSQL limitations for medical data |
| Pure Web App | Easy deployment | No LiDAR access, limited device integration |

## 🎯 Key Features

### **Mobile Apps (iOS/Android)**
- Wound scanning with camera + LiDAR integration
- Device pairing with animated Bluetooth/WiFi connection
- Real-time AI wound analysis and treatment recommendations
- Video calling with healthcare professionals

### **Desktop & Web Apps**
- Healthcare provider dashboard and device management
- Multi-device control and patient monitoring
- Video consultations and medical record management
- Hospital integration and compliance reporting

### **AI & Hardware**
- Computer vision wound classification
- 3D LiDAR wound measurement and mapping
- Automated treatment recommendations
- Real-time vital signs monitoring

## 🛠️ Development

```bash
# Flutter app
cd apps/flutter_app && flutter run -d chrome

# Backend services
cd services/api && npm run dev
cd services/ai-service && python main.py

# All services
docker-compose up -d
```

## 🎓 Academic Project

**University of Texas at San Antonio - Senior Design Capstone**
- **Timeline**: Fall 2024 - Spring 2025 (2 semesters)
- **Team**: 4-5 Electrical and Computer Engineering students
- **Objective**: Design and build AI-powered medical device
- **Deliverables**: Working prototype, documentation, clinical testing

## 📄 License

Licensed under the MIT License - see LICENSE file for details.

---

**Ready for clinical testing** 🏥 | **AI-powered diagnostics** 🤖 | **Cross-platform deployment** 📱💻🌐