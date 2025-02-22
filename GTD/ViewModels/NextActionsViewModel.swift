//
//  NextActionsViewModel.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//

import Foundation
import SwiftUI

/// ViewModel для экрана Next Actions
class NextActionsViewModel: ObservableObject {

    @Published var tasks: [Task] = []

    // Ссылка на хранилище (абстракция над данными)
    private(set) var storage: TaskStorage

    init(storage: TaskStorage) {
        self.storage = storage
        loadTasks()
    }

    /// Загружаем задачи, относящиеся к папке .nextActions
    func loadTasks() {
        tasks = storage.tasks.filter { $0.folder == .nextActions }
    }

    /// Добавление новой задачи в папку Next Actions
    func addTask(title: String) {
        storage.addTask(title: title, folder: .nextActions)
        loadTasks()
    }

    /// Удаление задачи
    func deleteTask(_ task: Task) {
        storage.deleteTask(task)
        loadTasks()
    }
}
