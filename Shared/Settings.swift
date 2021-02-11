//
//  Settings.swift
//  Signal
//
//  Created by Jakša Tomović
//

import Foundation
import SwiftUI

//**************************************
// GENERAL SETTINGS
//**************************************

// Display Comments
let kDebugLog = false

//**************************************
// STATION JSON
//**************************************

// If this is set to "true", it will use the JSON file in the app
// Set it to "false" to use the JSON file at the stationDataURL

let useLocalStations = false
let stationDataURL   = "https://jaksatomovic.github.io/api/stations.json"
