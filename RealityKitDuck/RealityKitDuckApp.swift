//
//  RealityKitDuckApp.swift
//  RealityKitDuck
//
//  Created by John Brewer on 3/30/24.
//

import SwiftUI

@main
struct RealityKitDuckApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
