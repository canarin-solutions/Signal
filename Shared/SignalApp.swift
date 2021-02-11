//
//  SignalApp.swift
//  Shared
//
//  Created by Jakša Tomović on 05.12.2020..
//

import SwiftUI

@main
struct SignalApp: App {
    
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    var radioPlayer = RadioPlayer()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(radioPlayer)
        }
    }
}
