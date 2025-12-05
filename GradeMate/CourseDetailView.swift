//
//  CourseDetailView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

// ----------------------------------------------------------------
// Detail view for a course: summary, components list, and add/edit
// actions.
// ----------------------------------------------------------------
struct CourseDetailView: View {
    // Data context
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester
    let course: Course

    // Controls Add Component sheet presentation
    @State private var showAddComponent = false
    // Selected component to edit (presents edit sheet)
    @State private var componentToEdit: GradeComponent? = nil
    
    // Used to adapt card styling to light/dark mode
    @Environment(\.colorScheme) private var colorScheme

    // Live lookup of this course in the view model (keeps view in sync)
    private var currentCourse: Course? {
        viewModel.semesters
            .first(where: { $0.id == semester.id })?
            .courses
            .first(where: { $0.id == course.id })
    }

    var body: some View {
        VStack {
            // Ensure the course still exists
            if let currentCourse = currentCourse {
                // --- Summary card with current grade ---
                gradeSummaryView(for: currentCourse)
                    .padding(.horizontal)
                    .padding(.top, 12)

                // Empty state with call to action
                if currentCourse.components.isEmpty {
                    VStack(spacing: 12) {
                        Text("No grade components yet")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("Start by adding components like exams, projects or quizzes for this course.")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                        Button {
                            showAddComponent = true
                        } label: {
                            Text("Add first component")
                                .fontWeight(.semibold)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.blue.opacity(0.2))
                                )
                        }
                        .padding(.top, 4)
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    Spacer()
                } else {
                    // Components list
                    List {
                        Section("Grade components") {
                            // Tap a row to edit; swipe to delete
                            ForEach(currentCourse.components) { component in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(component.name)
                                        .font(.headline)
                                    HStack {
                                        Text("Weight: \(component.weight, specifier: "%.1f")%")
                                        if let grade = component.grade {
                                            Text("• Grade: \(grade, specifier: "%.1f")%")
                                        } else {
                                            Text("• No grade yet")
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                }
                                .padding(.vertical, 4)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    componentToEdit = component
                                }
                            }
                            .onDelete { offsets in
                                viewModel.removeComponents(at: offsets, from: course, in: semester)
                            }
                        }
                    }
                }
            } else {
                Text("Course not found")
                    .foregroundStyle(.red)
                Spacer()
            }
        }
        .navigationTitle(course.name)
        .navigationBarTitleDisplayMode(.inline)
        // Add component button
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddComponent = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        // Presents AddComponentView
        .sheet(isPresented: $showAddComponent) {
            AddComponentView(viewModel: viewModel, semester: semester, course: course)
        }
        // Presents EditComponentView for the selected component
        .sheet(item: $componentToEdit) { component in
            EditComponentView(
                viewModel: viewModel,
                semester: semester,
                course: course,
                component: component
            )
        }
    }

    // MARK: - Helper views

    // Summary card showing the current grade
    @ViewBuilder
    private func gradeSummaryView(for course: Course) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current grade")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Show grade if available; otherwise a placeholder
            if let grade = course.currentGrade {
                Text("\(grade, specifier: "%.1f")%")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
            } else {
                Text("No graded components yet")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        // Card background with adaptive opacity
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(colorScheme == .dark ? 0.30 : 0.12))
        )
    }
}

// Preview with sample data
#Preview {
    let vm = SemesterViewModel()
    let course = Course(name: "Calculus I", shortCode: "MATH 1225")
    let sem = Semester(name: "Fall 2025", courses: [course])
    vm.semesters = [sem]
    return NavigationStack {
        CourseDetailView(viewModel: vm, semester: sem, course: course)
    }
}
