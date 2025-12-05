//
//  RenameSemesterView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// View for renaming an existing semester.
// ----------------------------------------------------------------
struct RenameSemesterView: View {
    // Used to dismiss this view after saving or cancelling
    @Environment(\.dismiss) private var dismiss
    // Data context
    @ObservedObject var viewModel: SemesterViewModel
    
    // Target semester to rename
    let semester: Semester

    // User-entered form value
    @State private var name: String = ""
    @State private var showValidationError = false
    @State private var validationMessage = ""

    // Initialize with existing semester name pre-filled
    init(viewModel: SemesterViewModel, semester: Semester) {
        self.viewModel = viewModel
        self.semester = semester
        _name = State(initialValue: semester.name)
    }

    var body: some View {
        NavigationStack {
            Form {
                // Semester name field
                Section("Semester name") {
                    TextField("Ex: Fall 2025", text: $name)
                }
            }
            .navigationTitle("Rename Semester")
            // Cancel and Save actions
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                }
            }
            // Validation error alert
            .alert("Cannot rename semester", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    // Validates input, prevents duplicate names, then renames the semester
    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        // Require a non-empty name
        guard !trimmed.isEmpty else {
            validationMessage = "Please enter a semester name."
            showValidationError = true
            return
        }

        // Prevent renaming to a name already in use (case/whitespace-insensitive)
        if viewModel.semesterNameExists(trimmed),
           semester.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != trimmed.lowercased() {
            validationMessage = "There is already a semester called \"\(trimmed)\"."
            showValidationError = true
            return
        }

        // Persist the change via the view model
        _ = viewModel.renameSemester(semester, to: trimmed)
        // Close the sheet
        dismiss()
    }
}

// Preview with sample data
#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    vm.semesters = [sem]
    return RenameSemesterView(viewModel: vm, semester: sem)
}
