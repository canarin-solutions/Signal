//
//  ContentView.swift
//  Shared
//
//  Created by Jakša Tomović on 05.12.2020..
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var radioPlayer: RadioPlayer

    var body: some View {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .phone
        {
            TabBar().environmentObject(radioPlayer)
        }
        else
        {
            Drawer().environmentObject(radioPlayer)
        }
        #endif
    }
}
