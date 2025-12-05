//
//  AddCourseView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// View for adding a new course to a semester.
// ----------------------------------------------------------------
struct AddCourseView: View {
    // Used to dismiss this view after saving or cancelling
    @Environment(\.dismiss) private var dismiss
    // Data context: where and how the new course will be added
    @ObservedObject var viewModel: SemesterViewModel
    
    let semester: Semester

    // User-entered form values
    @State private var name: String = ""
    @State private var shortCode: String = ""

    // Validation UI state
    @State private var showValidationError = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                // Course name and short code fields
                Section("Course name") {
                    TextField("Ex: Calculus I", text: $name)
                }
                Section("Short code") {
                    TextField("Ex: MATH 1225", text: $shortCode)
                }
            }
            .navigationTitle("New Course")
            // Cancel and Save actions
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCourse()
                    }
                }
            }
            // Validation error alert
            .alert("Cannot create course", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    // Validates inputs, prevents duplicates, then adds the course
    private func saveCourse() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCode = shortCode.trimmingCharacters(in: .whitespacesAndNewlines)

        // Require a non-empty name
        guard !trimmedName.isEmpty else {
            validationMessage = "Please enter a course name."
            showValidationError = true
            return
        }

        // Prevent duplicate course names within this semester
        if viewModel.courseNameExists(trimmedName, in: semester) {
            validationMessage = "There is already a course called \"\(trimmedName)\" in this semester."
            showValidationError = true
            return
        }

        // Persist the course via the view model
        viewModel.addCourse(
            to: semester,
            name: trimmedName,
            shortCode: trimmedCode.isEmpty ? trimmedName : trimmedCode
        )

        // Close the sheet
        dismiss()
    }
}

// Preview with sample data
#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    vm.semesters = [sem]
    return AddCourseView(viewModel: vm, semester: sem)
}
