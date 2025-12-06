//
//  AddComponentView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// View for adding a new graded component to a course within a
// semester.
// ----------------------------------------------------------------
struct AddComponentView: View {
    // Used to dismiss this view after saving or cancelling
    @Environment(\.dismiss) private var dismiss
    // Data context: where and how the new component will be added
    @ObservedObject var viewModel: SemesterViewModel
    
    let semester: Semester
    let course: Course

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
            .navigationTitle("New Component")
            // Cancel and Save actions
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveComponent()
                    }
                }
            }
            // Validation error alert
            .alert("Cannot save component", isPresented: $showValidationError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }

    // Validates inputs, ensures total weight stays at or below 100%, then adds the component
    private func saveComponent() {
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

        // Actual total weight
        let currentTotal = viewModel.totalWeight(for: course, in: semester)
        let newTotal = currentTotal + weight

        // Prevent total weight from exceeding 100% (allow a tiny FP tolerance)
        if newTotal > 100.0001 {
            validationMessage = "Total weight would be \(newTotal)%. It cannot exceed 100%.\nCurrent total: \(currentTotal)%."
            showValidationError = true
            return
        }

        // Parse optional grade, if provided it must be between 0 and 100
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

        // Persist the component via the view model
        viewModel.addComponent(
            to: course,
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
    vm.semesters = [Semester(name: sem.name, courses: [course])]
    return AddComponentView(viewModel: vm, semester: sem, course: course)
}
