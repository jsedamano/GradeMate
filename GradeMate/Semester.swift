//
//  Semester.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import Foundation

struct Semester: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var courses: [Course]   // 👈 list of courses

    init(id: UUID = UUID(), name: String, courses: [Course] = []) {
        self.id = id
        self.name = name
        self.courses = courses
    }
}
