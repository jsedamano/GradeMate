//
//  RenameCourseView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/06/25.
//

import SwiftUI

// ----------------------------------------------------------------
// View for editing an existing course (name + short code).
// ----------------------------------------------------------------
struct RenameCourseView: View {
    // Used to dismiss this view after saving or cancelling
    @Environment(\.dismiss) private var dismiss
    // Data context
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester
    let course: Course

    @State private var name: String
    @State private var shortCode: String

    @State private var showValidationError = false
    @State private var validationMessage = ""

    // Initialize with existing course values pre-filled
    init(viewModel: SemesterViewModel, semester: Semester, course: Course) {
        self.viewModel = viewModel
        self.semester = semester
        self.course = course
        _name = State(initialValue: course.name)
        _shortCode = State(initialValue: course.shortCode)
    }

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
            .navigationTitle("Edit Course")
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
            .alert("Cannot update course", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    // Validates inputs, prevents duplicates, then updates the course
    private func save() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCode = shortCode.trimmingCharacters(in: .whitespacesAndNewlines)

        // Require a non-empty name
        guard !trimmedName.isEmpty else {
            validationMessage = "Please enter a course name."
            showValidationError = true
            return
        }

        // Prevent duplicate course names within this semester
        if viewModel.courseNameExists(trimmedName, in: semester),
           course.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != trimmedName.lowercased() {
            validationMessage = "There is already a course called \"\(trimmedName)\" in this semester."
            showValidationError = true
            return
        }

        // Persist changes via the view model
        viewModel.updateCourse(
            course,
            in: semester,
            newName: trimmedName,
            newShortCode: trimmedCode
        )

        // Close the sheet
        dismiss()
    }
}

// Preview with sample data
#Preview {
    let vm = SemesterViewModel()
    let course = Course(name: "Calculus I", shortCode: "MATH 1225")
    let sem = Semester(name: "Fall 2025", courses: [course])
    vm.semesters = [sem]
    return RenameCourseView(viewModel: vm, semester: sem, course: course)
}
