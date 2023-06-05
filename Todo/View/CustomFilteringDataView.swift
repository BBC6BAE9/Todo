//
//  CustomFilteringDataView.swift
//  Todo
//
//  Created by ihenry on 2023/6/5.
//

import SwiftUI

struct CustomFilteringDataView<Content:View>: View {
    var content: ([Task], [Task]) -> Content
    @FetchRequest private var result: FetchedResults<Task>
    @Binding private var filterDate: Date
    
    init(filterDate:Binding<Date>, @ViewBuilder content: @escaping ([Task], [Task]) -> Content) {
        let calender = Calendar.current
        let startofDay = calender.startOfDay(for: filterDate.wrappedValue)
        let endofDay = calender.date(bySettingHour: 23, minute: 59, second: 59, of: startofDay)!
        let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startofDay, endofDay])

        _result = FetchRequest(entity: Task.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Task.date, ascending: false)], predicate: predicate, animation: .easeInOut(duration: 0.25))
        self.content = content
        self._filterDate = filterDate
    }
    
    var body: some View {
        content(seperateTasks().0, seperateTasks().1).onChange(of: filterDate) { newValue in
            result.nsPredicate = nil
            
            let calender = Calendar.current
            let startofDay = calender.startOfDay(for: newValue)
            let endofDay = calender.date(bySettingHour: 23, minute: 59, second: 59, of: startofDay)!
            let predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startofDay, endofDay])
            result.nsPredicate = predicate

        }
    }
    
    func seperateTasks() -> ([Task], [Task]) {
        let pendingTask = result.filter{!$0.isCompleted}
        let completedTask = result.filter{$0.isCompleted}
        
        return (pendingTask, completedTask)
    }
    
}

struct CustomFilteringDataView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
