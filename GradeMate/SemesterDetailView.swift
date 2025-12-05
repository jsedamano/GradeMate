//
//  SemesterDetailView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// Detail view for a semester: shows courses, add/rename/delete
// actions, and navigation to course details.
// ----------------------------------------------------------------
struct SemesterDetailView: View {
    // Data context
    @ObservedObject var viewModel: SemesterViewModel
    
    let semester: Semester

    // Used to dismiss after destructive actions
    @Environment(\.dismiss) private var dismiss

    // Controls Add Course sheet presentation
    @State private var showAddCourse = false

    // Selected course for navigation
    @State private var selectedCourse: Course? = nil
    // Triggers navigation to CourseDetailView
    @State private var navigateToCourse = false

    // Controls Rename Semester sheet
    @State private var showRenameSemester = false
    // Controls Delete confirmation alert
    @State private var showDeleteAlert = false

    // Live lookup of this semester in the view model (keeps view in sync)
    private var currentSemester: Semester? {
        viewModel.semesters.first(where: { $0.id == semester.id })
    }

    var body: some View {
        VStack {
            if let currentSemester = currentSemester {
                // Empty state with call to action
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
                    // Courses list
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
        // Editing controls, add button, and options menu
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
        // Presents AddCourseView
        .sheet(isPresented: $showAddCourse) {
            AddCourseView(viewModel: viewModel, semester: semester)
        }
        // Presents RenameSemesterView
        .sheet(isPresented: $showRenameSemester) {
            RenameSemesterView(viewModel: viewModel, semester: semester)
        }
        // Delete confirmation alert
        .alert("Delete semester?", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {}

            Button("Delete", role: .destructive) {
                viewModel.removeSemester(semester)
                dismiss()
            }
        } message: {
            Text("This will remove the semester and all its courses. This action cannot be undone.")
        }
        // Programmatic navigation to CourseDetailView
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

    // Card view for a course row (shows short code, name, and current grade)
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
                .fill(Color(
                    light: .white,
                    dark: .secondarySystemBackground
                ))
                .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
        .padding(.vertical, -5)
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
