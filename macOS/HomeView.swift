//
//  Home.swift
//  Pinterest (iOS)
//
//  Created by Balaji on 06/12/20.
//

import SwiftUI
import SDWebImageSwiftUI
import Network

struct HomeView: View {
    @EnvironmentObject var radioPlayer: RadioPlayer
    
    @ObservedObject var monitor = NetworkMonitor()

    @State var searchText = ""
    @State var isAnimating: Bool = false
    @State var currentIndex: Int = 0
    @State var selected = "dot.radiowaves.left.and.right"
    
    @Namespace var animation
    
    
    var window = NSScreen.main?.visibleFrame
    var columns = Array(repeating: GridItem(.flexible(), spacing: 20), count: 2)
    
    var body: some View {
        
        HStack{
                        
            VStack{
                
                HStack{
                    
                    Text("Signal")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundColor(Color(NSColor.systemGray))
                    
                    Spacer()
                    
                    HStack(spacing: 15){
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(NSColor.systemGray))
                        
                        TextField("Search", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .frame(width: 100, height: 20)
                    }
                    .padding(.vertical,5)
                    .padding(.horizontal)
                    .background(BlurWindow())
                    .cornerRadius(10)
                    
//                    Spacer()

                    Button(action: {
                        NSApplication.shared.terminate(self)
                    })
                    {
                        Image(systemName: "power")
                            .foregroundColor(Color(NSColor.labelColor))
                    }.buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical)
                .padding(.leading,10)
                .padding(.trailing)
                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 5)
                
                HStack{
                    
                    TabButton(image: "dot.radiowaves.left.and.right", selected: $selected, animation: animation)
//                    TabButton(image: "heart.fill", selected: $selected, animation: animation)
                }
                
                if !monitor.isConnected
                {
                    Image(systemName: "wifi.slash").font(.system(.title)).padding(.all).padding(.top, 40)
                }
                else if radioPlayer.stations.isEmpty
                {
                    Image(systemName: "slash.circle").font(.system(.title)).padding(.all).padding(.top, 40)
                }
                else
                {
                    if selected == "dot.radiowaves.left.and.right" {
                        GeometryReader {reader in
                            ScrollView{
                                
                                LazyVGrid(columns: columns,spacing: 15 ,content: {
                                    
                                    ForEach(radioPlayer.stations.indices.filter { radioPlayer.stations[$0].name.containsIgnoringCase(find: searchText) || searchText.isEmpty }, id: \.self) { index in
                                        ZStack {
                                            VStack{
                                                ZStack{
                                                    WebImage(url: URL(string: radioPlayer.stations[index].imageURL))
                                                        .placeholder(content: {
                                                            ProgressView().foregroundColor(.black)
                                                        })
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fill)
                                                        .frame(width: (reader.frame(in: .global).width - 45) / 2, height: 150)
                                                        .cornerRadius(15)
                                                }
                                                
                                                Text(radioPlayer.stations[index].name)
                                                    .lineLimit(1)
                                            }
                                        }
                                        .onTapGesture {
                                            radioPlayer.currentIndex = index
                                            currentIndex = index
                                        }
                                    }
                                })
                                .padding(.vertical)
                            }
                        }
                    }
                    else
                    {
                       // do nothing for now
                    }
                }
                    
                Spacer()
                    
                if radioPlayer.radio.playerState != FRadioPlayerState.urlNotSet {
                    
                    Spacer(minLength: 0)
                                        
                    HStack(spacing: 10){
                        
                        Image(nsImage: radioPlayer.radio.track.image ?? #imageLiteral(resourceName: "albumArt")).renderingMode(Image.TemplateRenderingMode?.init(Image.TemplateRenderingMode.original))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                        
                        Spacer(minLength: 0)
                        
                        VStack(alignment: .leading, spacing: 8, content: {
                            Text("\(radioPlayer.radio.track.name ?? "" == "" ? radioPlayer.stations[currentIndex].name : radioPlayer.radio.track.name!)")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(Color(NSColor.labelColor))
                            
                            Text("\(radioPlayer.radio.track.artist ?? "Live..." == "" ? "Live..." : radioPlayer.radio.track.artist!)")
                                .font(.caption2)
                                .foregroundColor(Color(NSColor.secondaryLabelColor))
                        })
                        
                        Spacer(minLength: 20)
                        
                        
                        HStack(spacing: 12){
                            
                            Button(action: {
                                print("Backward")
                                radioPlayer.currentIndex -= 1
                            }) {
                                Image(systemName: "backward.fill")
                                    .font(.title3)
                                    .aspectRatio(contentMode: .fit)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                radioPlayer.player.togglePlaying()
                            }) {
                                Image(systemName: radioPlayer.radio.playbackState == .playing ? "pause.fill" : "play.fill")
                                    .font(.title3)
                                    .aspectRatio(contentMode: .fit)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                print("Forward")
                                radioPlayer.currentIndex += 1
                            }) {
                                Image(systemName: "forward.fill")
                                    .font(.title3)
                                    .aspectRatio(contentMode: .fit)
                            }.buttonStyle(PlainButtonStyle())
                            
                            Spacer(minLength: 0)
                        }.padding(.leading,8)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal,8)
                    .background(Color(NSColor.windowBackgroundColor))
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: -5, y: -5)
                    .padding(.horizontal)
                    .padding(.bottom,5)
                }
            }
            .padding()
        }
        .ignoresSafeArea(.all, edges: .all)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor).opacity(0.6))
        .background(BlurWindow())
    }
}
