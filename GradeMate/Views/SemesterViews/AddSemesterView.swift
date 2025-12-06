//
//  AddSemester.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// View for adding a new semester.
// ----------------------------------------------------------------
struct AddSemesterView: View {
    // Used to dismiss this view after saving or cancelling
    @Environment(\.dismiss) var dismiss
    // User-entered form value
    @State private var semesterName = ""
    // Data context: manages semesters
    @ObservedObject var viewModel: SemesterViewModel

    // Validation UI state
    @State private var showValidationError = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                // Semester name field
                Section("Semester name") {
                    TextField("Ex: Fall 2025", text: $semesterName)
                }
            }
            .navigationTitle("New Semester")
            // Cancel and Save actions
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveSemester()
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            // Validation error alert
            .alert("Cannot create semester", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    // Validates input, prevents duplicates, then adds the semester
    private func saveSemester() {
        let trimmed = semesterName.trimmingCharacters(in: .whitespacesAndNewlines)

        // Require a non-empty name
        guard !trimmed.isEmpty else {
            validationMessage = "Please enter a semester name."
            showValidationError = true
            return
        }

        // Prevent duplicate semester names
        if viewModel.semesterNameExists(trimmed) {
            validationMessage = "There is already a semester called \"\(trimmed)\"."
            showValidationError = true
            return
        }

        // Persist the semester via the view model
        viewModel.addSemester(name: trimmed)
        // Close the sheet
        dismiss()
    }
}

// Preview with sample data
#Preview {
    AddSemesterView(viewModel: SemesterViewModel())
}
