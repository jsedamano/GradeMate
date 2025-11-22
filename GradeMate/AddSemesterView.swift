//
//  AddSemester.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct AddSemesterView: View {
    @Environment(\.dismiss) var dismiss
    @State private var semesterName = ""
    @ObservedObject var viewModel: SemesterViewModel

    @State private var showValidationError = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Semester name") {
                    TextField("Ex: Fall 2025", text: $semesterName)
                }
            }
            .navigationTitle("New Semester")
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
            .alert("Cannot create semester", isPresented: $showValidationError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(validationMessage)
            }
        }
    }

    private func saveSemester() {
        let trimmed = semesterName.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            validationMessage = "Please enter a semester name."
            showValidationError = true
            return
        }

        if viewModel.semesterNameExists(trimmed) {
            validationMessage = "There is already a semester called \"\(trimmed)\"."
            showValidationError = true
            return
        }

        viewModel.addSemester(name: trimmed)
        dismiss()
    }
}

#Preview {
    AddSemesterView(viewModel: SemesterViewModel())
}
