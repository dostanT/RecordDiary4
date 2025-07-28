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
    //VMs
    @Environment(\.router) var router
    @EnvironmentObject private var settingsVM: SettingsViewModel
    @StateObject private var calendarVM = CalendarViewModel()
    
    @Binding var selectedDate: Date
    @State private var selectedEmotion: EmotionModel? = nil
    
    @Namespace private var namespace
    
    @State private var showSheet: Bool = false
    @State private var showCalendar: Bool = false
    
    var body: some View {
        ZStack{
            ColorTheme.white.color.ignoresSafeArea()
            VStack(spacing: 0) {
                VStack(spacing: 20){
                    monthNavigationView
                    
                    if showCalendar{
                        calendarGridView
                            .opacity(showCalendar ? 1 : 0)
                    }
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
                            SettingsView(calendarVM: calendarVM)
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
                calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate, inMouth: showCalendar)
                calendarVM.currentMonth = selectedDate
            }
        }
        .sheet(isPresented: $showSheet) {
            CalendarPickerSheetView(selectedDate: selectedDate, changableDate: $selectedDate, showSheet: $showSheet){
                calendarVM.currentMonth = selectedDate
                calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: selectedEmotion, shownDate: selectedDate, inMouth: showCalendar)
            }
            .presentationDetents([.height(UIScreen.main.bounds.height * 45/100)])
            .presentationDragIndicator(.visible)
            .interactiveDismissDisabled(true)
        }

    }
   
}



extension CalendarView {
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
                    calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate, inMouth: showCalendar)
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
                        calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: emotion, shownDate: selectedDate, inMouth: showCalendar)
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
                    calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate, inMouth: showCalendar)
                }
                ForEach(settingsVM.emotionInUse) { emotion in
                    SortingView(name: emotion.name, isPressed: selectedEmotion?.name == emotion.name) {
                        selectedEmotion = emotion
                        calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: emotion, shownDate: selectedDate, inMouth: showCalendar)
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
                    withAnimation(.spring()) {
                        showCalendar = true
                    }
                }
            
            Spacer()
            
            Text(calendarVM.getMonthYearString())
                .pinkBorderedAndCozyImageTextButtonModifierLongPress(fontSize: 24) {
                    withAnimation(.spring()) {
                        showCalendar.toggle()
                    }
                    calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: selectedEmotion, shownDate: selectedDate, inMouth: showCalendar)
                } onLongTap: {
                    showSheet = true
                }

            
            Spacer()
            
            Image(systemName: "chevron.right")
                .pinkBorderedAndCozyTextModifier {
                    calendarVM.nextMonth()
                    withAnimation(.spring()) {
                        showCalendar = true
                    }
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
                            isSelected: Calendar.current.isDate(calendarDate.date, inSameDayAs: selectedDate), dotsAreVisible: settingsVM.pointInCalendarVisable,
                        )
                        .onTapGesture {
                            if selectedDate == calendarDate.date {
                                router.dismissScreen()
                            } else {
                                selectedDate = calendarDate.date
                                calendarVM.filterRecordsWithEmotion(records: settingsVM.data, emotion: nil, shownDate: selectedDate, inMouth: showCalendar)
                                
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
                            .customAndCozyTextModifier(fontSize: 20, color: record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        if let emotion = record.emotion {
                            Text(emotion.name)
                                .customAndCozyTextModifier(fontSize: 20, color: record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        }
                        
                    }
                    
                    
                    Spacer()
                    
                    VStack{
                        Button("Check"){
                            settingsVM.data[0].deletedDay = Date()
                        }
                        DurationTextView(record: record)
                    }
                }
                .padding(.horizontal)
                .padding(2)
                if calendarVM.selectedRecord == record {
                    VStack{
                        
                        //Slider
                        
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
                            } else {
                                Image(systemName: "play.fill")
                            }
                            
                        }
                        .font(.title2)
                        .foregroundStyle(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                        .padding(2)
                        .transition(.move(edge: .top))
                        
                    }
                }
                
            }
            .background(ColorTheme.white.color)
            .padding(2)
            .background(record.emotion?.color.color ?? Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
            .onTapGesture {
                if calendarVM.selectedRecord == record  {
                    calendarVM.selectedRecord = nil
                } else {
                    calendarVM.selectedRecord = record
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
