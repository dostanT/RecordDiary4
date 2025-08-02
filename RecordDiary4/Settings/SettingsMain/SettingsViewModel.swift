import Foundation
import SwiftUI
import Combine

class SettingsViewModel: ObservableObject {
    // MARK: - Настройки
    @Published var isPremium: Bool = false
    @Published var apearanceIsLight: Bool = false
    @Published var pointInCalendarVisable: Bool = true
    @Published var language: String = "ENG"
    @Published var recentDeleted: [RecordDataModel] = []
    @Published var disableRecentDeleted: Bool = false
    @Published var delete: DeletingType = .days7
    @Published var emotionInUse: [EmotionModel] = []
    @Published var haptics: Bool = true

    // MARK: - Вспомогательные флаги
    @Published var isRecording: Bool = false
    @Published var selectedEmotion: EmotionModel? = nil
    @Published var isPlayRecord: Bool = false
    @Published var selectedRecord: RecordDataModel? = nil
    @Published var showDeleteButton: Bool = false

    // MARK: - Сервисы
    let audioInputOutputService = AudioInputOutputService()
    let coreDataService = CoreDateService()
    var cancellables: Set<AnyCancellable> = []

    // MARK: - Данные
    @Published var data: [RecordDataModel] = []

    // MARK: - Init
    init() {
        loadSettings()
        data = audioInputOutputService.giveEmotionsForRecordsWithoutEmotions(recordsLocal: data)
        addCoreDataSubscriber()
        setupAutoSave()
    }

    // MARK: - CoreData Подписка
    private func addCoreDataSubscriber() {
        coreDataService.$saved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedData in
                guard let self else { return }
                if !returnedData.isEmpty {
                    self.data = self.audioInputOutputService.giveEmotionsForRecordsWithoutEmotions(recordsLocal: returnedData)
                    self.sortData(fromExistToDelete: true)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Автосохранение
    private func setupAutoSave() {
        print("Start setupAutoSave()")
        Publishers.CombineLatest3(
            $isPremium.combineLatest($apearanceIsLight, $pointInCalendarVisable),
            $language.combineLatest($emotionInUse, $haptics),
            $disableRecentDeleted.combineLatest($delete)
        )
        .sink { [weak self] _, _, _ in
            self?.saveSettings()
            self?.hapticsControllerManager()
        }
        .store(in: &cancellables)
    }


    // MARK: - Запись
    func startRecording(selectedEmotion: EmotionModel) {
        isRecording = true
        self.selectedEmotion = selectedEmotion
        audioInputOutputService.startRecording(emotion: selectedEmotion)
    }

    func stopRecording(showDate: Date) {
        isRecording = false
        guard let record = audioInputOutputService.stopRecording(shownDate: showDate) else { return }
        data.append(record)
        selectedEmotion = nil
    }

    // MARK: - Воспроизведение
    func changeAudioPlaying(chosenRecord: RecordDataModel) {
        guard selectedRecord?.id != chosenRecord.id else {
            print("⚠️ Выбран тот же файл")
            return
        }

        audioInputOutputService.stopPlayback()
        selectedRecord = nil

        audioInputOutputService.playRecording(url: chosenRecord.url) { [weak self] success in
            self?.selectedRecord = chosenRecord
        }
    }
    
    func getDurationString(record: RecordDataModel) async -> String {
        if let duration = await audioInputOutputService.getDurationString(from: record.url) {
            return duration
        } else {
            return "00:00"
        }
    }


    // MARK: - Работа с CoreData
    func saveToCoreData() {
        coreDataService.deleteAllRecordsFromCoreData()
        coreDataService.saveRecords(data)
    }

    func deleteAll() {
        audioInputOutputService.stopPlayback()
        
        selectedRecord = nil
        
        for record in data {
            if FileManager.default.fileExists(atPath: record.url.path) {
                audioInputOutputService.deleteRecording(url: record.url)
            }
        }
        
        coreDataService.deleteAllRecordsFromCoreData()
        
        DispatchQueue.main.async {
            self.data = []
            self.recentDeleted = []
        }
    }

    // MARK: - Сохранение/Загрузка настроек
    func applySettings(from model: SettingsModel) {
        isPremium = model.isPremium
        apearanceIsLight = model.apearanceIsLight
        pointInCalendarVisable = model.pointInCalendarVisable
        language = model.language
        disableRecentDeleted = model.disableRecentDeleted
        delete = model.delete
        emotionInUse = model.emotionInUse
        haptics = model.haptics
    }

    func currentSettingsModel(completion: @escaping (SettingsModel) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let model = SettingsModel(
                isPremium: self.isPremium,
                apearanceIsLight: self.apearanceIsLight,
                pointInCalendarVisable: self.pointInCalendarVisable,
                language: self.language,
                disableRecentDeleted: self.disableRecentDeleted,
                delete: self.delete,
                emotionInUse: self.emotionInUse,
                haptics: self.haptics
            )
            completion(model)
        }
    }


    func saveSettings() {
        currentSettingsModel { model in
            SettingsStorageService.shared.save(model)
            print("SETTINGS")
            print("🟡 isPremium: \(self.isPremium.description)")
            print("🌕 apearanceIsLight (Светлая тема): \(self.apearanceIsLight.description)")
            print("📅 pointInCalendarVisable (Точки в календаре видимы): \(self.pointInCalendarVisable.description)")
            print("🌐 Язык интерфейса: \(self.language)")
            print("🗑️ Недавно удалённые записи: \(self.recentDeleted)")
            print("❌ disableRecentDeleted (Отключить недавно удалённые): \(self.disableRecentDeleted.description)")
            print("⏳ delete (Политика удаления): \(self.delete.rawValue)")
            print("😊 emotionInUse (Эмоции в использовании): \(self.emotionInUse)")
            print("📳 haptics (Вибрация): \(self.haptics)")
        }
    }


    func loadSettings() {
        if let loaded = SettingsStorageService.shared.load() {
            applySettings(from: loaded)
            hapticsControllerManager()
        } else {
            // дефолтные эмоции
            emotionInUse = [
                EmotionModel(isShown: true, name: "Sad", iconName: "house.fill", color: .blue),
                EmotionModel(isShown: true, name: "Fun", iconName: "house.fill", color: .green),
                EmotionModel(isShown: true, name: "Angry", iconName: "house.fill", color: .red),
                EmotionModel(isShown: true, name: "New", iconName: "house.fill", color: .cyan)
            ]
        }
    }
    
    func toggleDeleteButton(){
        withAnimation{
            showDeleteButton = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {[weak self] in
                withAnimation {
                    self?.showDeleteButton = false
                }
            }
        }
    }
    
    func changeDeletingType() {
        switch delete {
        case .days7:
            delete = .days30
        case .days30:
            delete = .days60
        case .days60:
            delete = .never
        case .never:
            delete = .days7
        }
    }
    
    func sortData(fromExistToDelete: Bool) {
        if fromExistToDelete {
            var newArr: [RecordDataModel] = []
            for item in data{
                if item.itemIsDeleted {
                    newArr.append(item)
                    removeRecordFromData(item)
                }
            }
            recentDeleted = newArr
        } else {
            for item in recentDeleted{
                data.append(item)
            }
            recentDeleted = []
        }
        
    }
    
    func removeRecordFromData(_ record: RecordDataModel) {
        var newData: [RecordDataModel] = []
        for item in data {
            if item != record {
                newData.append(item)
            }
        }
        data = newData
    }
    
    func hapticsControllerManager() {
        HapticService.instance.isAvialable = haptics
    }
}
