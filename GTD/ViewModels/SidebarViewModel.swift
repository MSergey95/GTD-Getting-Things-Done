//
//  SidebarViewModel.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//

import Foundation
import SwiftUI

/// ViewModel для боковой панели (список папок, выбранная папка)
class SidebarViewModel: ObservableObject {
    @Published var selectedFolder: FolderType? = nil

    /// Возвращает все доступные папки из enum
    let allFolders = FolderType.allCases

    func selectFolder(_ folder: FolderType) {
        selectedFolder = folder
        // Дополнительная логика:
        // Например, уведомить другой экран, что папка выбрана,
        // или перейти на соответствующий список задач.
    }
}
