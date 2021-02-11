//
//  RadioStation.swift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/4/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

import SwiftUI

class RadioStation: ObservableObject, Identifiable, Hashable {
    
    var name: String
    var streamURL: String
    var imageURL: String
    var detail: String
    #if os(iOS) || os(tvOS)
    var image: UIImage?
    #elseif os(OSX)
    var image: NSImage?
    #endif

    #if os(iOS) || os(tvOS)
    init(name: String, streamURL: String, imageURL: String, image: UIImage? = nil, detail: String) {
        self.name = name
        self.streamURL = streamURL
        self.imageURL = imageURL
        self.image = image
        self.detail = detail
    }
    #elseif os(OSX)
    init(name: String, streamURL: String, imageURL: String, image: NSImage? = nil, detail: String) {
        self.name = name
        self.streamURL = streamURL
        self.imageURL = imageURL
        self.image = image
        self.detail = detail
    }
    #endif
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    static func == (lhs: RadioStation, rhs: RadioStation) -> Bool {
        return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }
}
