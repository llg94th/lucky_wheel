# 🎯 Lucky Wheel - Vòng Quay May Mắn

[![Flutter](https://img.shields.io/badge/Flutter-3.24.0-blue.svg)](https://flutter.dev/)
[![Dart](https://img.shields.io/badge/Dart-3.5.3-blue.svg)](https://dart.dev/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## 🌟 Demo

**🎮 Live Demo:** [https://llg94th.github.io/lucky_wheel/](https://llg94th.github.io/lucky_wheel/)

## 📱 Screenshots

<div align="center">
  <img src="docs/screenshot1.png" alt="Lucky Wheel Screenshot" width="300"/>
  <img src="docs/screenshot2.png" alt="Lucky Wheel Screenshot" width="300"/>
</div>

## 🎯 Ý Tưởng Dự Án

**Lucky Wheel** là một ứng dụng vòng quay may mắn được xây dựng bằng Flutter với các tính năng:

### ✨ Tính Năng Chính
- **🎯 Vòng quay mượt mà** với animation chân thực
- **🎲 4 kịch bản quay khác nhau:**
  - 🎲 **Ngẫu nhiên** (60% chính xác, 20% mạnh hơn, 20% nhẹ hơn)
  - 🎯 **Chính xác** - Quay vào giữa ô
  - 💫 **Mạnh hơn** - Quay sang ô tiếp theo
  - 🎪 **Nhẹ hơn** - Ở lại ô trước đó
- **🎁 7 giải thưởng hấp dẫn:** iPhone 15 Pro, MacBook Pro, AirPods Pro, iPad Pro, Apple Watch, Voucher 500k, Voucher 1M
- **🎨 UI/UX hiện đại** với hiệu ứng đẹp mắt
- **📱 Responsive design** hỗ trợ mọi kích thước màn hình

### 🏗️ Kiến Trúc Clean Architecture
```
lib/
├── domain/           # Business Logic Layer
│   ├── entities/     # Domain Models
│   └── repositories/ # Abstract Interfaces
├── data/            # Data Layer
│   ├── repositories/ # Repository Implementations
│   └── datasources/  # Data Sources
└── presentation/    # UI Layer
    ├── controllers/  # State Management
    ├── widgets/      # UI Components
    └── painters/     # Custom Painters
```

## 🛠️ Công Nghệ Sử Dụng

### 📋 Yêu Cầu Hệ Thống
- **Flutter:** 3.24.0
- **Dart:** 3.5.3
- **SDK:** ^3.5.3

### 📦 Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

## 🚀 Cài Đặt & Chạy

### 1. Clone Repository
```bash
git clone https://github.com/llg94th/lucky_wheel.git
cd lucky_wheel
```

### 2. Cài Đặt Dependencies
```bash
flutter pub get
```

### 3. Chạy Ứng Dụng
```bash
# Chạy trên web
flutter run -d chrome

# Chạy trên mobile
flutter run
```

## 🌐 Build Web cho GitHub Pages

### Sử dụng Script (Recommended)
```bash
# Linux/Mac
./build_web.sh

# Windows
build_web.bat
```

### Build Thủ Công
```bash
flutter build web --base-href "/lucky_wheel/" --release --web-renderer canvaskit
```

## 🎮 Cách Sử Dụng

1. **Chọn kịch bản quay** từ dropdown menu
2. **Nhấn "🎯 Quay ngay!"** để bắt đầu quay
3. **Xem kết quả** trong dialog hiển thị
4. **Nhấn "Quay lại"** để reset vòng quay

## 🎨 Tính Năng Kỹ Thuật

### 🎯 Animation System
- **Rotation Animation:** Sử dụng `AnimationController` với `Curves.easeOutCubic`
- **Bounce Effect:** Hiệu ứng nảy lại sau khi quay
- **Custom Painter:** Vẽ vòng quay với `CustomPaint`

### 🎲 Spin Scenarios
```dart
enum SpinScenario {
  random,     // Ngẫu nhiên
  center,     // Chính xác
  overshoot,  // Mạnh hơn
  undershoot, // Nhẹ hơn
}
```

### 🏗️ State Management
- **ChangeNotifier:** Quản lý state của vòng quay
- **ValueNotifier:** Quản lý kịch bản được chọn
- **ListenableBuilder:** Rebuild UI khi state thay đổi

## 📁 Cấu Trúc Project

```
lucky_wheel/
├── lib/
│   ├── domain/
│   │   ├── entities/
│   │   │   └── prize.dart
│   │   └── repositories/
│   │       └── prize_repository.dart
│   ├── data/
│   │   └── repositories/
│   │       └── prize_repository_impl.dart
│   ├── presentation/
│   │   ├── controllers/
│   │   │   └── lucky_wheel_controller.dart
│   │   ├── widgets/
│   │   │   └── lucky_wheel.dart
│   │   └── painters/
│   │       └── wheel_painter.dart
│   └── main.dart
├── docs/              # GitHub Pages build
├── build_web.sh       # Build script
└── README.md
```

## 🤝 Đóng Góp

1. Fork project
2. Tạo feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

## 📞 Liên Hệ

- **GitHub:** [@llg94th](https://github.com/llg94th)
- **Demo:** [https://llg94th.github.io/lucky_wheel/](https://llg94th.github.io/lucky_wheel/)

---

⭐ **Star this repository if you find it helpful!**
