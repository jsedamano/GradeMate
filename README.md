# GradeMate

A modern, intuitive iOS application built with SwiftUI that helps students track and manage their course grades across multiple semesters. GradeMate simplifies grade tracking by allowing users to manage courses, grade components, and calculate weighted GPAs with ease.

## 📋 Project Overview

GradeMate is designed to help students stay organized and informed about their academic progress. The app provides a comprehensive solution for:

- **Semester Management**: Create and manage multiple semesters.
- **Course Tracking**: Add courses to semesters and monitor their details.
- **Grade Components**: Track individual grade components (quizzes, exams, projects, etc.) with customizable weights.
- **Weighted Grade Calculation**: Automatically calculates current and final grades based on component weights.
- **Adaptive UI**: Beautiful, responsive interface that adapts to system appearance settings.

Whether you're juggling multiple courses or tracking your GPA across several semesters, GradeMate keeps your academic information organized and accessible.

## 📹 Video Demonstration

[![GradeMate Demo Video](https://img.shields.io/badge/Watch-Demo%20Video-blue?style=for-the-badge)](VIDEO_LINK_HERE)

## 🎯 Key Features

- ✅ Multi-semester support
- ✅ Flexible grade component system
- ✅ Automatic weighted grade calculation
- ✅ Real-time grade updates
- ✅ Intuitive, clean UI
- ✅ Light and dark mode support
- ✅ Comprehensive unit tests

## 🛠️ Technologies Used

- **Swift**: Programming language
- **SwiftUI**: Modern UI framework for building native iOS interfaces
- **MVVM Architecture**: Model-View-ViewModel pattern for clean code organization
- **Xcode**: IDE for development and testing
- **iOS SDK**: Native iOS development framework

## 📁 Project Structure

```
GradeMate/
├── GradeMate/                          # Main application source
│   ├── GradeMateApp.swift              # App entry point
│   ├── ContentView.swift               # Root view with semester list and welcome screen
│   ├── Assets.xcassets/                # Images, colors, and app icons
│   │   ├── AccentColor.colorset/
│   │   └── AppIcon.appiconset/
│   ├── Models/                         # Data models and view models
│   │   ├── ColorAdaptive.swift         # Color utilities for light/dark mode
│   │   ├── Course.swift                # Course model
│   │   ├── GradeComponent.swift        # Grade component model (quiz, exam, etc.)
│   │   ├── Semester.swift              # Semester model
│   │   └── SemesterViewModel.swift     # View model managing semester logic
│   └── Views/                          # UI views organized by feature
│       ├── ComponentViews/
│       │   ├── AddComponentView.swift  # Add new grade component
│       │   └── EditComponentView.swift # Edit existing grade component
│       ├── CourseViews/
│       │   ├── AddCourseView.swift     # Add new course
│       │   └── CourseDetailView.swift  # View course details and grades
│       └── SemesterViews/
│           ├── AddSemesterView.swift   # Create new semester
│           ├── RenameSemesterView.swift # Rename existing semester
│           ├── SemesterDetailView.swift # View semester details and courses
│           └── SemesterListView.swift  # List all semesters
├── GradeMateTests/                     # Unit tests
│   ├── GradeMateTests.swift
│   ├── CourseCurrentGradeTests.swift
│   ├── CourseListMutationTest.swift
│   ├── SemesterNameExistsTests.swift
│   └── TotalWeightTests.swift
├── GradeMateUITests/                   # UI tests
│   ├── GradeMateUITests.swift
│   └── GradeMateUITestsLaunchTests.swift
└── GradeMate.xcodeproj/                # Xcode project configuration
```

## 🚀 Installation & Setup

### Prerequisites

- **macOS** 26.0 or later
- **Xcode** 26.0 or later
- **iOS** 26 or later (for deployment target)

### How to Run the Program

1. **Clone the Repository**
   ```bash
   git clone https://github.com/jsedamano/GradeMate.git
   cd GradeMate
   ```

2. **Open in Xcode**
   ```bash
   open GradeMate.xcodeproj
   ```

3. **Select a Simulator or Device**
   - In Xcode, select your target device from the top toolbar (e.g., "iPhone 17 Pro")

4. **Build and Run**
   - Press `Cmd + R` or click the **Run** button (▶) in Xcode
   - The app will build, compile, and launch in your selected simulator/device

5. **Explore the App**
   - Create your first semester
   - Add courses to the semester
   - Add grade components to each course
   - Watch as GradeMate calculates your weighted grades in real-time

### How to Reproduce Results

**Testing Grade Calculations:**
1. Create a semester
2. Add a course with a target grade in mind
3. Add grade components with weights totaling 100%
4. Input component grades—GradeMate will automatically calculate the weighted current and final grades
5. Verify calculations match your expectations

**Running Unit Tests:**
```bash
Cmd + U
```
This runs all unit tests in `GradeMateTests/` and validates:
- Course grade calculation logic
- Semester name uniqueness
- Grade component weight validation
- Course list mutations

## 🔮 Future Implementations

- 🔔 **Notifications**: Grade alerts when components are due or when grades drop below a target
- 📊 **Analytics Dashboard**: Visual charts showing grade trends across semesters and courses
- 🎓 **GPA Calculator**: Calculate cumulative GPA across multiple semesters
- ☁️ **Cloud Sync**: iCloud synchronization for seamless data sync across devices
- 📤 **Export Functionality**: Export grade reports as PDF or CSV
- 🌍 **Multi-language Support**: Localization for different languages
- 🎨 **Customizable Themes**: Additional color themes and UI customization options
- 👥 **Collaborative Features**: Share semester/course information with classmates or advisors
- 🔐 **Enhanced Security**: Biometric authentication (Face ID/Touch ID)

## 👤 Author Information

**Joaquin Sedamano**  
- CS @ Virginia Tech
- Email: jsedamano@vt.edu
- LinkedIn: [linkedin.com/in/joaquin-sedamano](https://www.linkedin.com/in/joaquin-sedamano)
- GitHub: [github.com/jsedamano](https://github.com/jsedamano)

## 📄 License

This project is open source and available under the MIT License.

---

**Last Updated**: December 5, 2025
