//
//  ContentView.swift
//  Shop Plus QR
//
//  Created by Dawid Dydliński on 13/05/2020.
//  Copyright © 2020 Dawid Dydliński. All rights reserved.
//

import SwiftUI
import WatchConnectivity
import EFQRCode

struct ContentView: View {
    
    @ObservedObject var userData: UserDataModel = UserDataModel.Instance;
      
    @State var id: String = ""
    
    func generateQrCode(id: String) -> CGImage {
        return EFQRCode.generate(content: id)!
    }
    
    func sendMessage() {
        guard WCSession.default.isReachable else { return }

        WCSession.default.sendMessage(
            ["id": String(self.userData.id)],
            replyHandler: { reply in print(reply) },
            errorHandler: { e in
//                print("Error sending the message: \(e.localizedDescription)")
                Alert(title: Text("Error sending the message"),
                      message: Text(e.localizedDescription),
                      dismissButton: .default(Text("Close")))
        })
    }
    
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
