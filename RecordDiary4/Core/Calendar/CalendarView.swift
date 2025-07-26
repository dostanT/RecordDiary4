//
//  CalendarView.swift
//  RecordDiary
//
//  Created by Dostan Turlybek on 13.07.2025.
//
import SwiftUI
import SwiftfulRouting
import Combine

struct CalendarView: View {
    @Environment(\.router) var router
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @StateObject private var calendarVM = CalendarViewModel()
    @Binding var selectedDate: Date
    @State private var selectedEmotion: EmotionModel? = nil
    @Namespace private var namespace
    
    
    var body: some View {
        ZStack{
            ColorTheme.white.color.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 20){
                    monthNavigationView
                    
                    calendarGridView
                }
                VStack(spacing: 20){
                    selectedViewNEW
                    
                    recordsListView
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        router.showScreen { router in
                            SettingsView()
                        }
                    } label: {
                        Image(systemName: "gear")
                    }
                    .font(.headline)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .playbackFinished)) { _ in
                settingsVM.selectedRecord = nil
            }
            .onAppear {
                calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate)
                calendarVM.currentMonth = selectedDate
            }
        }
        .preferredColorScheme(settingsVM.apearanceIsLight ? .light : .dark)
    }
    
    private var selectedViewOLD: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                VStack{
                    Text("All")
                        .foregroundColor(selectedEmotion == nil ? ColorTheme.black.color : ColorTheme.pink.color)
                    
                    if selectedEmotion == nil {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(ColorTheme.blue.color)
                            .matchedGeometryEffect(id: "category_background", in: namespace)
                            .frame(width: 35, height: 2)
                            .offset(y: 4)
                    } else {
                        Color.clear.frame(height: 2)
                    }
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedEmotion = nil
                    }
                    calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate)
                }
                ForEach(settingsVM.emotionInUse) { emotion in
                    VStack {
                        Text(emotion.name)
                            .foregroundColor(selectedEmotion?.name == emotion.name ? emotion.color.color : ColorTheme.pink.color)

                        if selectedEmotion?.name == emotion.name {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(emotion.color.color)
                                .matchedGeometryEffect(id: "category_background", in: namespace)
                                .frame(width: 35, height: 2)
                                .offset(y: 4)
                        } else {
                            Color.clear.frame(height: 2)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedEmotion = emotion
                        }
                        calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: emotion, shownDate: selectedDate)
                    }
                }
            }
            .padding(.horizontal)
            .frame(height: 55)
        }
    }
    
    private var selectedViewNEW: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                SortingView(name: "All", isPressed: selectedEmotion == nil) {
                    selectedEmotion = nil
                    calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate)
                }
                ForEach(settingsVM.emotionInUse) { emotion in
                    SortingView(name: emotion.name, isPressed: selectedEmotion?.name == emotion.name) {
                        selectedEmotion = emotion
                        calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: emotion, shownDate: selectedDate)
                    }
                }
            }
            .padding()
        }
    }
    
    private var monthNavigationView: some View {
        HStack {
            Image(systemName: "chevron.left")
                .pinkBorderedAndCozyTextModifier {
                    calendarVM.previousMonth()
                }
            
            Spacer()
            
            Text(calendarVM.getMonthYearString())
                .pinkBorderedAndCozyTextModifier(fontSize: 25) {
                    router.showScreen(.sheet) { router in
                        CalendarPickerSheetView(selectedDate: selectedDate, changableDate: $selectedDate){
                            calendarVM.currentMonth = selectedDate
                        }
                    }
                }
                
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .pinkBorderedAndCozyTextModifier {
                    calendarVM.nextMonth()
                }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
    
    private var calendarGridView: some View {
        VStack(spacing: 0) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(calendarVM.getWeekDays(), id: \.self) { day in
                    Text(day)
                        .whiteAndCozyTextModifier(fontSize: 20)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                }
            }
            .background(ColorTheme.pink.color)
            ZStack(alignment: .top){
                Rectangle()
                    .frame(height: 250)
                    .foregroundStyle(Color.clear)
                // Calendar grid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 0) {
                    ForEach(calendarVM.getDaysInMonth()) { calendarDate in
                        DayCellView(
                            calendarDate: calendarDate,
                            records: calendarVM.getPointFromRecords(data: settingsVM.data, selectedDate: calendarDate.date),
                            isSelected: Calendar.current.isDate(calendarDate.date, inSameDayAs: selectedDate),
                        )
                        .onTapGesture {
                            if selectedDate == calendarDate.date {
                                router.dismissScreen()
                            } else {
                                selectedDate = calendarDate.date
                                calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    private var recordsListView: some View {
        ScrollView{
            ForEach(calendarVM.shownRecordsAfterFiltering) { record in
                recordsView(record: record)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func recordsView(record: RecordDataModel) -> (some View) {
        ZStack{
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text(record.createdDate.getFormattedHourMinutesAMPM())
                            .foregroundStyle(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        if let emotion = record.emotion {
                            Text(emotion.name)
                                .foregroundStyle(emotion.color.color)
                        }
                        
                    }
                    .padding(.leading)
                    Spacer()
                    
                }
                if calendarVM.selectedRecord == record {
                    Button {
                        if let selectedRecord = settingsVM.selectedRecord {
                            if selectedRecord.url == record.url {
                                settingsVM.audioInputOutputService.stopPlayback()
                                settingsVM.selectedRecord = nil
                            } else {
                                settingsVM.changeAudioPlaying(chosenRecord: record)
                            }
                        }
                        else {
                            settingsVM.audioInputOutputService.playRecording(url: record.url) { success in
                                if success {
                                    settingsVM.selectedRecord = record
                                }
                            }
                        }
                    } label: {
                        if let selectedRecord = settingsVM.selectedRecord  {
                            Image(systemName: selectedRecord.url == record.url ? "stop.fill" : "play.fill")
                                .font(.title2)
                                .foregroundStyle(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        } else {
                            Image(systemName: "play.fill")
                                .font(.title2)
                                .foregroundStyle(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        }
                        
                    }
                    .transition(.move(edge: .top))
                    
                }
                
            }
            .background(ColorTheme.white.color)
            .padding(2)
            .background(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            .onTapGesture {
                withAnimation(.spring(duration: 0.3)) {
                    if calendarVM.selectedRecord == record  {
                        calendarVM.selectedRecord = nil
                    } else {
                        calendarVM.selectedRecord = record
                    }
                }
            }
            
            
        }
        .padding(.horizontal)
    }
    
    private func showRecordsWithSpecificEmotion(record: RecordDataModel, emotion: EmotionModel) -> (some View) {
        ZStack{
            if let currentEmotion = record.emotion {
                if currentEmotion.name == emotion.name {
                    recordsView(record: record)
                }
            }
        }
    }
}
