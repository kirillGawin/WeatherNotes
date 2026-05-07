//
//  NotesListView.swift
//  WeatherNotes
//
import CoreData
import SwiftUI

// MARK: - NotesListView
struct NotesListView: View {

    @StateObject private var viewModel = NotesListViewModel()
    @State private var isAddingNote = false

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.notes.isEmpty {
                    emptyStateView
                } else {
                    listView
                }
            }
            .navigationTitle("Weather Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isAddingNote = true
                    } label: {
                        Image(systemName: "plus")
                            .fontWeight(.semibold)
                    }
                    .accessibilityLabel("Add note")
                }
            }
            .sheet(isPresented: $isAddingNote) {
                AddNoteView()
            }
        }
    }

    // MARK: - List

    private var listView: some View {
        List {
            ForEach(viewModel.notes) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    NoteRowView(note: note)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
            .onDelete(perform: viewModel.delete(at:))
        }
        .listStyle(.insetGrouped)
        .animation(.easeInOut, value: viewModel.notes)
    }

    // MARK: - Empty State

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "note.text.badge.plus")
                .font(.system(size: 64))
                .foregroundStyle(.quaternary)

            Text("No notes yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.secondary)

            Text("Tap «+» to add your first note\nwith current weather")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)

            Button {
                isAddingNote = true
            } label: {
                Label("Add Note", systemImage: "plus.circle.fill")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top, 8)
        }
        .padding(32)
    }
}

// MARK: - Preview

#Preview {
    NotesListView()
        .environment(
            \.managedObjectContext,
             PersistenceController.preview.container.viewContext
        )
}
