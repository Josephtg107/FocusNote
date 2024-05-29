//
//  CarouselView.swift
//  FocusNote
//
//  Created by Joseph Garcia on 29/05/24.
//

import SwiftUI

struct PageView: View {
    let page: Page

    var body: some View {
        Text("\(page.number)")
            .font(.largeTitle)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .padding()
            .foregroundColor(.white)
    }
}

struct CarouselView: View {
    @State private var currentIndex = 1 // Start at 1 to handle infinite loop logic
    let pages: [Page]
    private let infinitePages: [Page]

    init(pages: [Page]) {
        self.pages = pages
        // Add first and last pages to the start and end to simulate infinite scrolling
        self.infinitePages = [pages.last!] + pages + [pages.first!]
    }

    var body: some View {
        TabView(selection: $currentIndex) {
            ForEach(infinitePages.indices, id: \.self) { index in
                PageView(page: infinitePages[index])
                    .tag(index)
                    .frame(width: UIScreen.main.bounds.width, height: 200)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .onChange(of: currentIndex) { newIndex in
            if newIndex == 0 {
                // If moved to the 'extra' first page, move to the real last page
                self.currentIndex = infinitePages.count - 2
            } else if newIndex == infinitePages.count - 1 {
                // If moved to the 'extra' last page, move to the real first page
                self.currentIndex = 1
            }
        }
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never)) // Hide the page indicator
    }
}

struct Page: Identifiable, Equatable {
    let id = UUID()
    let number: Int
}

let pages = [
    Page(number: 1),
    Page(number: 2),
    Page(number: 3),
    Page(number: 4),
    Page(number: 5),
    Page(number: 6)
]

struct ContentView: View {
    var body: some View {
        CarouselView(pages: pages)
    }
}

#Preview(body: {
    ContentView()
})
