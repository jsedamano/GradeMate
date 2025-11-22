//
//  Course.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import Foundation

struct Course: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var shortCode: String
    var components: [GradeComponent]

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

extension Course {
    var currentGrade: Double? {
        let gradedComponents = components.compactMap { component -> (weight: Double, grade: Double)? in
            guard let grade = component.grade else { return nil }
            return (component.weight, grade)
        }

        guard !gradedComponents.isEmpty else { return nil }

        let totalWeight = gradedComponents.reduce(0) { $0 + $1.weight }
        guard totalWeight > 0 else { return nil }

        let weightedSum = gradedComponents.reduce(0) { partial, item in
            partial + (item.grade * item.weight)
        }

        return weightedSum / totalWeight
    }
}
