//
//  Song.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/14/23.
//

import Foundation
import MusicKit

struct SongObject: Identifiable, Hashable {
    var id: String
    var title: String
    var artist: String
    var votes: Int
    var artwork: String
    var duration: String
}
