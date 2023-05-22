//
//  PlayingSongView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/20/23.
//

import SwiftUI
import MediaPlayer
import FirebaseFirestore


struct PlayingSongView: View {
    
    @State private var currentSong: MPMediaItem?
    
    func setTimer(with timeString: String) {
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
        
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval + 3.0, repeats: false) {_ in
            
            NotificationCenter.default.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: nil) { _ in
                if let song = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem {
                    self.currentSong = song
                } else {
                    self.currentSong = nil
                }
            }
            MPMusicPlayerController.systemMusicPlayer.beginGeneratingPlaybackNotifications()
            
            let doThis = Firestore.firestore()
            
            // SECOND TIME THROUGH
            doThis.collection("songs").order(by: "votes", descending: true).getDocuments { [self] snapshot, error in
                // Check for errors
                if error == nil {
                    // No errors
                    if let snapshot = snapshot {
                        // Get all documents and create songs
                        var topObjectDupe3 = [SongObject]()
                        for song in snapshot.documents {
                            // Create object for each song
                            if topObjectDupe3.isEmpty {
                                topObjectDupe3.append(SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? ""))
                                print(topObjectDupe3)
                                
                                setTimer(with: song["duration"] as! String)
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
    
    var body: some View {
        VStack {
            if let song = currentSong {
                Text("Now Playing")
                    .font(.title3)
                if let artwork = song.artwork {
                    Image(uiImage: artwork.image(at: CGSize(width: 250, height: 250))!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .cornerRadius(50)
                        .padding()
                }
                Text(song.title ?? "Unknown Song")
                    .font(.title2)
                Text(song.artist ?? "Unknown Artist")
                    .font(.caption)
            } else {
                Text("No song playing")
                    .font(.body)
                    .padding()
            }
        }
        .position(x: 200, y: 200)
        .onAppear {
            NotificationCenter.default.addObserver(forName: .MPMusicPlayerControllerNowPlayingItemDidChange, object: nil, queue: nil) { _ in
                if let song = MPMusicPlayerController.systemMusicPlayer.nowPlayingItem {
                    self.currentSong = song
                } else {
                    self.currentSong = nil
                }
            }
            MPMusicPlayerController.systemMusicPlayer.beginGeneratingPlaybackNotifications()
            
            
            let doThis = Firestore.firestore()
            
            doThis.collection("songs").order(by: "votes", descending: true).getDocuments { [self] snapshot, error in
                // Check for errors
                if error == nil {
                    // No errors
                    if let snapshot = snapshot {
                        // Get all documents and create songs
                        var topObjectDupe3 = [SongObject]()
                        for song in snapshot.documents {
                            // Create object for each song
                            if topObjectDupe3.isEmpty {
                                topObjectDupe3.append(SongObject(id: song.documentID, title: song["title"] as? String ?? "", artist: song["artist"] as? String ?? "", votes: song["votes"] as? Int ?? 0, artwork: song["artwork"] as? String ?? "", duration: song["duration"] as? String ?? ""))
                                setTimer(with: song["duration"] as! String)
                            }
                        }
                    }
                    
                }
                /*.onDisappear {
                 MPMusicPlayerController.systemMusicPlayer.endGeneratingPlaybackNotifications()
                 }*/
            }
        }
    }
}

struct PlayingSongView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingSongView()
    }
}
