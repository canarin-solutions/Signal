//
//  SidebarView.swift
//  Signal (iOS)
//
//  Created by Jakša Tomović on 09.12.2020..
//

import SwiftUI

struct Drawer: View {
    @EnvironmentObject var radioPlayer: RadioPlayer
    
    @State var expand = false
    
    @Namespace var animation
    

    var body: some View {
        NavigationView {
            #if os(iOS)
            content
                .navigationTitle("Signal")
                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Image(systemName: "person.crop.circle")
//                    }
                }
            #else
            content
                .frame(minWidth: 200, idealWidth: 250, maxWidth: 300)
                .toolbar {
//                    ToolbarItem(placement: .automatic) {
//                        Button(action: {}) {
//                            Image(systemName: "person.crop.circle")
//                        }
//                    }
                }
            #endif
            
            
            
            
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            
                RadioView().environmentObject(radioPlayer).navigationBarHidden(true)

                
                
                if radioPlayer.radio.playerState != FRadioPlayerState.urlNotSet {
                    Miniplayer(expand: $expand, animation: animation).environmentObject(radioPlayer)
                        .adaptToKeyboard()
                }
                
            })
        }
    }
    var content: some View {
        List {
            NavigationLink(destination: RadioView().navigationBarHidden(true)) {
                Label("Radio", systemImage: "dot.radiowaves.left.and.right")
            }
        }
        .listStyle(SidebarListStyle())
    }
}
