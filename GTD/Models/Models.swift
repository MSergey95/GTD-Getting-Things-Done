//
//  Models.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//

import Foundation

// MARK: - Перечисление папок GTD
enum FolderType: String, CaseIterable, Codable {
    case inbox = "📥 Inbox"
    case inProcess = "🔄 In Process"
    case nextActions = "✅ Next Actions"
    case projects = "🏗 Projects"
    case somedayMaybe = "🔧 Someday/Maybe"
    case review = "🔁 Review"
    case reference = "📁 Reference"
    case done = "📂 Done"
}

// MARK: - Перечисление приоритетов задачи
enum TaskPriority: String, CaseIterable, Codable {
    case high = "🔥 Высокий"
    case medium = "🟡 Средний"
    case low = "⚪ Низкий"
}

// MARK: - Модель задачи
struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var details: String?
    var priority: TaskPriority
    var folder: FolderType
    // Можно добавить любые поля вроде dueDate, tags и т.д.
}

// MARK: - Модель проекта (опционально)
struct Project: Identifiable, Codable {
    let id: UUID
    var name: String
    var tasks: [Task]
}

// MARK: - Модель тега (опционально)
struct Tag: Codable, Identifiable {
    let id: UUID
    var name: String
}
