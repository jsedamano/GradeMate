//
//  GradeComponent.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import Foundation

// ----------------------------------------------------------------
// Model representing a single graded component of a course.
// ----------------------------------------------------------------
struct GradeComponent: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String          // e.g. "Exam 1"
    var weight: Double        // weight as percentage (e.g. 20.0 for 20%)
    var grade: Double?        // 0–100, nil if no grade yet

    // Default id is a new UUID; grade is optional (nil if not graded yet)
    init(id: UUID = UUID(), name: String, weight: Double, grade: Double? = nil) {
        self.id = id
        self.name = name
        self.weight = weight
        self.grade = grade
    }
}
