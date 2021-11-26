//
//  testApp.swift
//  test
//
//  Created by Khairul Anshar on 26/11/21.
//

import SwiftUI

@main
struct testApp: App {
    @State var title: String = ""
    @State var error: Error? = nil
    var body: some Scene {
        WindowGroup {
            WebView(title: $title, url: URL(string: "http://localhost:3000/")!)
                            .onLoadStatusChanged { loading, error in
                                if loading {
                                    self.title = "Loading…"
                                }
                                else {
                                    if let error = error {
                                        self.error = error
                                        if self.title.isEmpty {
                                            self.title = "Error"
                                        }
                                    }
                                    else if self.title.isEmpty {
                                        self.title = "Some Place"
                                    }
                                }
                        }
                        .navigationBarTitle(title)
        }
    }
}



