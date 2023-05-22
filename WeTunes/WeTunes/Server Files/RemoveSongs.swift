//
//  RemoveSongs.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/22/23.
//

import Foundation
import FirebaseFirestore

class RemoveSongs {
    
    @Published
    var topObject = [SongObject]()
    
    // Calls getTopSongForRemoval()
    
    func removeTopSong(songID: String) {
       
        let doThis = Firestore.firestore()
        doThis.collection("songs").document(songID).delete()
        
    }
    
    func getTopSongForRemoval() {
    
        let doThis = Firestore.firestore()
        
        doThis.collection("songs").order(by: "votes", descending: true).getDocuments { [self] snapshot, error in
            // Check for errors
            if error == nil {
                // No errors
                if let snapshot = snapshot {
                    // Get all documents and create songs
                    for song in snapshot.documents {
                        // Create object for each song
                        if self.topObject.isEmpty {
                            self.topObject.append(SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? ""))
                            print(self.topObject)
                            removeTopSong(songID: song.documentID)
                            // repeat after song duration:
                            startTimerUntilNextRemoval(with: song["duration"] as! String ?? "0:05")
                        }
                    }
                    startTimerUntilNextRemoval(with: "0:05")
                } else {
                    // Handle error
                    print("Didn't find any songs")
                }
            }
        }
    }
    
    func startTimerUntilNextRemoval(with timeString: String) {
        let components = timeString.components(separatedBy: ":")
        
        guard components.count == 2,
              let minutes = Int(components[0]),
              let seconds = Int(components[1]) else {
            print("Invalid time format.")
            return
        }
        
        let timeInterval = TimeInterval(minutes * 60 + seconds)
        
        
        print("THIS IS THE TIME INTERVAL")
        print(timeInterval)
        
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) {_ in
            
            let doThis = Firestore.firestore()
            
            // SECOND TIME THROUGH
             doThis.collection("songs").order(by: "votes", descending: true).getDocuments { [self] snapshot, error in
                // Check for errors
                if error == nil {
                    // No errors
                    if let snapshot = snapshot {
                        // Get all documents and create songs
                        var topSongObject = [SongObject]()
                        for song in snapshot.documents {
                            // Create object for each song
                            if topSongObject.isEmpty {
                                topSongObject.append(SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? ""))
                                
                                removeTopSong(songID: song.documentID)
                                // repeat after song duration:
                                startTimerUntilNextRemoval(with: song["duration"] as! String ?? "0:05")
                            }
                        }
                        startTimerUntilNextRemoval(with: "0:05")
                    }
                }
            }
        }
        RunLoop.current.add(timer, forMode: .common)
    }
    
    
}
