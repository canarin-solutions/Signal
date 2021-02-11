//
//  AppDelegate.swift
//  Signal (macOS)
//
//  Created by Jakša Tomović on 17.12.2020..
//

import SwiftUI
import CoreData

class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover.init()
    var statusBar: StatusBarController?
    
    
    var radioPlayer = RadioPlayer()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        // Create the SwiftUI view that provides the contents
        let contentView = HomeView().environmentObject(radioPlayer)
        
        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentViewController = NSViewController()
        popover.contentSize = NSSize(width: 400, height: 600)
        popover.contentViewController?.view = NSHostingView(rootView: contentView)

        // Create the Status Bar Item with the Popover
        statusBar = StatusBarController.init(popover)
    }
}
