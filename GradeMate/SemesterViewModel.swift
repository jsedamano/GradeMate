//
//  SemesterViewModel.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI
import Combine

class SemesterViewModel: ObservableObject {
    @Published var semesters: [Semester] = []
    @Published var activeSemester: Semester? = nil

    // MARK: - Semesters

    func addSemester(name: String) {
        let new = Semester(name: name)
        semesters.append(new)

        if activeSemester == nil {
            activeSemester = new
        }
    }
    
    func removeSemester(_ semester: Semester) {
        guard let index = semesters.firstIndex(where: { $0.id == semester.id }) else {
            return
        }

        semesters.remove(at: index)

        // If the eliminated semester was the active one, choose another one
        if let active = activeSemester, active.id == semester.id {
            activeSemester = semesters.first
        }
    }
    
    @discardableResult
    func renameSemester(_ semester: Semester, to newName: String) -> Bool {
        let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return false }

        // Avoid duplicates
        if semesterNameExists(trimmed), semester.name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() != trimmed.lowercased() {
            return false
        }

        guard let index = semesters.firstIndex(where: { $0.id == semester.id }) else {
            return false
        }

        semesters[index].name = trimmed

        if let active = activeSemester, active.id == semester.id {
            activeSemester = semesters[index]
        }

        return true
    }

    // MARK: - Courses

    func addCourse(to semester: Semester, name: String, shortCode: String) {
        guard let index = semesters.firstIndex(where: { $0.id == semester.id }) else {
            return
        }

        let newCourse = Course(name: name, shortCode: shortCode)
        semesters[index].courses.append(newCourse)
    }
    
    func removeCourses(at offsets: IndexSet, in semester: Semester) {
        guard let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }) else {
            return
        }

        semesters[semesterIndex].courses.remove(atOffsets: offsets)
    }

    func moveCourses(from source: IndexSet, to destination: Int, in semester: Semester) {
        guard let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }) else {
            return
        }

        semesters[semesterIndex].courses.move(fromOffsets: source, toOffset: destination)
    }

    // MARK: - Components

    func totalWeight(
        for course: Course,
        in semester: Semester,
        excluding component: GradeComponent? = nil
    ) -> Double {
        guard
            let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }),
            let courseIndex = semesters[semesterIndex].courses.firstIndex(where: { $0.id == course.id })
        else {
            return 0
        }

        let components = semesters[semesterIndex].courses[courseIndex].components

        return components
            .filter { comp in
                if let excluding = component {
                    return comp.id != excluding.id
                } else {
                    return true
                }
            }
            .reduce(0) { $0 + $1.weight }
    }

    func addComponent(
        to course: Course,
        in semester: Semester,
        name: String,
        weight: Double,
        grade: Double? = nil
    ) {
        guard
            let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }),
            let courseIndex = semesters[semesterIndex].courses.firstIndex(where: { $0.id == course.id })
        else {
            return
        }

        let newComponent = GradeComponent(name: name, weight: weight, grade: grade)
        semesters[semesterIndex].courses[courseIndex].components.append(newComponent)
    }

    func updateComponent(
        _ component: GradeComponent,
        in course: Course,
        in semester: Semester,
        name: String,
        weight: Double,
        grade: Double?
    ) {
        guard
            let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }),
            let courseIndex = semesters[semesterIndex].courses.firstIndex(where: { $0.id == course.id }),
            let componentIndex = semesters[semesterIndex].courses[courseIndex]
                .components
                .firstIndex(where: { $0.id == component.id })
        else {
            return
        }

        semesters[semesterIndex].courses[courseIndex].components[componentIndex].name = name
        semesters[semesterIndex].courses[courseIndex].components[componentIndex].weight = weight
        semesters[semesterIndex].courses[courseIndex].components[componentIndex].grade = grade
    }

    func removeComponents(
        at offsets: IndexSet,
        from course: Course,
        in semester: Semester
    ) {
        guard
            let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }),
            let courseIndex = semesters[semesterIndex].courses.firstIndex(where: { $0.id == course.id })
        else {
            return
        }

        semesters[semesterIndex].courses[courseIndex].components.remove(atOffsets: offsets)
    }
    
    // MARK: - Validation Helpers

    func semesterNameExists(_ name: String) -> Bool {
        let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return semesters.contains { semester in
            semester.name.trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() == normalized
        }
    }

    func courseNameExists(_ name: String, in semester: Semester) -> Bool {
        let normalized = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

        guard let semesterIndex = semesters.firstIndex(where: { $0.id == semester.id }) else {
            return false
        }

        return semesters[semesterIndex].courses.contains { course in
            course.name.trimmingCharacters(in: .whitespacesAndNewlines)
                .lowercased() == normalized
        }
    }
}
