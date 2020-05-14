//
//  ContentView.swift
//  Shop Plus QR WatchKit Extension
//
//  Created by Dawid Dydliński on 13/05/2020.
//  Copyright © 2020 Dawid Dydliński. All rights reserved.
//

import SwiftUI
import EFQRCode

struct ContentView: View {
    
    @ObservedObject var userData: UserDataModel = UserDataModel.Instance;
       
    func generateQrCode(id: String) -> CGImage {
        return EFQRCode.generate(content: id)!
    }
    
    var body: some View {
         VStack {
            if userData.id.count > 0 {
                Text("Your ID: \(self.userData.id)")
                Image(decorative: generateQrCode(id: self.userData.id), scale: 4.2)
            } else {
                Text("Open the application to generate a QR code")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
