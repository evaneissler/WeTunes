//
//  SearchSong.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/14/23.
//

import SwiftUI
import MusicKit


struct SearchView: View {
    
    @StateObject var searchSong = SearchSong()
    @StateObject var readDatabase = ReadDatabase()
    
    @Binding var searchScreen: Bool
    // @EnvironmentObject var model: Model
    
    @State var searchText = ""
    @State var searchResults = [SearchSongObject]()
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                HStack {
                    TextField("Enter Song Name", text: $searchText, onCommit: {
                        UIApplication.shared.resignFirstResponder()
                        if searchText.isEmpty {
                            searchResults = [SearchSongObject]()
                        } else {
                            Task {
                                let status = await MusicAuthorization.request()
                                switch status {
                                case.authorized:
                                    do {
                                        searchResults = searchSong.search(title: searchText)
                                        break
                                    }
                                default:
                                    break
                                }
                            }
                        }
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 75)
                    Button {
                        searchScreen = false
                    } label: {
                        Text("Cancel")
                    }
                }
                .position(x: 196, y:50)
                ScrollView {
                    VStack (alignment: .leading, spacing: 10) {
                        if !$searchResults.isEmpty {
                            ForEach($searchResults) { $song in
                                HStack {
                                    AsyncImage(url: song.artwork)
                                        .frame(width: 50, height: 50, alignment: .leading)
                                        .cornerRadius(5)
                                    VStack {
                                        Text(song.title)
                                        Text(song.artist)
                                            .font(.caption)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    readDatabase.addSong(songID: song.id, title: song.title, artist: song.artist, artwork: song.artwork.absoluteString, duration: song.duration)
                                    //searchScreen = false
                                }
                            }
                        } else {
                            Text("No songs found")
                        }
                        
                    }
                }
                .frame(width:400, height: 600)
                .position(x:200)
            }
            .background(Color.white)
            }
        }
        
}
    
struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(searchScreen: .constant(false))
    }
}
    
