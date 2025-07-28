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
    @EnvironmentObject private var calendarVM: CalendarViewModel
    
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
                RecordCardView(record: record)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    
//    private func showRecordsWithSpecificEmotion(record: RecordDataModel, emotion: EmotionModel) -> (some View) {
//        ZStack{
//            if let currentEmotion = record.emotion {
//                if currentEmotion.name == emotion.name {
//                    recordsView(record: record)
//                }
//            }
//        }
//    }
}


