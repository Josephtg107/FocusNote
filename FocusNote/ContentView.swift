//
//  ContentView.swift
//  FocusNote
//
//  Created by Joseph Garcia on 28/05/24.
//

import SwiftUI

struct MainView: View {
    @State private var showSettingsSheet = false
    @State private var showOptionsSheet = false

    var body: some View {
        TabView {
            InboxView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inbox")
                }

            Text("Search Content")
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            Text("Notifications Content")
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }

            Text("Profile Content")
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct InboxView: View {
    @State private var showSettingsSheet = false
    @State private var showOptionsSheet = false
    @State private var quote: String = "Loading..."
    @State private var dailyTasks: [String] = ["Complete SwiftUI tutorial", "Plan the app layout", "Write code for Pomodoro timer"]

    let quoteManager = QuoteManager() // Create an instance of QuoteManager

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack {
                    Text(quote)
                        .padding()
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .onAppear {
                            // Call loadQuote method when the view appears
                            quoteManager.loadQuote { fetchedQuote in
                                self.quote = fetchedQuote
                            }
                        }
                }

                // Middle Section: Task Summary
                VStack(alignment: .leading) {
                    Text("Today's Tasks")
                        .font(.headline)
                    ForEach(dailyTasks, id: \.self) { task in
                        HStack {
                            Text(task)
                            Spacer()
                            Button(action: {
                                // Add action to mark task as complete
                            }) {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                Spacer()
            }
            .navigationTitle("Today")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showSettingsSheet.toggle()
                    }) {
                        Image(systemName: "gear")
                    }
                    .sheet(isPresented: $showSettingsSheet) {
                        NavigationView {
                            SettingsView()
                                .navigationBarTitle("Settings", displayMode: .inline)
                                .navigationBarItems(trailing: Button("Done") {
                                    showSettingsSheet = false
                                })
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showOptionsSheet.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                    }
                    .sheet(isPresented: $showOptionsSheet) {
                        NavigationView {
                            OptionsView()
                                .navigationBarTitle("Options", displayMode: .inline)
                                .navigationBarItems(trailing: Button("Done") {
                                    showOptionsSheet = false
                                })
                        }
                    }
                }
            }
        }
    }
}


struct SettingsView: View {
    var body: some View {
        Text("Settings Content")
    }
}

struct OptionsView: View {
    var body: some View {
        Text("Options Content")
    }
}

#Preview(body: {
    MainView()
})


// Bottom Section: Focus Timer and Stats
//VStack {
//    Text("Focus Timer")
//        .font(.headline)
//    // Add Timer View here
//    Text("00:00")
//        .font(.largeTitle)
//        .padding()
//
//    // Add Daily Stats View here
//    Text("Pomodoro Sessions: 3")
//        .font(.subheadline)
//}
//.padding()


