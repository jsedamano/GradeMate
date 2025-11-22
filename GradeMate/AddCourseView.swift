//
//  AddCourseView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester

    @State private var name: String = ""
    @State private var shortCode: String = ""

    @State private var showValidationError = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Course name") {
                    TextField("Ex: Calculus I", text: $name)
                }

                Section("Short code") {
                    TextField("Ex: MATH 1225", text: $shortCode)
                }
            }
            .navigationTitle("New Course")
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
            .alert("Cannot create course", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    private func saveCourse() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCode = shortCode.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedName.isEmpty else {
            validationMessage = "Please enter a course name."
            showValidationError = true
            return
        }

        if viewModel.courseNameExists(trimmedName, in: semester) {
            validationMessage = "There is already a course called \"\(trimmedName)\" in this semester."
            showValidationError = true
            return
        }

        viewModel.addCourse(
            to: semester,
            name: trimmedName,
            shortCode: trimmedCode.isEmpty ? trimmedName : trimmedCode
        )

        dismiss()
    }
}

#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    vm.semesters = [sem]
    return AddCourseView(viewModel: vm, semester: sem)
}
