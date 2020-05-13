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
       VStack {
            if userData.id.count == 0 {
                Text("Enter your ID")
                    
                TextField("Your Plus ID", text: $id)
                    .padding()
                    .multilineTextAlignment(TextAlignment.center)
                    .keyboardType(.numberPad)

                Button(action: {
                    
                self.userData.id = self.id
                self.sendMessage()
                    
                }, label: {
                    Text("Generate QR Code")
                }).padding()
                    .disabled(self.id.isEmpty || self.id.count < 17 || self.id.count > 17)
            } else {
                Text("Your Plus ID is \(userData.id)")
                Image(decorative: generateQrCode(id: self.userData.id), scale: 2.0)
                    
                Button(action: {
                    self.userData.id = ""
                }, label: {
                    Text("Change your ID")
                }).padding()
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
