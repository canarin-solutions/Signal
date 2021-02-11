//
//  RadioPlayer.swift
//  Signal
//
//  Created by Jakša Tomović on 09.12.2020..
//

import SwiftUI


struct Radio {
    var track = Track()
    var playerState = FRadioPlayerState.urlNotSet
    var playbackState = FRadioPlaybackState.stopped
    var url: URL? = nil
    var rawMetadata: String? = nil
}

class RadioPlayer: FRadioPlayerDelegate, ObservableObject {
    
    @Published var radio = Radio()
    
    // Singleton ref to player
    var player: FRadioPlayer = FRadioPlayer.shared
        
    // List of stations
    @Published var stations: [RadioStation] = []

    var currentIndex = 0 {
        didSet {
            defer {
                stationDidChange(station: stations[currentIndex])
            }
            
            guard 0 ..< stations.endIndex ~= currentIndex else {
                currentIndex = currentIndex < 0 ? stations.count - 1 : 0
                return
            }
        }
    }
    
    init() {
        loadStationsFromJSON()
        player.delegate = self
        player.artworkSize = 500
        player.isAutoPlay = true
    }
    
    func radioPlayer(_ player: FRadioPlayer, playerStateDidChange state: FRadioPlayerState) {
        radio.playerState = state
    }
    
    func radioPlayer(_ player: FRadioPlayer, playbackStateDidChange state: FRadioPlaybackState) {
        radio.playbackState = state
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange artistName: String?, trackName: String?) {
        guard let artistName = artistName, let trackName = trackName else {
            radio.track.name = stations[currentIndex].name
            radio.track.artist = stations[currentIndex].detail
            return
        }
        
        radio.track.artist = artistName
        radio.track.name = trackName
    }
    
    func radioPlayer(_ player: FRadioPlayer, itemDidChange url: URL?) {
        radio.url = url
    }
    
    func radioPlayer(_ player: FRadioPlayer, metadataDidChange rawValue: String?) {
        radio.rawMetadata = rawValue
    }
    
    func radioPlayer(_ player: FRadioPlayer, artworkDidChange artworkURL: URL?) {
        // Please note that the following example is for demonstration purposes only, consider using asynchronous network calls to set the image from a URL.
        guard let artworkURL = artworkURL, let data = try? Data(contentsOf: artworkURL) else {
            radio.track.image = stations[currentIndex].image
            return
        }
        
        #if os(iOS)
        radio.track.image = UIImage(data: data)
        #else
        radio.track.image = NSImage(data: data)
        #endif
    }
    
    // - MARK: Station did Change
    
    private func stationDidChange(station: RadioStation) {
        player.radioURL = URL(string: station.streamURL)
        radio.track = Track(artist: station.detail, name: station.name, image: station.image)
    }
    
    private func loadStationsFromJSON() {
        DispatchQueue.global(qos: .userInitiated).async {
            if useLocalStations {
                self.loadLocalStations()
            } else {
                self.loadRemoteStations()
            }
        }
    }
    
    private func loadLocalStations() {
        // Get the Radio Stations
        DataManager.getStationDataWithSuccess() { (data) in
            
            if kDebugLog { print("Stations JSON Found") }
            
            guard let data = data, let jsonDictionary = try? JSONDecoder().decode(Stations.self, from: data) else {
                if kDebugLog {print("JSON Station Loading Error") }
                return
            }
            for radioStation in jsonDictionary.station {
                ImageLoader.sharedLoader.imageForUrl(urlString: radioStation.imageURL) { (image, stringURL) in
                    guard let image = image else { return }
                    
                    self.stations.append(RadioStation(name: radioStation.name, streamURL: radioStation.streamURL, imageURL: radioStation.imageURL ,image: image, detail: radioStation.desc))
                }
            }
        }
    }
    
    private func loadRemoteStations() {
        if kDebugLog { print("Stations JSON Found") }
        
        guard let stationDataURL = URL(string: stationDataURL) else {
            if kDebugLog { print("stationDataURL not a valid URL") }
            return
        }
        
        DataManager.loadDataFromURL(url: stationDataURL) { data, error in
            guard let data = data, let jsonDictionary = try? JSONDecoder().decode(Stations.self, from: data) else {
                if kDebugLog {print("JSON Station Loading Error") }
                return
            }
        
            for radioStation in jsonDictionary.station {
                ImageLoader.sharedLoader.imageForUrl(urlString: radioStation.imageURL) { (image, stringURL) in
                    guard let image = image else { return }
                    self.stations.append(RadioStation(name: radioStation.name, streamURL: radioStation.streamURL, imageURL: radioStation.imageURL ,image: image, detail: radioStation.desc))
                }
            }
        }
    }
}
