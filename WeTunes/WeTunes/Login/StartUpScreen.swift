//
//  StartUpScreen.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/21/23.
//

import SwiftUI

enum StartScreens: Int {
    case openScreen = 0
    case loginScreen = 1
    case createAccount = 2
    case continueToApp = 3
}

struct StartUpScreen: View {
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 25)
    @Binding var startScreen: StartScreens
    
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Image("Logo")
                Button {
                    startScreen = .loginScreen
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width:300, height: 75)
                            .cornerRadius(15)
                            .foregroundColor(Color.cyan)
                        Text("Login")
                            .foregroundColor(Color.white)
                            .font(font)
                    }
                }
                .padding([.top], 500)
                Button {
                    startScreen = .createAccount
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width:300, height: 75)
                            .cornerRadius(15)
                            .foregroundColor(Color.cyan)
                        Text("Create Account")
                            .foregroundColor(Color.white)
                            .font(font)
                    }
                }
            }
        }
    }
}

struct StartUpScreen_Previews: PreviewProvider {
    static var previews: some View {
        StartUpScreen(startScreen: .constant(.openScreen))
    }
}
