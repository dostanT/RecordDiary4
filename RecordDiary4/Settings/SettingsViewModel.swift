//
//  SettingsView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 11.07.2025.
//
import Foundation
import Combine

class SettingsViewModel: ObservableObject{
    //Settigns
    @Published var isPremium: Bool = false
    @Published var apearanceIsLight: Bool = false
    @Published var emotion: [EmotionModel] = []
    @Published var pointInCalendarVisable: Bool = true
    @Published var language: String = "ENG"
    @Published var recentDeleted: [RecordDataModel] = []
    @Published var disableRecentDeleted: Bool = false
    @Published var delete: DeletingType = .days7
    
    @Published var isRecording: Bool = false
    @Published var selectedEmotion: EmotionModel? = nil
    
    @Published var isPlayRecord: Bool = false
    @Published var selectedRecord: RecordDataModel? = nil
    
    
    let audioInputOutputService = AudioInputOutputService()
    
    let coreDataService = CoreDateService()
    var cancellables: Set<AnyCancellable> = []
    
    //Они видны на экране. И при нажатии на них будет создоватся новые RecordDataModel
    @Published var emotionInUse: [EmotionModel] = [
        EmotionModel(
            isShown: true, name: "Sad1",
            iconName: "house.fill",
            color: ColorTheme.blue),
        EmotionModel(
            isShown: true, name: "Sad2",
            iconName: "house.fill",
            color: ColorTheme.green),
        EmotionModel(
            isShown: true, name: "Sad3",
            iconName: "house.fill",
            color: ColorTheme.red),
        EmotionModel(
            isShown: true, name: "Sad4",
            iconName: "house.fill",
            color: ColorTheme.cyan),
    ]
    
    //Уже общая корзина по ней будет сортировка по дням. C CoreData будет скачивать постепенно если перешел ко дню что бы не нагружать приложение
    @Published var data: [RecordDataModel] = [
        
    ]
    
    enum DeletingType: String, CaseIterable {
        case days7 = "days7"
        case days30 = "days30"
        case days60 = "days60"
        case never = "never"
    }
    
    init() {
        addSubscibers()
    }
    
    func addSubscibers() {
        print("Start to subscribe from data manager")
        coreDataService.$saved
            .receive(on: DispatchQueue.main)
            .sink { [weak self] returnedData in
                if !returnedData.isEmpty{
                    self?.data = self?.audioInputOutputService.giveEmotionsForRecordsWithoutEmotions(recordsLocal: returnedData) ?? []
                }
//                self?.data = returnedData
            }
            .store(in: &cancellables)
        print("Finish to subscribe from data manager")
    }
    
    func startRecording(selectedEmotion: EmotionModel) {
        isRecording = true
        if emotionInUse.isEmpty {
            print("ERROR: startRecording in SettingsViewModel emotionInUse.isEmpty")
            return
        }
        self.selectedEmotion = selectedEmotion
        audioInputOutputService.startRecording(emotion: selectedEmotion)
    }
    
    func stopRecording(showDate: Date) {
        isRecording = false
        guard let record = audioInputOutputService.stopRecording(shownDate: showDate) else {return}
        data.append(record)
        selectedEmotion = nil
    }
    
    func changeAudioPlaying(chosenRecord: RecordDataModel) {
        guard let selectedRecord = selectedRecord else {return}
        
        if selectedRecord.id == chosenRecord.id {
            print("ERROR: Selected record is the same with the one that is chosen")
            return
        }
        
        audioInputOutputService.stopPlayback()
        self.selectedRecord = nil
        
        audioInputOutputService.playRecording(url: chosenRecord.url) { success in
            self.selectedRecord = chosenRecord
        }
    }
    
    func saveToCoreData() {
        print("Start saving to CoreData")
        self.coreDataService.deleteAllRecordsFromCoreData()
        self.coreDataService.saveRecords(self.data)
        print("Finished saving to CoreData")
    }
    
    func deleteAll() {
        audioInputOutputService.deleteAllRecordings(data: data)
        coreDataService.deleteAllRecordsFromCoreData()
        data = []
    }
}
