//
//  testApp.swift
//  test
//
//  Created by Khairul Anshar on 26/11/21.
//

import SwiftUI

@main
struct bridgeApp: App {
    @State var title: String = "www"
    @State var error: Error? = nil
    var body: some Scene {
        WindowGroup {
            let url = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "www")!
            WebView(title: $title, url: url)
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



