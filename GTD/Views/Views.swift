//
//  SidebarView.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//

import SwiftUI

// MARK: - Корневая View с TabView
struct RootTabView: View {
    @EnvironmentObject var storage: TaskStorage

    var body: some View {
        TabView {
            NavigationStack {
                // Первая вкладка показывает задачи из .nextActions
                FolderTasksView(folder: .nextActions)
            }
            .tabItem {
                Label("Next Actions", systemImage: "list.bullet")
            }

            NavigationStack {
                // Вторая вкладка — список папок
                FoldersView()
            }
            .tabItem {
                Label("Folders", systemImage: "folder")
            }
        }
    }
}

// MARK: - Список задач для конкретной папки (FolderTasksView)
struct FolderTasksView: View {
    @EnvironmentObject var storage: TaskStorage

    /// Какая именно папка показывается (Inbox, NextActions и т.д.)
    let folder: FolderType

    /// Локальный список задач, отфильтрованных по folder
    @State private var tasks: [Task] = []

    var body: some View {
        List {
            ForEach(tasks) { task in
                NavigationLink(destination: {
                    TaskDetailView(task: task)
                }) {
                    Text(task.title)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        storage.deleteTask(task)
                        loadTasks()
                    } label: {
                        Text("Удалить")
                    }
                }
            }
        }
        .navigationTitle(folder.rawValue)
        .toolbar {
            Button("Add") {
                // Добавляем простую тестовую задачу
                storage.addTask(title: "New Task", folder: folder)
                loadTasks()
            }
        }
        .onAppear {
            loadTasks()
        }
    }

    /// Фильтрация задач по нужной папке
    private func loadTasks() {
        tasks = storage.tasks.filter { $0.folder == folder }
    }
}

// MARK: - Список всех папок (FoldersView)
struct FoldersView: View {
    /// Все варианты папок берем из FolderType
    let allFolders = FolderType.allCases

    var body: some View {
        List {
            ForEach(allFolders, id: \.self) { folder in
                NavigationLink(destination: {
                    // При нажатии открываем папку
                    FolderTasksView(folder: folder)
                }) {
                    Label(folder.rawValue, systemImage: "folder")
                }
            }
        }
        .navigationTitle("Folders")
    }
}

// MARK: - Детальный экран задачи (TaskDetailView)
struct TaskDetailView: View {
    @EnvironmentObject var storage: TaskStorage

    /// Редактируемая задача
    let task: Task

    /// Локальные поля для редактирования
    @State private var title: String
    @State private var details: String
    @State private var priority: TaskPriority
    @State private var folder: FolderType

    init(task: Task) {
        self.task = task

        // Инициализируем State из полей задачи
        _title = State(initialValue: task.title)
        _details = State(initialValue: task.details ?? "")
        _priority = State(initialValue: task.priority)
        _folder = State(initialValue: task.folder)
    }

    var body: some View {
        Form {
            Section("Title") {
                TextField("Task title", text: $title)
            }
            Section("Details") {
                TextField("Details", text: $details)
            }
            Section("Priority") {
                Picker("Priority", selection: $priority) {
                    ForEach(TaskPriority.allCases, id: \.self) { prio in
                        Text(prio.rawValue).tag(prio)
                    }
                }
                .pickerStyle(.segmented)
            }
            Section("Folder") {
                Picker("Folder", selection: $folder) {
                    ForEach(FolderType.allCases, id: \.self) { folder in
                        Text(folder.rawValue).tag(folder)
                    }
                }
            }
        }
        .navigationTitle("Task Detail")
        .toolbar {
            Button("Save") {
                saveChanges()
            }
        }
    }

    /// Обновляем задачу в TaskStorage
    private func saveChanges() {
        // Создаём копию Task с новыми значениями
        var updatedTask = task
        updatedTask.title = title
        updatedTask.details = details.isEmpty ? nil : details
        updatedTask.priority = priority
        updatedTask.folder = folder

        // Передаём обновлённую задачу в storage
        storage.updateTask(updatedTask)
    }
}
