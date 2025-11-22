//
//  CourseDetailView.swift
//  GradeMate
//
//  Created by Joaquin Sedamano on 11/22/25.
//

import SwiftUI

struct CourseDetailView: View {
    @ObservedObject var viewModel: SemesterViewModel
    let semester: Semester
    let course: Course

    @State private var showAddComponent = false
    @State private var componentToEdit: GradeComponent? = nil


    private var currentCourse: Course? {
        viewModel.semesters
            .first(where: { $0.id == semester.id })?
            .courses
            .first(where: { $0.id == course.id })
    }

    var body: some View {
        VStack {
            if let currentCourse = currentCourse {
                // --- Summary card with current grade ---
                gradeSummaryView(for: currentCourse)
                    .padding(.horizontal)
                    .padding(.top, 12)

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
                    List {
                        Section("Grade components") {
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showAddComponent = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddComponent) {
            AddComponentView(viewModel: viewModel, semester: semester, course: course)
        }
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

    @ViewBuilder
    private func gradeSummaryView(for course: Course) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current grade")
                .font(.subheadline)
                .foregroundStyle(.secondary)

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
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue.opacity(0.08))
        )
    }
}

#Preview {
    let vm = SemesterViewModel()
    let sem = Semester(name: "Fall 2025")
    let course = Course(name: "Calculus I", shortCode: "MATH 1225")
    vm.semesters = [Semester(name: sem.name, courses: [course])]
    return NavigationStack {
        CourseDetailView(viewModel: vm, semester: sem, course: course)
    }
}
