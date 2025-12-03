//
//  TotalWeightTests.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/2/25.
//

import Testing
@testable import GradeMate

// ----------------------------------------------------------------
// Tests for the total weight calculation.
// ----------------------------------------------------------------
@MainActor
struct TotalWeightTests {

    // Helper: make a semester with one course and some components
    private func makeViewModelWithCourse() -> (SemesterViewModel, Semester, Course, [GradeComponent]) {
        let components = [
            GradeComponent(name: "Exam 1", weight: 20, grade: 80),
            GradeComponent(name: "Exam 2", weight: 30, grade: 90),
            GradeComponent(name: "Homework", weight: 10, grade: nil)
        ]
        let course = Course(
            name: "Calculus",
            shortCode: "MATH101",
            components: components
        )

        let semester = Semester(name: "Fall 2025", courses: [course])

        let vm = SemesterViewModel()
        vm.semesters = [semester]

        return (vm, semester, course, components)
    }

    // ------------------------------------------------------------
    // Case: Total weight sums all components of the course.
    // ------------------------------------------------------------
    @Test
    func totalWeight_sumsAllComponents() {
        // Given
        let (vm, semester, course, _) = makeViewModelWithCourse()

        // When
        let total = vm.totalWeight(for: course, in: semester)

        // Then: 20 + 30 + 10 = 60
        #expect(abs(total - 60.0) < 0.0001,
                "Expected total weight to be 60, got \(total)")
    }

    // ------------------------------------------------------------
    // Case: When excluding one component, its weight is not counted.
    // ------------------------------------------------------------
    @Test
    func totalWeight_excludingComponent_ignoresThatComponent() {
        // Given
        let (vm, semester, course, components) = makeViewModelWithCourse()
        let excluded = components[1]    // "Exam 2", weight 30

        // When
        let total = vm.totalWeight(for: course, in: semester, excluding: excluded)

        // Then: 20 + 10 = 30
        #expect(abs(total - 30.0) < 0.0001,
                "Expected total weight to be 30 when excluding Exam 2, got \(total)")
    }

    // ------------------------------------------------------------
    // Case: If semester or course is not found in the view model,
    // totalWeight returns 0.
    // ------------------------------------------------------------
    @Test
    func totalWeight_missingSemesterOrCourse_returnsZero() {
        // Given: empty view model
        let vm = SemesterViewModel()

        let components = [
            GradeComponent(name: "Exam 1", weight: 50, grade: nil)
        ]
        let course = Course(
            name: "Physics",
            shortCode: "PHYS201",
            components: components
        )
        let semester = Semester(name: "Spring 2026", courses: [course])

        // When
        let total = vm.totalWeight(for: course, in: semester)

        // Then
        #expect(total == 0,
                "If the semester/course is not managed by the view model, total weight should be 0")
    }
}
