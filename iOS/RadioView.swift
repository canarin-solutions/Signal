//
//  Search.swift
//  AppleMusic
//
//  Created by Balaji on 16/11/20.
//

import SwiftUI

struct RadioView: View {
    @EnvironmentObject var radioPlayer: RadioPlayer
    @ObservedObject var monitor = NetworkMonitor()

    @State private var showAlertSheet =  false
    
    
    @State var expand = false
    @State var searchText = ""
    
    @State var show = false
    
    @Namespace var animation
    
    @State var colums = Array(repeating: GridItem(.flexible(), spacing: 20), count: 1)
    
    var body: some View {
        
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            
            if !monitor.isConnected {
                Image(systemName: "wifi.slash").font(.system(.title)).padding(.all).padding(.top, 40)
            } else if radioPlayer.stations.isEmpty
            {
                Image(systemName: "slash.circle").font(.system(.title)).padding(.all).padding(.top, 40)
            }
            else
            {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(){
                        GeometryReader{reader -> AnyView in
            
                            let y = reader.frame(in: .global).minY + 80
                            
                            if y < 0{
                                withAnimation(.linear){ show = true}
                            }
                            else{
                                withAnimation(.linear){show = false}
                            }
                            
                            return AnyView(
                                
                                VStack(spacing: 18){
                                    
                                    HStack{
                                        
                                        Text("Stations")
                                            .font(.largeTitle)
                                            .fontWeight(.heavy)
                                            .foregroundColor(.primary)
                                        
                                        Spacer(minLength: 0)
                                        
                                        Button(action: {
                                            let num = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
                                            if colums.count == num {colums.removeLast()}
                                            else{colums.append(GridItem(.flexible(), spacing: 15))}
                                        }) {
                                            
                                            Image(systemName: colums.count == 2 ? "rectangle.grid.1x2" : "rectangle.3.offgrid")
                                                .font(.title2)
                                                .foregroundColor(Color.secondary)
                                        }
                                    }
                                    
                                    HStack(spacing: 15){
                                        
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.primary)
                                        
                                        TextField("Search", text: $searchText)
                                    }.padding(.vertical,10)
                                    .padding(.horizontal)
                                    .background(Color.primary.opacity(0.06))
                                    .cornerRadius(15)
                                }.padding(.vertical,UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0 + 20)
                            )
                        }
                        .frame(height: 130)
                        
                        LazyVGrid(columns: colums,spacing: 20){
                            ForEach(radioPlayer.stations.indices.filter { radioPlayer.stations[$0].name.containsIgnoringCase(find: searchText) || searchText.isEmpty }, id: \.self) { index in
                                Button(action: {
                                    radioPlayer.currentIndex = index
                                }) {
                                    StationView(columns: $colums).environmentObject(radioPlayer.stations[index])
                                }
                            }
                        }
                        .padding(.top, 30)
                    
                    }.padding()
                }.padding(.bottom, radioPlayer.radio.playerState != FRadioPlayerState.urlNotSet ? 80 : 0)
          
                HStack(spacing: 15){
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.primary)
                        
                        TextField("Search", text: $searchText)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.secondary.opacity(0.06))
                    .cornerRadius(15)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {
                        let num = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 4
                        if colums.count == num {colums.removeLast()}
                        else{colums.append(GridItem(.flexible(), spacing: 15))}
                    }) {
                        
                        Image(systemName: colums.count == 2 ? "rectangle.grid.1x2" : "rectangle.3.offgrid")
                            .font(.title2)
                            .foregroundColor(Color.secondary)
                    }
                }
                .padding([.horizontal,.bottom])
                .padding(.top,UIApplication.shared.windows.first?.safeAreaInsets.top)
                .background(BlurView(style: .systemMaterial))
                .opacity(show ? 1 : 0)
            }
        })
        .ignoresSafeArea(.all, edges: .top)
        .dismissKeyboardOnSwipe()
        .dismissKeyboardOnTap()
    }
}
