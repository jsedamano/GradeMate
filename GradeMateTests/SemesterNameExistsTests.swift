//
//  SemesterNameExistsTests.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 12/3/25.
//

import Testing
@testable import GradeMate

// ----------------------------------------------------------------
// Tests for semester naming.
// ----------------------------------------------------------------
@MainActor
struct SemesterNameExistsTests {

    // Helper: a view model with some sample semesters
    private func makeViewModel() -> SemesterViewModel {
        let vm = SemesterViewModel()
        vm.semesters = [
            Semester(name: "Fall 2025"),
            Semester(name: "Fall 2026"),
            Semester(name: "Spring 2026")
        ]
        return vm
    }

    // ------------------------------------------------------------
    // Case 1: Exact name should return true.
    // ------------------------------------------------------------
    @Test
    func semesterNameExists_exactMatch_isTrue() {
        let vm = makeViewModel()

        #expect(vm.semesterNameExists("Fall 2025") == true)
        #expect(vm.semesterNameExists("Spring 2026") == true)
    }

    // ------------------------------------------------------------
    // Case 2: Case-insensitive and trimmed whitespace should still match.
    // ------------------------------------------------------------
    @Test
    func semesterNameExists_caseAndWhitespaceInsensitive_isTrue() {
        let vm = makeViewModel()
        
        #expect(vm.semesterNameExists("fall 2025") == true)
        #expect(vm.semesterNameExists("   FALL 2026   ") == true)
    }

    // ------------------------------------------------------------
    // Case 3: Non-existing names should return false.
    // ------------------------------------------------------------
    @Test
    func semesterNameExists_nonExisting_isFalse() {
        let vm = makeViewModel()

        #expect(vm.semesterNameExists("Summer 2025") == false)
        #expect(vm.semesterNameExists("Winter 2030") == false)
    }
}
