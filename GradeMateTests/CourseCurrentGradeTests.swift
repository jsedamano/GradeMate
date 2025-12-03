//
//  CourseCurrentGradeTests.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/2/25.
//

import Testing
@testable import GradeMate

// ----------------------------------------------------------------
// Tests for the current grade calculation.
// ----------------------------------------------------------------
@MainActor
struct CourseCurrentGradeTests {
    
    // ----------------------------------------------------------------
    // Case: Course with 2 graded components.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_weightedAverage_isComputedCorrectly() {
        // Given
        let components = [
            GradeComponent(name: "Exam 1", weight: 30, grade: 80),
            GradeComponent(name: "Exam 2", weight: 70, grade: 90)
        ]
        let course = Course(
            name: "Calculus",
            shortCode: "MATH101",
            components: components
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is not nil
        #expect(grade != nil, "currentGrade should not be nil when there are graded components")

        // Check expected calculated grade (87.0)
        if let grade {
            #expect(abs(grade - 87.0) < 0.0001,
                    "Expected weighted average to be 87.0, got \(grade)")
        }
    }
    
    // ----------------------------------------------------------------
    // Case: A course with no components.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_noComponents_isNil() {
        // Given
        let course = Course(
            name: "Empty Course",
            shortCode: "EMPTY",
            components: []
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is nil
        #expect(grade == nil, "currentGrade should be nil when there are no components")
    }

    // ----------------------------------------------------------------
    // Case: Course with 2 non-graded components.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_allGradesNil_isNil() {
        // Given
        let components = [
            GradeComponent(name: "Exam 1", weight: 50, grade: nil),
            GradeComponent(name: "Exam 2", weight: 50, grade: nil)
        ]
        let course = Course(
            name: "Unstarted Course",
            shortCode: "UNST",
            components: components
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is nil
        #expect(grade == nil,
                "currentGrade should be nil when all components have nil grades")
    }

    // ----------------------------------------------------------------
    // Case: Course with 2 graded components but each component has a
    // weight of 0.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_zeroTotalWeight_isNil() {
        // Given
        let components = [
            GradeComponent(name: "Exam 1", weight: 0, grade: 80),
            GradeComponent(name: "Exam 2", weight: 0, grade: 90)
        ]
        let course = Course(
            name: "Broken Weights",
            shortCode: "BROKEN",
            components: components
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is nil
        #expect(grade == nil,
                "currentGrade should be nil when total weight is 0")
    }

    // ----------------------------------------------------------------
    // Case: Course with graded and ungraded components.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_ignoresUngradedComponents() {
        // Given: mix of graded and ungraded components
        //
        // Only Midterm is graded:
        //   HW:     40% weight, nil grade
        //   Midterm 60% weight, 95 grade
        //
        // Expected:
        //   Only use graded components:
        //   (95 * 60) / 60 = 95.0

        // Given
        let components = [
            GradeComponent(name: "Homework", weight: 40, grade: nil),
            GradeComponent(name: "Midterm",  weight: 60, grade: 95)
        ]
        let course = Course(
            name: "Mixed Course",
            shortCode: "MIX",
            components: components
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is not nil
        #expect(grade != nil,
                "currentGrade should not be nil when at least one component is graded")

        // Check expected calculated grade (95.0)
        if let grade {
            #expect(abs(grade - 95.0) < 0.0001,
                    "Expected grade to be 95.0 when only the midterm is graded, got \(grade)")
        }
    }
    
    // ----------------------------------------------------------------
    // Case: Course with a single graded component.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_singleComponent_matchesThatGrade() {
        // Given
        let components = [
            GradeComponent(name: "Final Exam", weight: 100, grade: 92)
        ]
        let course = Course(
            name: "Single Component Course",
            shortCode: "ONE",
            components: components
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is not nil
        #expect(grade != nil,
                "currentGrade should not be nil when there is one graded component")

        // Check expected calculated grade (92.0)
        if let grade {
            #expect(abs(grade - 92.0) < 0.0001,
                    "Expected grade to match the only component (92.0), got \(grade)")
        }
    }

    // ----------------------------------------------------------------
    // Case: Weights do NOT sum to 100; they should still be normalized
    // by totalWeight, not by 100.
    // ----------------------------------------------------------------
    @Test
    func currentGrade_partialWeights_areNormalizedByTotalWeight() {
        // Given
        let components = [
            GradeComponent(name: "Quiz",    weight: 20, grade: 70),
            GradeComponent(name: "Midterm", weight: 30, grade: 100)
        ]
        let course = Course(
            name: "Partial Weights",
            shortCode: "PART",
            components: components
        )

        // When
        let grade = course.currentGrade

        // Check that the calculated grade is not nil
        #expect(grade != nil,
                "currentGrade should not be nil when there are graded components")

        // Check expected calculated grade (88.0)
        if let grade {
            #expect(abs(grade - 88.0) < 0.0001,
                    "Expected normalized grade to be 88.0, got \(grade)")
        }
    }
}
