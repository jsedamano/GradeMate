//
//  EditComponentView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// View for editing an existing grade component.
// ----------------------------------------------------------------
struct EditComponentView: View {
    // Used to dismiss this view after saving or cancelling
    @Environment(\.dismiss) private var dismiss
    // Data context
    @ObservedObject var viewModel: SemesterViewModel
    
    // Target semester/course/component
    let semester: Semester
    let course: Course
    let component: GradeComponent

    // User-entered form values
    @State private var name: String = ""
    @State private var weightText: String = ""
    @State private var gradeText: String = ""

    // Validation UI state
    @State private var showValidationError = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                // Name, weight, and optional grade fields
                Section("Component name") {
                    TextField("Ex: Exam 1", text: $name)
                }

                Section("Weight (%)") {
                    TextField("Ex: 20", text: $weightText)
                        .keyboardType(.decimalPad)
                }

                Section("Grade (%) (optional)") {
                    TextField("Ex: 95", text: $gradeText)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Edit Component")
            // Cancel and Save actions
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveChanges()
                    }
                }
            }
            // Pre-fill fields from the existing component
            .onAppear {
                name = component.name
                weightText = String(component.weight)
                if let g = component.grade {
                    gradeText = String(g)
                }
            }
            // Validation error alert
            .alert("Cannot save changes", isPresented: $showValidationError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }

    // Validates inputs, ensures total weight stays at or below 100% (excluding this component), then updates the component
    private func saveChanges() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        // Require a non-empty name
        guard !trimmedName.isEmpty else {
            validationMessage = "Please enter a name."
            showValidationError = true
            return
        }

        // Parse weight and require it to be > 0
        guard let weight = Double(weightText), weight > 0 else {
            validationMessage = "Please enter a valid weight greater than 0."
            showValidationError = true
            return
        }

        // Total weight without this component
        let currentTotalExcluding = viewModel.totalWeight(
            for: course,
            in: semester,
            excluding: component
        )
        let newTotal = currentTotalExcluding + weight

        // Prevent total weight from exceeding 100% (allow a tiny FP tolerance)
        if newTotal > 100.0001 {
            validationMessage = "Total weight would be \(newTotal)%. It cannot exceed 100%.\nCurrent total (excluding this component): \(currentTotalExcluding)%."
            showValidationError = true
            return
        }

        // Parse optional grade; if provided it must be between 0 and 100
        let grade: Double?
        if !gradeText.isEmpty, let g = Double(gradeText), (0...100).contains(g) {
            grade = g
        } else if !gradeText.isEmpty {
            validationMessage = "Grade must be between 0 and 100."
            showValidationError = true
            return
        } else {
            grade = nil
        }

        // Persist changes via the view model
        viewModel.updateComponent(
            component,
            in: course,
            in: semester,
            name: trimmedName,
            weight: weight,
            grade: grade
        )

        // Close the sheet
        dismiss()
    }
}

// Preview with sample data
#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    let course = Course(name: "Calculus I", shortCode: "MATH 1225")
    let comp = GradeComponent(name: "Exam 1", weight: 25, grade: 100)
    vm.semesters = [Semester(name: sem.name, courses: [Course(name: course.name, shortCode: course.shortCode, components: [comp])])]
    return EditComponentView(viewModel: vm, semester: sem, course: course, component: comp)
}
