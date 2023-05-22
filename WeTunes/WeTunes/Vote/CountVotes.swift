//
//  CountVotes.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/16/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import MusicKit

class CountVotes: ObservableObject {
    
    func addVote(songID: String, currentVotes: Int, title: String, artist: String, artwork: String, duration: String) {
        
        let doThis = Firestore.firestore()
        
        let newVotes = currentVotes + 1
        
        doThis.collection("songs").document(songID).setData([
            "title" : title,
            "artist" : artist,
            "votes" : newVotes,
            "artwork" : artwork,
            "duration" : duration
        ])
    }
}
    
