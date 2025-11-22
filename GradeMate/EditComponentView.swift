//
//  EditComponentView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct EditComponentView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester
    let course: Course
    let component: GradeComponent

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
            .navigationTitle("Edit Component")
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
            .onAppear {
                name = component.name
                weightText = String(component.weight)
                if let g = component.grade {
                    gradeText = String(g)
                }
            }
            .alert("Cannot save changes", isPresented: $showValidationError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(validationMessage)
            }
        }
    }

    private func saveChanges() {
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

        // Total weight without this component
        let currentTotalExcluding = viewModel.totalWeight(
            for: course,
            in: semester,
            excluding: component
        )
        let newTotal = currentTotalExcluding + weight

        if newTotal > 100.0001 {
            validationMessage = "Total weight would be \(newTotal)%. It cannot exceed 100%.\nCurrent total (excluding this component): \(currentTotalExcluding)%."
            showValidationError = true
            return
        }

        let grade: Double?
        if !gradeText.isEmpty, let g = Double(gradeText) {
            grade = g
        } else {
            grade = nil
        }

        viewModel.updateComponent(
            component,
            in: course,
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
    let comp = GradeComponent(name: "Exam 1", weight: 25, grade: 100)
    vm.semesters = [Semester(name: sem.name, courses: [Course(name: course.name, shortCode: course.shortCode, components: [comp])])]
    return EditComponentView(viewModel: vm, semester: sem, course: course, component: comp)
}
