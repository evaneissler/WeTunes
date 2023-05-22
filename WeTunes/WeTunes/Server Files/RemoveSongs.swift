//
//  RemoveSongs.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/22/23.
//

import Foundation
import FirebaseFirestore

struct SongRemovalObject: Identifiable, Hashable {
    var id: String
    var title: String
    var artist: String
    var votes: Int
    var artwork: String
    var duration: String
}

class RemoveSongs {
    
    @Published
    var topObject = [SongRemovalObject]()
    
    getTopSongForRemoval()
    
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
                    var topObjectDupe = [SongObject]()
                    for song in snapshot.documents {
                        // Create object for each song
                        if topObjectDupe.isEmpty {
                            topObjectDupe.append(SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? ""))
                            print(topObjectDupe)
                            
                            removeTopSong(songID: song.documentID)
                            
                            // repeat after song duration:
                            if song["duration"] as! String == "" {
                                startTimerUntilNextRemoval(with: "0:05")
                            } else {
                                startTimerUntilNextRemoval(with: song["duration"] as! String)
                            }
                            
                            return
                        }
                    }
                }
            } else {
                // Handle error
                print("Error: \(error?.localizedDescription ?? "")")
            }
            
            // Repeat the search after five seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.getTopSongForRemoval()
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
        
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { _ in
            let doThis = Firestore.firestore()
            
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
                                
                                print("removing song")
                                removeTopSong(songID: song.documentID)
                                // repeat after song duration:
                                if song["duration"] as! String == "" {
                                    startTimerUntilNextRemoval(with: "0:05")
                                } else {
                                    startTimerUntilNextRemoval(with: song["duration"] as! String)
                                }
                                
                                return
                            }
                        }
                    }
                } else {
                    // Handle error
                    print("Error: \(error?.localizedDescription ?? "")")
                }
                
                // Repeat the search after five seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.startTimerUntilNextRemoval(with: timeString)
                }
            }
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }


}
