//
//  ContentView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// Root view: shows a welcome screen when there are no semesters,
// or the semesters list.
// ----------------------------------------------------------------
struct ContentView: View {
    // Controls presentation of the Add Semester sheet
    @State private var showAddSemester = false
    // Shared view model for managing semesters
    @StateObject private var viewModel = SemesterViewModel()

    var body: some View {
        NavigationStack {
            if viewModel.semesters.isEmpty {
                // Welcome Screen
                VStack(spacing: 16) {
                    Text("Welcome to GradeMate!")
                        .font(.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)

                    Text("You haven't created any semesters yet. \nStart by creating your first semester to add your courses.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    Button {
                        showAddSemester = true
                    } label: {
                        Text("Create my first semester")
                            .fontWeight(.semibold)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.2))
                            )
                    }
                    .padding(.top, 8)

                    Spacer()
                }
                .padding(.top, 200)
                .padding()
                .navigationTitle("GradeMate")
            } else {
                // List of Semesters
                SemesterListView(viewModel: viewModel)
            }
        }
        // Presents the AddSemesterView when the user taps the button
        .sheet(isPresented: $showAddSemester) {
            AddSemesterView(viewModel: viewModel)
        }
    }
}

// Preview
#Preview {
    ContentView()
}
