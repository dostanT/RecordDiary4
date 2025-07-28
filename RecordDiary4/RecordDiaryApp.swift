//
//  RecordDiaryApp.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 09.07.2025.
//

import SwiftUI
import SwiftfulRouting

@main
struct RecordDiaryApp: App {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var settingsVM = SettingsViewModel()
    @StateObject private var calendatVM = CalendarViewModel()
    var body: some Scene {
        WindowGroup {
            RouterView { router in
                HomeView()
            }
            .environmentObject(settingsVM)
            .environmentObject(calendatVM)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            if newPhase == .background {
                print(newPhase)
                print("Before: \(settingsVM.data)")
                print("➡️\(settingsVM.recentDeleted)")
                settingsVM.sortData(fromExistToDelete: false)
                print("After: \(settingsVM.data)")
                settingsVM.saveToCoreData()
            }
        }
    }
}
