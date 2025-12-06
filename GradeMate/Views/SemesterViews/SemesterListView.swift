//
//  SemesterListView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// Lists all semesters and navigates to their details.
// ----------------------------------------------------------------
struct SemesterListView: View {
    // Data context
    @ObservedObject var viewModel: SemesterViewModel
    // Controls Add Semester sheet presentation
    @State private var showAddSemester = false

    // Semesters list with navigation links
    var body: some View {
        List {
            ForEach(viewModel.semesters) { semester in
                NavigationLink {
                    SemesterDetailView(viewModel: viewModel, semester: semester)
                } label: {
                    Text(semester.name)
                        .font(.headline)
                }
            }
        }
        .navigationTitle("Your Semesters")
        // Add button
        .toolbar {
            // Button to add more semesters
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddSemester = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // Presents AddSemesterView
        .sheet(isPresented: $showAddSemester) {
            AddSemesterView(viewModel: viewModel)
        }
    }
}

// Preview
#Preview {
    let vm = SemesterViewModel()
    vm.semesters = [
        Semester(name: "Fall 2025", courses: [
            Course(name: "Calculus I", shortCode: "MATH 1225"),
            Course(name: "Intro to CS", shortCode: "CS 1114")
        ]),
        Semester(name: "Spring 2026", courses: [
            Course(name: "Physics I", shortCode: "PHYS 2305")
        ])
    ]
    return NavigationStack {
        SemesterListView(viewModel: vm)
    }
}
