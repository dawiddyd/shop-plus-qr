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
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
