//
//  CreditCard_AnimationApp.swift
//  CreditCard-Animation
//
//  Created by MacMini6 on 10/03/25.
//

import SwiftUI
import RealmSwift
@main
struct CreditCard_AnimationApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                print("Realm location: \(Realm.Configuration.defaultConfiguration.fileURL!)")
            }
        }
    }
}
