//
//  AlertData.swift
//  unsplash_test
//
//  Created by George Tevosov on 17.05.2022.
//

import Foundation
import SwiftUI
struct AlertData {
    let title: Text
    let message: Text?
    let dismissButton: Alert.Button?
    
    static let empty = AlertData(title: Text(""), message: nil, dismissButton: nil)
}
