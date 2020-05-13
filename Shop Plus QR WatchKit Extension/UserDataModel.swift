//
//  UserDataModel.swift
//  Shop Plus QR WatchKit Extension
//
//  Created by Dawid Dydliński on 13/05/2020.
//  Copyright © 2020 Dawid Dydliński. All rights reserved.
//

import Foundation
import SwiftUI

class UserDataModel: ObservableObject {
    
    @Published var id: String = UserDefaults.standard.string(forKey: "id") ?? "" {
        didSet {
            UserDefaults.standard.setValue(self.id, forKey: "id")
        }
    }
    
    public static var Instance = UserDataModel();
}
