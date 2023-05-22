//
//  CreateAccount.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/21/23.
//

import SwiftUI

enum CreateAccountScreens: Int {
    case openScreen = 0
    case loginScreen = 1
    case createAccount = 2
    case continueToApp = 3
    case backToOpenScreen = 4
}

struct CreateAccount: View {
    
    @State var enteredEmail = ""
    @State var enteredPassword = ""
    @State var confirmPassword = ""
    
    @Binding var createAccountScreen: CreateAccountScreens
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 20)
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Button {
                    createAccountScreen = .backToOpenScreen
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
                    .frame(width: 300, height: 50)
                    .padding(.bottom)
                SecureField("Password", text: $enteredPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 50)
                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 300, height: 50)
                    .padding(.bottom)
                Button {
                    createAccountScreen = .loginScreen
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

struct CreateAccount_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccount(createAccountScreen: .constant(.openScreen))
    }
}
