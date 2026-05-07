//
//  AddNoteView.swift
//  WeatherNotes
//
import SwiftUI

// MARK: - AddNoteView
struct AddNoteView: View {

    @StateObject private var viewModel = AddNoteViewModel()
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isTextFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                // MARK: Поле ввода
                Section {
                    TextField(
                        "E.g.: morning run, commute to work…",
                        text: $viewModel.noteText,
                        axis: .vertical
                    )
                    .lineLimit(3...6)
                    .focused($isTextFocused)
                    .disabled(viewModel.state == .loading)
                } header: {
                    Text("Note text")
                } footer: {
                    Text("Weather will be saved automatically at the moment of creation.")
                        .foregroundStyle(.secondary)
                }

                // MARK: Блок ошибки — появляется только при .failure
                if case .failure(let message) = viewModel.state {
                    Section {
                        Label(message, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                            .font(.subheadline)
                    }
                }
            }
            .navigationTitle("New Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .disabled(viewModel.state == .loading)
                }
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
            // Автофокус на поле ввода при открытии
            .onAppear { isTextFocused = true }
            // Закрываемся когда ViewModel сообщает об успехе
            .onChange(of: viewModel.state) { _, newState in
                if newState == .success { dismiss() }
            }
            // Сбрасываем ошибку когда пользователь начинает редактировать
            .onChange(of: viewModel.noteText) { _, _ in
                viewModel.resetErrorIfNeeded()
            }
        }
    }

    // MARK: - Save Button
    @ViewBuilder
    private var saveButton: some View {
        if viewModel.state == .loading {
            ProgressView()
                .controlSize(.small)
        } else {
            Button("Save") {
                Task { await viewModel.save() }
            }
            .fontWeight(.semibold)
            .disabled(viewModel.isSaveDisabled)
        }
    }
}

// MARK: - Preview

#Preview {
    AddNoteView()
}
