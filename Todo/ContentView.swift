//
//  ContentView.swift
//  Todo
//
//  Created by ihenry on 2023/6/5.
//

import SwiftUI

struct ContentView: View {
    var body: some View{
        NavigationStack{
            Home().navigationTitle("Get things done")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
