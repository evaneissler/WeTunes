//
//  ContentView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/14/23.
//
import Foundation
import SwiftUI
import MusicKit

struct VoteView: View {
    
    @StateObject var readData = ReadDatabase()
    @StateObject var countVotes = CountVotes()
    @StateObject var searchSong = SearchSong()
    
    @Binding var searchScreen: Bool
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 20)
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Text("Up Next")
                    .position(x:75,y:20)
                ZStack {
                    ScrollView {
                            VStack {
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
                                                    Rectangle()
                                                        .frame(width: 50, height: 50)
                                                        .foregroundColor(.gray)
                                                        .cornerRadius(5)
                                                }
                                                .frame(width: 50, height: 50, alignment: .leading)
                                                VStack {
                                                    Text(object.title)
                                                    Text(object.artist)
                                                        .font(.caption)
                                                }
                                                Text(String(object.votes))
                                                    .frame(width:25,height:25)
                                            }
                                            .contentShape(Rectangle())
                                            .onTapGesture {
                                                countVotes.addVote(songID: object.id, currentVotes: object.votes, title: object.title, artist: object.artist, artwork: object.artwork, duration: object.duration)
                                            }
                                        }
                                    }
                                } else {
                                    Text("No songs found")
                                }
                            }
                            .onAppear {
                                readData.readAllObjects()
                                readData.readObjectChanges()
                                
                            }
                    }
                    .frame(width:400, height: 620)
                    Button {
                        searchScreen = true
                    } label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.cyan)
                                .frame(width: 150, height: 60)
                                .cornerRadius(100)
                            HStack {
                                Text("Add Song")
                                    .font(font)
                                    .foregroundColor(.white)
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width:20, height: 20)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .position(x:200, y: 580)
                }
                .position(x: 200, y: -10)
            }
            
            }
        }
        
        
}


struct VoteView_Previews: PreviewProvider {
    static var previews: some View {
        VoteView(searchScreen: .constant(false))
    }
}

