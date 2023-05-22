//
//  getAndPlaySong.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/18/23.
//

import Foundation
import MusicKit
import FirebaseFirestore


class GetAndPlaySong: ObservableObject {
    
    var songList = [SongObject]()
    
    // retrieve top song of sorted list
    func getListOfSongs() -> [SongObject] {
        let doThis = Firestore.firestore()
        doThis.collection("songs").getDocuments { snapshot, error in
            // Check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // Get all documents and create songs
                    self.songList = snapshot.documents.map { song in
                        // Create object for each song
                        return SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? "")
                    }
                } else {
                    // Handle error
                    print("Didn't find any songs")
                }
            }
        }
        return songList
    }
    
    func getTopSong(songList: [SongObject]) -> SongObject {
        
        var maxVotes = 0
        
        for song in songList {
            if song.votes > maxVotes {
                maxVotes = song.votes
            }
        }
        
        for song in songList {
            if song.votes == maxVotes {
                let topSong = song
                return topSong
            }
        }
        return SongObject(id: "1098026546", title: "Middle of a Memory", artist: "Cole Swindell", votes: 19, artwork: "https://is4-ssl.mzstatic.com/image/thumb/Music124/v4/1f/d0/93/1fd093e7-dcd9-eff7-0b3c-858bd937bb22/093624920274.jpg/50x50bb.jpg", duration: "3:47")
    }
    // play current
    func playTopSong(song: SongObject) {
        print(song)
    }
    // set second as in queue
    
    
    // remove top song after playing and getting artwork/title
    
    func removePlayingSong(song: SongObject) {
        let doThis = Firestore.firestore()
        doThis.collection("songs").document(song.id).delete()
    }
    
    func main() {
        //playTopSong(song: getTopSong(songList: getListOfSongs()))
        removePlayingSong(song: getTopSong(songList: getListOfSongs()))
    }
}


/* let doThis = Firestore.firestore()
 
 doThis.collection("songs").document(songID).getDocument { (document, error) in
     do {
         if !document!.exists {
             doThis.collection("songs").document(songID).setData([
                 "title" : title,
                 "artist" : artist,
                 "votes" : 1,
                 "artwork" : artwork,
                 "duration" : duration */
