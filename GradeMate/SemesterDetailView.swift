//
//  SemesterDetailView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct SemesterDetailView: View {
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester

    @Environment(\.dismiss) private var dismiss

    @State private var showAddCourse = false

    // Course navigation
    @State private var selectedCourse: Course? = nil
    @State private var navigateToCourse = false

    // Semester options
    @State private var showRenameSemester = false
    @State private var showDeleteAlert = false

    // Search for the actual version of the semester in viewModel
    private var currentSemester: Semester? {
        viewModel.semesters.first(where: { $0.id == semester.id })
    }

    var body: some View {
        VStack {
            if let currentSemester = currentSemester {
                if currentSemester.courses.isEmpty {
                    // Message when there are no courses yet
                    VStack(spacing: 16) {
                        Text("No courses yet")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Start by adding your first course for this semester.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)

                        Button {
                            showAddCourse = true
                        } label: {
                            Text("Add first course")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.2))
                                )
                        }
                    }
                    .padding()
                    .padding(.top, 40)

                    Spacer()
                } else {
                    List {
                        Section {
                            ForEach(currentSemester.courses) { course in
                                courseCard(for: course)
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selectedCourse = course
                                        navigateToCourse = true
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                            }
                            .onDelete { offsets in
                                viewModel.removeCourses(at: offsets, in: currentSemester)
                            }
                            .onMove { source, dest in
                                viewModel.moveCourses(from: source, to: dest, in: currentSemester)
                            }
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color(.systemGroupedBackground))
                }
            } else {
                Text("Semester not found")
                    .foregroundStyle(.red)
                Spacer()
            }
        }
        .navigationTitle(semester.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            // Show "Edit" just if there is at least one course
            if let currentSemester = currentSemester,
               !currentSemester.courses.isEmpty {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }

            // Buttons + options menu (always visible)
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    showAddCourse = true
                } label: {
                    Image(systemName: "plus")
                }

                Menu {
                    Button {
                        showRenameSemester = true
                    } label: {
                        Label("Rename semester", systemImage: "pencil")
                    }

                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Label("Delete semester", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showAddCourse) {
            AddCourseView(viewModel: viewModel, semester: semester)
        }
        .sheet(isPresented: $showRenameSemester) {
            RenameSemesterView(viewModel: viewModel, semester: semester)
        }
        .alert("Delete semester?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}

            Button("Delete", role: .destructive) {
                viewModel.removeSemester(semester)
                dismiss()
            }
        } message: {
            Text("This will remove the semester and all its courses. This action cannot be undone.")
        }
        // Modern navigation
        .navigationDestination(isPresented: $navigateToCourse) {
            if let selectedCourse {
                CourseDetailView(
                    viewModel: viewModel,
                    semester: semester,
                    course: selectedCourse
                )
            } else {
                EmptyView()
            }
        }
    }

    // MARK: - Helper views

    private func courseCard(for course: Course) -> some View {
        // Format grade as text
        let gradeText: String = {
            if let grade = course.currentGrade {
                return String(format: "%.1f%%", grade)
            } else {
                return "--"
            }
        }()

        return VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(gradeText)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(gradeText == "--" ? .secondary : .primary)

                Spacer()

                Text(course.shortCode.isEmpty ? "Course" : course.shortCode)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }

            Text(course.name)
                .font(.headline)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
        .padding(.vertical, 0)
    }
}

#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    vm.semesters = [sem]
    return NavigationStack {
        SemesterDetailView(viewModel: vm, semester: sem)
    }
}
