//
//  RenameSemesterView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct RenameSemesterView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester

    @State private var name: String = ""
    @State private var showValidationError = false
    @State private var validationMessage = ""

    init(viewModel: SemesterViewModel, semester: Semester) {
        self.viewModel = viewModel
        self.semester = semester
        _name = State(initialValue: semester.name)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Semester name") {
                    TextField("Ex: Fall 2025", text: $name)
                }
            }
            .navigationTitle("Rename Semester")
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
            .alert("Cannot rename semester", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    private func save() {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            validationMessage = "Please enter a semester name."
            showValidationError = true
            return
        }

        // If a semester with the same name exists, error
        if viewModel.semesterNameExists(trimmed),
           semester.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != trimmed.lowercased() {
            validationMessage = "There is already a semester called \"\(trimmed)\"."
            showValidationError = true
            return
        }

        _ = viewModel.renameSemester(semester, to: trimmed)
        dismiss()
    }
}

#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    vm.semesters = [sem]
    return RenameSemesterView(viewModel: vm, semester: sem)
}
