//
//  NavigationBar.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/16/23.
//

import SwiftUI

enum Tabs: Int {
    case home = 0
    case vote = 1
    case channels = 2
    case settings = 3
}

struct NavigationBar: View {
    
    @Binding var currentScreen: Tabs
    @Binding var searchScreen: Bool
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 10)
    
    var body: some View {
        HStack (spacing: 0) {
            Button {
                // Switch to home
                currentScreen = .home
                searchScreen = false
            } label: {
                if currentScreen == .home {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(Color.white)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "music.note.house.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.cyan)
                            Text("Home")
                                .font(font)
                                .foregroundColor(.cyan)
                        }
                        .position(x: 60, y: 40)
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(.cyan)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "music.note.house.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.white)
                            Text("Home")
                                .font(font)
                                .foregroundColor(.white)
                        }
                        .position(x: 60, y: 40)
                    }
                }
                
                
            }
            // .frame(width:100, height:100)
            
            Button {
                //Switch to vote
                currentScreen = .vote
                searchScreen = false
            } label: {
                if currentScreen == .vote {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(Color.white)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "hand.tap.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.cyan)
                            Text("Vote")
                                .font(font)
                                .foregroundColor(.cyan)
                        }
                        .position(x: 50, y: 40)
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(.cyan)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "hand.tap.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.white)
                            Text("Vote")
                                .font(font)
                                .foregroundColor(.white)
                        }
                        .position(x: 50, y: 40)
                    }
                }
            }
            // .frame(width:100, height:100)
            
            Button {
                // Switch to channels
                currentScreen = .channels
                searchScreen = false
            } label: {
                if currentScreen == .channels {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(Color.white)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.cyan)
                            Text("Channels")
                                .font(font)
                                .foregroundColor(.cyan)
                        }
                        .position(x: 50, y: 40)
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(.cyan)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.white)
                            Text("Channels")
                                .font(font)
                                .foregroundColor(.white)
                        }
                        .position(x: 50, y: 40)
                    }
                }
            }
            // .frame(width:100, height:100)
            
            
            Button {
                // Switch to settings
                currentScreen = .settings
                searchScreen = false
            } label: {
                if currentScreen == .settings {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(Color.white)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.cyan)
                            Text("Settings")
                                .font(font)
                                .foregroundColor(.cyan)
                        }
                        .position(x: 40, y: 40)
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .frame(width:100,height:110)
                            .foregroundColor(.cyan)
                            .position(x:50,y:50)
                        VStack {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .aspectRatio(contentMode: .fill)
                                .foregroundColor(.white)
                            Text("Settings")
                                .font(font)
                                .foregroundColor(.white)
                        }
                        .position(x: 40, y: 40)
                    }
                }
            }
            // .frame(width:100, height:100)
        }
        .position(x: 200, y: 420)
        .frame(width:400, height:110)
    }
    
}


struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(currentScreen: .constant(.vote), searchScreen: .constant(false))
    }
}
