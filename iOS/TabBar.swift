//
//  TabBar.swift
//  AppleMusic
//
//  Created by Balaji on 16/11/20.
//

import SwiftUI

struct TabBar: View {
    @EnvironmentObject var radioPlayer: RadioPlayer

    @State var current = 0
    @State var expand = false
    
    @Namespace var animation
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            
            TabView(selection: $current){
                RadioView().environmentObject(radioPlayer)
                    .tabItem {
                        Image(systemName: "dot.radiowaves.left.and.right")
                        Text("Radio")
                    }
            }.foregroundColor(Color.primary)
            
            if radioPlayer.radio.playerState != FRadioPlayerState.urlNotSet {
                Miniplayer(expand: $expand, animation: animation).environmentObject(radioPlayer)
                    .adaptToKeyboard()
            }
        })
    }
}
