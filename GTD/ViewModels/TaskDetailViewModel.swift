//
//  TaskDetailViewModel.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//

import Foundation
import SwiftUI

/// ViewModel для экрана деталей задачи
class TaskDetailViewModel: ObservableObject {
    private(set) var storage: TaskStorage
    @Published var title: String
    @Published var details: String?
    @Published var priority: TaskPriority
    @Published var folder: FolderType

    public var task: Task

    init(task: Task, storage: TaskStorage) {
        self.task = task
        self.storage = storage

        // Инициализируем свойства
        self.title = task.title
        self.details = task.details
        self.priority = task.priority
        self.folder = task.folder
    }
    /// Если  нужно обратиться к `task.id`,  computed property:
        var taskId: UUID {
            task.id
        }
    /// Сохранение изменений в задаче
    func saveChanges() {
        task.title = title
        task.details = details
        task.priority = priority
        task.folder = folder

        storage.updateTask(task)
    }
}
