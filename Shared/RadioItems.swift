//
//  RadioItems.swift
//  Signal
//
//  Created by Jakša Tomović on 05.12.2020..
//

import SwiftUI
import Foundation



struct RadioItem {
    
    var title: String
    var streamURL: RadioURL
    var imageName: String
}

enum RadioURL: String {
    case danceUK = "https://stream.otvoreni.hr:443/hoho"
    case boxUK = "http://51.75.170.46:6191/stream"
    case rrDrumAndBass = "http://air2.radiorecord.ru:9003/drumhits_320"
    case dfmPopDance = "https://dfm-popdance.hostingradio.ru/popdance96.aacp"
    case dfmRussianDance = "https://dfm-dfmrusdance.hostingradio.ru/dfmrusdance96.aacp"
    case rrRussianGold = "http://air2.radiorecord.ru:9003/russiangold_320"
    case dnbMyRadio = "http://relay.myradio.ua:8000/DrumAndBass128.mp3"
    case countryRadio = "https://live.leanstream.co/CKRYFM"
    case americasCountry = "https://ais-sa2.cdnstream1.com/1976_128.mp3"
    case batYamRadioRus = "http://891fm.streamgates.net/891Fm"
    case rrRussianHits = "http://air2.radiorecord.ru:9003/russianhits_320"
    case rrEDMHits = "http://air2.radiorecord.ru:9003/edmhits_320"
    case rrFutureHouse = "http://air2.radiorecord.ru:9003/fut_320"
    case veniceClassicItalia = "http://174.36.206.197:8000/stream"
    case austinBluesRadio = "http://ca10.rcast.net:8036/stream"
    case soundFusion = "http://uk6.internet-radio.com:8346/stream"
    case asiaDream = "http://66.70.187.44:9029/stream"
    case jpopproject = "http://184.75.223.178:8083/stream"
    case pure90sRadio = "http://185.105.4.100:8183/stream"
}

class RadioItems : ObservableObject, RadioItemListDelegate {
    init() {
        self.values = [
            RadioStationPlayable(radioItem: RadioItem(title: "Dance UK Radio", streamURL: .danceUK, imageName: "danceUK"), delegate: self, itemStatesInList: .First),
            RadioStationPlayable(radioItem: RadioItem(title: "Box UK Radio", streamURL: .boxUK, imageName: "boxUK"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Sound Fusion Radio", streamURL: .soundFusion, imageName: "soundFusion"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Country 105 FM", streamURL: .countryRadio, imageName: "countryRadio"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Americas Country", streamURL: .americasCountry, imageName: "americasCountry"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Pure 90s Radio", streamURL: .pure90sRadio, imageName: "pure90s"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Venice Classic Radio Italia", streamURL: .veniceClassicItalia, imageName: "veniceClassic"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Austin Blues Radio", streamURL: .austinBluesRadio, imageName: "austinBlues"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "PowerPlay Kawaii", streamURL: .asiaDream, imageName: "asiaDream"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "J-Pop Project Radio", streamURL: .jpopproject, imageName: "jpopproject"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Record Drum'n'Bass", streamURL: .rrDrumAndBass, imageName: "radioRecord"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "DFM Pop Dance", streamURL: .dfmPopDance, imageName: "dfmPopDance"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "DFM Russian Dance", streamURL: .dfmRussianDance, imageName: "russianDance"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records Russian Hits", streamURL: .rrRussianHits, imageName: "rrRussianHits"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records EDM Hits", streamURL: .rrEDMHits, imageName: "rrEdmHits"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Bat Yam 89.1 FM", streamURL: .batYamRadioRus, imageName: "batYamRussian"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Records Russian Gold", streamURL: .rrRussianGold, imageName: "rrRussianGold"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "DnB My Radio", streamURL: .dnbMyRadio, imageName: "dnbMyRadio"), delegate: self),
            RadioStationPlayable(radioItem: RadioItem(title: "Radio Record Future House", streamURL: .rrFutureHouse, imageName: "rrFutureHouse"), delegate: self, itemStatesInList: .Last)
                ]
    }
   @Published var values: [RadioStationPlayable] =  [RadioStationPlayable]()
    
    @Published var currentStationIndex: Int = 0
    
    
    func previousStation() {
        guard self.currentStationIndex > 0 else {
            return
        }
        self.values[self.currentStationIndex].isPlaying = false
        self.currentStationIndex -= 1
        self.values[self.currentStationIndex].isPlaying = true
    }
    
    func nextStation() {
        guard self.currentStationIndex < self.values.count - 1 else  {
            return
        }
        self.values[self.currentStationIndex].isPlaying = false
        self.currentStationIndex += 1
        self.values[self.currentStationIndex].isPlaying = true
    }
}


protocol RadioItemListDelegate {
    func previousStation()
    func nextStation()
}

class NavigationPopGestionManager: NSObject, UIGestureRecognizerDelegate {
    var nc:UINavigationController
    
    
    init(nc:UINavigationController) {
        self.nc = nc
    }
    
    func setGestureRecongizerDelegate() {
        self.nc.interactivePopGestureRecognizer?.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
        return nc.viewControllers.count <= 1 ? false : true
    }
}
