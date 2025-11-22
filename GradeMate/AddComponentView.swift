//
//  AddComponentView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct AddComponentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester
    let course: Course

    @State private var name: String = ""
    @State private var weightText: String = ""
    @State private var gradeText: String = ""

    @State private var showValidationError = false
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            Form {
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
            .alert("Cannot save component", isPresented: $showValidationError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }

    private func saveComponent() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            validationMessage = "Please enter a name."
            showValidationError = true
            return
        }

        guard let weight = Double(weightText), weight > 0 else {
            validationMessage = "Please enter a valid weight greater than 0."
            showValidationError = true
            return
        }

        // Actual total weight
        let currentTotal = viewModel.totalWeight(for: course, in: semester)
        let newTotal = currentTotal + weight

        if newTotal > 100.0001 {
            validationMessage = "Total weight would be \(newTotal)%. It cannot exceed 100%.\nCurrent total: \(currentTotal)%."
            showValidationError = true
            return
        }

        let grade: Double?
        if !gradeText.isEmpty, let g = Double(gradeText) {
            grade = g
        } else {
            grade = nil
        }

        viewModel.addComponent(
            to: course,
            in: semester,
            name: trimmedName,
            weight: weight,
            grade: grade
        )

        dismiss()
    }
}

#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    let course = Course(name: "Calculus I", shortCode: "MATH 1225")
    vm.semesters = [Semester(name: sem.name, courses: [course])]
    return AddComponentView(viewModel: vm, semester: sem, course: course)
}
