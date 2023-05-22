//
//  HomeScreenView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/18/23.
//

import Foundation
import SwiftUI
import MusicKit

struct HomeScreenView: View {
    
    @StateObject var readData = ReadDatabase()
    @StateObject var countVotes = CountVotes()
    @StateObject var searchSong = SearchSong()
    @StateObject var getAndPlaySong = GetAndPlaySong()
    
    var playerQueue = PlayerQueue()
    
    // var topSong: [SongObject]
    
    var body: some View {
        VStack {
            ScrollView {
                if !readData.songList.isEmpty {
                    VStack (alignment: .leading){
                        ForEach(readData.songList.sorted(by: { $0.votes > $1.votes } ), id: \.self) { object in
                            HStack {
                                AsyncImage(url: URL(string: object.artwork)) { image in
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50, alignment: .leading)
                                        .aspectRatio(contentMode: .fill)
                                        .cornerRadius(5)
                                } placeholder: {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: 50, height: 50)
                                            .foregroundColor(.gray)
                                            .cornerRadius(5)
                                        Text("Could Not Load Image")
                                    }
                                }
                                .frame(width: 50, height: 50, alignment: .leading)
                                VStack {
                                    Text(object.title)
                                    Text(object.artist)
                                        .font(.caption)
                                }
                                Text(String(object.votes))
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                countVotes.addVote(songID: object.id, currentVotes: object.votes, title: object.title, artist: object.artist, artwork: object.artwork, duration: object.duration)
                                // Play song
                                //getAndPlaySong.play(item: object.id as! PlayableMusicItem)
                                //playerQueue.setQueue(ids: [object.id])
                                // readData.removeSong(songID: object.id)
                            }
                        }
                    }
                } else {
                    Text("No songs found")
                }
            }
            .frame(width:350, height: 275)
            .position(x:200, y:532)
        }
        .onAppear {
            readData.readAllObjects()
            readData.readObjectChanges()
            //readData.getTopObject()
        }
        
    }
}



