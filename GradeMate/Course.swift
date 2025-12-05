//
//  Course.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import Foundation

// ----------------------------------------------------------------
// Model representing a course with an optional set of graded
// components.
// ----------------------------------------------------------------
struct Course: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var shortCode: String
    // Grade components (e.g., exams, assignments) that contribute to the course grade
    var components: [GradeComponent]

    // Default-initialized with a new UUID; components default to an empty list
    init(
        id: UUID = UUID(),
        name: String,
        shortCode: String,
        components: [GradeComponent] = []
    ) {
        self.id = id
        self.name = name
        self.shortCode = shortCode
        self.components = components
    }
}

// Derived values and helpers
extension Course {
    // Weighted average of graded components; returns nil if nothing graded yet
    var currentGrade: Double? {
        // Keep only components that have a grade
        let gradedComponents = components.compactMap { component -> (weight: Double, grade: Double)? in
            guard let grade = component.grade else { return nil }
            return (component.weight, grade)
        }

        guard !gradedComponents.isEmpty else { return nil }

        // Sum the weights of graded components
        let totalWeight = gradedComponents.reduce(0) { $0 + $1.weight }
        guard totalWeight > 0 else { return nil }

        // Sum of (grade × weight)
        let weightedSum = gradedComponents.reduce(0) { partial, item in
            partial + (item.grade * item.weight)
        }

        // Weighted average
        return weightedSum / totalWeight
    }
}
