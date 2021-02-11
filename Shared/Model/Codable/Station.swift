//
//  Station.swift
//  Signal
//
//  Created by Jakša Tomović on 06.12.2020..
//

import Foundation

public struct Station: Decodable {
    let name: String
    let streamURL: String
    let imageURL: String
    let desc: String
}
