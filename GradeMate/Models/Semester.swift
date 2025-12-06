//
//  Semester.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import Foundation

// ----------------------------------------------------------------
// Model representing an academic semester containing courses.
// ----------------------------------------------------------------
struct Semester: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    // List of courses in this semester
    var courses: [Course]

    // Defaults to a new UUID and an empty courses list
    init(id: UUID = UUID(), name: String, courses: [Course] = []) {
        self.id = id
        self.name = name
        self.courses = courses
    }
}
