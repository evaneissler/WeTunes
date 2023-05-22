//
//  SearchSongObject.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/16/23.
//

import Foundation
import MusicKit

struct SearchSongObject: Identifiable, Decodable, Hashable {
    var id: String
    var title: String
    var artist: String
    var artwork: URL
    var duration: String
}
