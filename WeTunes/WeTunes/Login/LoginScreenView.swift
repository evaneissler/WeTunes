//
//  SwiftUIView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/21/23.
//

import SwiftUI

enum LoginScreens: Int {
    case openScreen = 0
    case loginScreen = 1
    case createAccount = 2
    case continueToApp = 3
    case backToOpenScreen = 4
}

struct LoginScreenView: View {
    
    @State var enteredEmail = ""
    @State var enteredPassword = ""
    
    @Binding var loginScreen: LoginScreens
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 20)

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Button {
                    loginScreen = .backToOpenScreen
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width:100, height: 40)
                            .cornerRadius(15)
                            .foregroundColor(Color.cyan)
                        Text("Go Back")
                            .foregroundColor(Color.white)
                            .font(font)
                    }
                }
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                TextField("Email", text: $enteredEmail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 75)
                SecureField("Password", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 75)
                    .padding(.bottom)
                Button {
                    loginScreen = .continueToApp
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width:100, height: 40)
                            .cornerRadius(15)
                            .foregroundColor(Color.cyan)
                        Text("Login")
                            .foregroundColor(Color.white)
                            .font(font)
                    }
                }
                Button {
                    loginScreen = .createAccount
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width:200, height: 40)
                            .cornerRadius(15)
                            .foregroundColor(Color.cyan)
                        Text("Create Account")
                            .foregroundColor(Color.white)
                            .font(font)
                    }
                }
            }
            .padding([.bottom], 200)
        }
    }
}

struct LoginScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LoginScreenView(loginScreen: .constant(.openScreen))
    }
}
