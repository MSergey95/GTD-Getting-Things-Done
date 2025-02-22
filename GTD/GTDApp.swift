//
//  GTDApp.swift
//  GTD
//
//  Created by Сергей Минеев on 2/16/25.
//  Точка входа

import SwiftUI
@main
struct GTDApp: App {
    @StateObject private var storage = TaskStorage()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(storage)
        }
    }
}
