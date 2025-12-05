//
//  CourseListMutationTest.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/5/25.
//

import Testing
import Foundation
@testable import GradeMate

// ----------------------------------------------------------------
// Test for the mutation of a course list inside a semester.
// ----------------------------------------------------------------
@MainActor
struct CourseListMutationTests {

    // Helper: create a view model with a single semester that has three courses.
    private func makeViewModel() -> (SemesterViewModel, Semester, [Course]) {
        let c1 = Course(name: "Calculus I", shortCode: "MATH 1225")
        let c2 = Course(name: "Physics",    shortCode: "PHYS 2305")
        let c3 = Course(name: "Intro to CS", shortCode: "CS 1114")

        let semester = Semester(name: "Fall 2025", courses: [c1, c2, c3])

        let vm = SemesterViewModel()
        vm.semesters = [semester]

        return (vm, semester, [c1, c2, c3])
    }

    // ------------------------------------------------------------
    // Case: removeCourses(at:in:) removes the correct course and
    // leaves the others in order.
    // ------------------------------------------------------------
    @Test
    func removeCourses_removesCorrectCourse() {
        // Given
        let (vm, semester, courses) = makeViewModel()
        #expect(vm.semesters.first?.courses.count == 3)

        // When: remove the second course ("Physics")
        vm.removeCourses(at: IndexSet(integer: 1), in: semester)

        // Then
        let remaining = vm.semesters.first?.courses ?? []
        #expect(remaining.count == 2)

        // Should be [c1, c3]
        #expect(remaining[0].id == courses[0].id,
                "First course should still be Calculus I")
        #expect(remaining[1].id == courses[2].id,
                "Second course should now be Intro to CS")
    }

    // ------------------------------------------------------------
    // Case: moveCourses(from:to:in:) changes the order and moves
    // the selected course away from its original index.
    // ------------------------------------------------------------
    @Test
    func moveCourses_reordersCoursesCorrectly() {
        // Given
        let (vm, semester, _) = makeViewModel()

        // Original order snapshot
        let originalCourses = vm.semesters.first?.courses ?? []
        #expect(originalCourses.count == 3)

        let movedCourseId = originalCourses[0].id   // the one at index 0

        // When: move first course (index 0) to position 2
        vm.moveCourses(from: IndexSet(integer: 0), to: 2, in: semester)

        // Then
        let reordered = vm.semesters.first?.courses ?? []
        #expect(reordered.count == originalCourses.count)

        // Same set of courses (no loss / no duplicates)
        let originalIds = Set(originalCourses.map(\.id))
        let newIds = Set(reordered.map(\.id))
        #expect(originalIds == newIds, "The set of courses should be preserved after move")

        // Order must have changed
        #expect(reordered.map(\.id) != originalCourses.map(\.id),
                "Order should change after moving a course")

        // The moved course should no longer be at index 0
        #expect(reordered[0].id != movedCourseId,
                "Moved course should not stay at index 0")

        // And it should exist somewhere else in the array
        let newIndex = reordered.firstIndex { $0.id == movedCourseId }
        #expect(newIndex != nil && newIndex! != 0,
                "Moved course should appear at a different index after move")
    }
}
