//
//  SettingsStorageService.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 23.07.2025.
//
import Foundation

class SettingsStorageService {
    static let shared = SettingsStorageService()
    
    private let filename = "settings.json"
    
    private var fileURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(filename)
    }

    func save(_ settings: SettingsModel) {
        do {
            let data = try JSONEncoder().encode(settings)
            try data.write(to: fileURL)
            print("✅ Settings saved")
        } catch {
            print("❌ Failed to save settings:", error)
        }
    }

    func load() -> SettingsModel? {
        do {
            let data = try Data(contentsOf: fileURL)
            let settings = try JSONDecoder().decode(SettingsModel.self, from: data)
            print("✅ Settings loaded")
            return settings
        } catch {
            print("⚠️ No settings loaded:", error)
            return nil
        }
    }
}
