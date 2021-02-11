//
//  StationView.swift
//  SpringRadio
//
//  Created by jack on 2020/4/7.
//  Copyright © 2020 jack. All rights reserved.
//

import SwiftUI

struct StationView: View {
    @EnvironmentObject var station : RadioStation
    @Binding var columns: [GridItem]

    var body: some View {
        
        VStack{
            
            HStack(spacing: 15){
                
                Image(uiImage: (station.image ?? UIImage(named: "albumArt")!))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: columns.count == 2 ? (UIScreen.main.bounds.width - 45) / 2 :  columns.count == 4 ? (UIScreen.main.bounds.width - 45) / 4 : 85, height: columns.count == 2 ? (UIScreen.main.bounds.width - 45) / 2 : columns.count == 4 ? (UIScreen.main.bounds.width - 45) / 4: 85)
                    .cornerRadius(15)
                
                if columns.count == 1{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(station.name)
                            .fontWeight(.heavy)
                    }
                    
                    Spacer(minLength: 0)
                }
            }
            
            if columns.count == 2{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(station.name)
                            .fontWeight(.heavy)
                    }
                    
                    Spacer(minLength: 15)
                }
            }
            
            if columns.count == 4{
                
                HStack{
                    
                    VStack(alignment: .leading, spacing: 6) {
                        
                        Text(station.name)
                            .fontWeight(.heavy)
                    }
                    
                    Spacer(minLength: 15)
                }
            }
        }
    }
}
