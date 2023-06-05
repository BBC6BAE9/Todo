//
//  Home.swift
//  Todo
//
//  Created by ihenry on 2023/6/5.
//

import SwiftUI

struct Home: View {
    @Environment(\.self) private var env
    @State private var filterDate:Date = .init()
    @State private var showPendingTasks:Bool = true
    @State private var showCompletedTasks:Bool = true

    var body: some View {
        List{
            DatePicker(selection: $filterDate, displayedComponents: [.date]){
                
            }
            .labelsHidden()
            .datePickerStyle(.graphical)
            
            DisclosureGroup(isExpanded: $showPendingTasks) {
                // Custom Core Data Filter View, which will display pending task on this Day
                CustomFilteringDataView(displayPendingTask: true, filterDate: filterDate) {
                    TaskRow(task: $0, isPendingTask: true)
                }
            } label: {
                Text("Pending Task's")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            DisclosureGroup(isExpanded: $showCompletedTasks) {
                // Custom Core Data Filter View, which will display completed task on this Day
                CustomFilteringDataView(displayPendingTask: false, filterDate: filterDate) {
                    TaskRow(task: $0, isPendingTask: false)
                }
            } label: {
                Text("Pending Task's")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }.toolbar {
            Button {
                /// Simply opening Pending task View
                /// Then add an empty task
                let
            } label: {
                HStack{
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                    Text("New Task")
                }
                .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct TaskRow:View {
    var task: Task
    var isPendingTask: Bool
    
    @Environment(\.self) private var env
    @FocusState private var showKeyboard: Bool
    var body: some View {
        HStack(spacing: 12){
            Button {
                
            } label: {
                Image(systemName: task.isCompleted ? "checkmaek.circle.fill" : "circle")
                    .font(.title)
                    .foregroundColor(.blue)
                VStack(alignment:.leading, spacing: 4) {
                    TextField("Task Title", text: .init(get: {
                        return task.title ?? ""
                    }, set: { value in
                        task.title = value
                    }))
                    .focused($showKeyboard)
                    .onSubmit {
                        removeEmptyTask()
                        save()
                    }
                }
                
                DatePicker(selection: .init(get: {
                    return task.date ?? .init()
                }, set: { value in
                    task.date = value
                    save()
                }), displayedComponents: [.hourAndMinute]) {
                    
                }
                .labelsHidden()
            }
            .onAppear{
                if (task.title ?? "").isEmpty{
                    showKeyboard = true
                }
            }
            .onChange(of: env.scenePhase) { newValue in
                if (newValue != .active){
                    removeEmptyTask()
                    save()
                }
            }
        }
    }
    
    func save(){
        do {
            try env.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeEmptyTask() {
        // 检查是否为空
        if (task.title ?? "").isEmpty{
            env.managedObjectContext.delete(task)
        }
    }
}
