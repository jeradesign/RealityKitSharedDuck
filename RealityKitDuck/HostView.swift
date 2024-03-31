//
//  HostView.swift
//  RealityKitDuck
//
//  Created by John Brewer on 3/30/24.
//

import SwiftUI

struct HostView: View {
    @State var session = DuckChatMultipeerSession(displayName: "NotADuck")
    @State var text: String = ""
    @State var message: String = ""
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 20)
            Text("Host")
                .font(.title)
            TextEditor(text: $session.messageLog)
            HStack {
                TextField("Your message", text: $message)
                Button("Send") {
                    session.sendMessage(message: message)
                    message = ""
                }
            }
            Spacer()
                .frame(height: 20)
        }.padding(20)
        
    }
}

#Preview {
    HostView()
}
