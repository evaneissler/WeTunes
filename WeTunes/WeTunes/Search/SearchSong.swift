//
//  searchSong.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/14/23.
//

import Foundation
import MusicKit

@MainActor class SearchSong: ObservableObject {
    
    @Published var songs = [SearchSongObject]()
    
    func search(title: String) -> [SearchSongObject] {
        
        let request: MusicCatalogSearchRequest = {
            var request = MusicCatalogSearchRequest(term: title, types: [Song.self])
            request.limit = 25
            return request
        }()
        
        Task {
            let status = await MusicAuthorization.request()
            switch status {
            case.authorized:
                do {
                    print("Authorized")
                    let result = try await request.response()
                    let formatter = DateComponentsFormatter()
                    self.songs = result.songs.compactMap({
                        return .init(id: $0.id.rawValue, title: $0.title, artist: $0.artistName, artwork: (($0.artwork!.url(width:50,height:50) ?? URL(string:"https://upload.wikimedia.org/wikipedia/commons/thumb/5/5f/Apple_Music_icon.svg/1024px-Apple_Music_icon.svg.png"))!), duration: formatter.string(from: $0.duration!)!)
                    })
                    return songs
                } catch {
                    print("Error in fetching data!!!!!")
                    print(String(describing: error))
                    
                }
            default:
                print("Not Authorized")
                break
            }
            return songs
        }
        print("Returning an object")
        return songs
    }
}
