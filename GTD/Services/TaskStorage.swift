//
//  TaskStorage.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//

import Foundation
import SwiftUI

/// Хранилище задач с сохранением в JSON
class TaskStorage: ObservableObject {
    @Published var tasks: [Task] = []

    private let fileName = "tasks.json"

    init() {
        loadTasks()
    }

    // MARK: - CRUD операции

    func addTask(title: String,
                 details: String? = nil,
                 priority: TaskPriority = .medium,
                 folder: FolderType = .inbox) {

        let newTask = Task(
            id: UUID(),
            title: title,
            details: details,
            priority: priority,
            folder: folder
        )
        tasks.append(newTask)
        saveTasks()
    }

    func deleteTask(_ task: Task) {
        tasks.removeAll { $0.id == task.id }
        saveTasks()
    }

    func updateTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            saveTasks()
        }
    }

    // MARK: - Сохранение / Загрузка

    private func saveTasks() {
        do {
            let data = try JSONEncoder().encode(tasks)
            let url = getDocumentsDirectory().appendingPathComponent(fileName)
            try data.write(to: url)
        } catch {
            print("Ошибка сохранения задач: \(error)")
        }
    }

    private func loadTasks() {
        let url = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode([Task].self, from: data)
            tasks = decoded
        } catch {
            print("Ошибка загрузки (возможно, файл ещё не создан): \(error)")
            tasks = []
        }
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
