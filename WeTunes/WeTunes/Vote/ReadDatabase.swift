//
//  ReadDatabase.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/15/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import MusicKit
import SwiftUI

class ReadDatabase: ObservableObject {
    
    var ref = Database.database().reference()
    var addVote = CountVotes()
    var playerQueue = PlayerQueue()
    
    @Published
    var value: String? = nil
    
    @Published
    var object: SongObject? = nil
    
    @Published
    var songList = [SongObject]()
    
    @Published
    var topSong = [SongObject]()
    
    @Published
    var topObject = [SongObject]()
    
    @Published
    var topObjectDupe = [SongObject]()
    
    @Published
    var songListForVoteReference = [SongObject]()
    
    func readAllObjects() {
        
        // Get reference to database
        let doThis = Firestore.firestore()
        
        doThis.collection("songs").order(by: "votes", descending: true).getDocuments { snapshot, error in
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
    }
    
    func readObjectChanges() {
        
        let doThis = Firestore.firestore()
        
        doThis.collection("songs").addSnapshotListener { documentSnapshot, error in
            guard let snapshot = documentSnapshot else {
                print("Error fetching documents")
                return
            }
            self.songList = snapshot.documents.map { song in
                // Create object for each song
                return SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? "")
            }
        
        }
    }
    
    func addSong(songID: String, title: String, artist: String, artwork: String, duration: String) {
        
        let doThis = Firestore.firestore()
        
        doThis.collection("songs").document(songID).getDocument { (document, error) in
            do {
                if !document!.exists {
                    doThis.collection("songs").document(songID).setData([
                        "title" : title,
                        "artist" : artist,
                        "votes" : 1,
                        "artwork" : artwork,
                        "duration" : duration
                    ])
                } else {
                    doThis.collection("songs").addSnapshotListener { documentSnapshot, error in
                     guard let snapshot = documentSnapshot else {
                         print("Error fetching documents")
                         return
                     }
                     self.songListForVoteReference = snapshot.documents.map { song in
                         // Create object for each song
                         return SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? "")
                     }
                    }

                    for song in self.songListForVoteReference {
                     if song.id == songID {
                         var currentVotes: Int
                         currentVotes = song.votes
                         self.addVote.addVote(songID: song.id, currentVotes: currentVotes, title: song.title, artist: song.artist, artwork: song.artwork, duration: song.duration)
                     }
                    }
                }
            }
            
        }
    }
    
    func getTopObject() {
    
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
                            
                            //PlayingSongView(song: self.topObject) // Make this view show on top of home screen
                            playerQueue.setQueue(ids: [song.documentID])
                            removeSong(songID: song.documentID)
                            
                            // repeat after song duration:
                            startTimer(with: song["duration"] as! String)
                        } else {
                            playerQueue.appendItem(ids: [song.documentID])
                            
                        }
                    }
                } else {
                    // Handle error
                    print("Didn't find any songs")
                }
            }
        }
    }
    
    func removeSong(songID: String) {
       
        let doThis = Firestore.firestore()
        doThis.collection("songs").document(songID).delete()
        
    }
    
    func startTimer(with timeString: String) {
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
                        var topObjectDupe2 = [SongObject]()
                        for song in snapshot.documents {
                            // Create object for each song
                            if topObjectDupe2.isEmpty {
                                topObjectDupe2.append(SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? ""))
                                print(topObjectDupe2)
                                
                                //PlayingSongView(song: self.topObject) // Make this view show on top of home screen
                                playerQueue.setQueue(ids: [song.documentID])
                                removeSong(songID: song.documentID)
                                print("getting here the second time!!")
                                // repeat after song duration:
                                startTimer(with: song["duration"] as! String)
                            } else {
                                playerQueue.appendItem(ids: [song.documentID])
                            }
                            
                        }
                    } else {
                        // Handle error
                        print("Didn't find any songs")
                    }
                }
            }
            print("TIMER DONE")
        }
        
        RunLoop.current.add(timer, forMode: .common)
    }
    
    func addUser(email: String, password: String) -> Bool {
        let doThis = Firestore.firestore()

        let documentRef = doThis.collection("users").document(email)
        var documentExists = false

        documentRef.getDocument { (document, error) in
            if let document = document, document.exists {
                documentExists = true
            }
        }
        if documentExists {
            return false // Document already exists, indicating failure
        }
        do {
            try doThis.collection("users").document(email).setData([
                "password" : password
            ])
            return true // Document successfully added, indicating success
        } catch {
            // Handle the error here, if needed
            print("Error adding document: \(error)")
            return false // Failed to add document, indicating failure
        }
    }

    func checkUser(email: String, password: String) -> Bool {
        var accessGranted = false
        let semaphore = DispatchSemaphore(value: 0)

        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let query = usersCollection.whereField("email", isEqualTo: email)

        query.getDocuments { (snapshot, error) in
            if let error = error {
                print("Error getting user document: \(error)")
                semaphore.signal()
                return
            }

            guard let documents = snapshot?.documents else {
                semaphore.signal()
                return
            }

            for document in documents {
                let documentData = document.data()
                if let savedPassword = documentData["password"] as? String {
                    if savedPassword == password {
                        accessGranted = true
                        break
                    }
                }
            }

            semaphore.signal()
        }

        _ = semaphore.wait(timeout: .distantFuture)

        return accessGranted
    }

}

