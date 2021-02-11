//
//  trackswift
//  Swift Radio
//
//  Created by Matthew Fecher on 7/2/15.
//  Copyright (c) 2015 MatthewFecher.com. All rights reserved.
//

#if os(iOS) || os(tvOS)
import SwiftUI
#elseif os(OSX)
import SwiftUI
import Cocoa
#endif

struct Track {
    var artist: String?
    var name: String?
    
    #if os(iOS) || os(tvOS)
    var image: UIImage?
    #elseif os(OSX)
    var image: NSImage?
    #endif
    
    #if os(iOS) || os(tvOS)
    init(artist: String? = nil, name: String? = nil, image: UIImage? = nil) {
        self.name = name
        self.artist = artist
        self.image = image
    }
    #elseif os(OSX)
    init(artist: String? = nil, name: String? = nil, image: NSImage? = nil) {
        self.name = name
        self.artist = artist
        self.image = image
    }
    #endif
}
