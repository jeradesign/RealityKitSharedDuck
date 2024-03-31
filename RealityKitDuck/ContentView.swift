//
//  ContentView.swift
//  RealityKitDuck
//
//  Created by John Brewer on 3/30/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {

    enum ViewState {
        case initial
        case host
        case join
    }
    
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var viewState: ViewState = .initial
    
    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    var body: some View {
        switch viewState {
        case .initial:
            VStack {
                Model3D(named: "Little Duck Scene", bundle: realityKitContentBundle)
                    .padding(.bottom, 50)
                
                Text("RealityKit Shared Duck")
                    .font(.title)
                    .padding(.bottom, 75)
                
                HStack {
                    Button {
                        viewState = .host
                    } label: {
                        Text("Host")
                    }
                    .padding(.trailing, 75)
                    
                    Button {
                        viewState = .join
                    } label: {
                        Text("Join")
                    }                }
                
                //            Toggle("Show ImmersiveSpace", isOn: $showImmersiveSpace)
                //                .font(.title)
                //                .frame(width: 360)
                //                .padding(24)
                //                .glassBackgroundEffect()
            }
            .padding()

        case .host:
            HostView()
        case .join:
            JoinView()
        }
//        .onChange(of: showImmersiveSpace) { _, newValue in
//            Task {
//                if newValue {
//                    switch await openImmersiveSpace(id: "ImmersiveSpace") {
//                    case .opened:
//                        immersiveSpaceIsShown = true
//                    case .error, .userCancelled:
//                        fallthrough
//                    @unknown default:
//                        immersiveSpaceIsShown = false
//                        showImmersiveSpace = false
//                    }
//                } else if immersiveSpaceIsShown {
//                    await dismissImmersiveSpace()
//                    immersiveSpaceIsShown = false
//                }
//            }
//        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
