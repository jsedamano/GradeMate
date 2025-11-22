//
//  SemesterListView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct SemesterListView: View {
    @ObservedObject var viewModel: SemesterViewModel
    @State private var showAddSemester = false

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
        .sheet(isPresented: $showAddSemester) {
            AddSemesterView(viewModel: viewModel)
        }
    }
}

#Preview {
    SemesterListView(viewModel: SemesterViewModel())
}
