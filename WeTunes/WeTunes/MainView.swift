//
//  RootView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/18/23.
//

import SwiftUI
import FirebaseFirestore
import MediaPlayer

struct RootView: View {
    
    @State var currentScreen: Tabs = .home
    
    @State var searchScreen: Bool = false
    var playerQueue = PlayerQueue()
    var readData = ReadDatabase()
    
    
    var body: some View {
        ZStack {
            HomeScreenView()
            PlayingSongView()
            if currentScreen == .vote {
                VoteView(searchScreen: $searchScreen)
                if searchScreen {
                    SearchView(searchScreen: $searchScreen)
                }
            }
            if currentScreen == .channels {
                ChannelsView()
            }
            if currentScreen == .settings {
                SettingsView()
            }
            NavigationBar(currentScreen: $currentScreen, searchScreen: $searchScreen)
        }
        .onAppear {
            readData.getTopObject()
        }
            
    }
}

struct StartView: View {
    
    @State private var showLoginScreen = false
    @State private var showCreateAccountScreen = false
    @State private var showOpeningScreen = true
    @State private var advanceToApp = false
    
    var body: some View {
        ZStack {
            if showLoginScreen == true {
                ShowLoginScreen(showLoginScreen: $showLoginScreen, showCreateAccountScreen: $showCreateAccountScreen, advanceToApp: $advanceToApp, showOpeningScreen: $showOpeningScreen)
            }
            if showCreateAccountScreen == true {
                ShowCreateAccountScreen(showLoginScreen: $showLoginScreen, showCreateAccountScreen: $showCreateAccountScreen, showOpeningScreen: $showOpeningScreen, advanceToApp: $advanceToApp)
            }
            if showOpeningScreen == true {
                OpeningScreenView(showLoginScreen: $showLoginScreen, showCreateAccountScreen: $showCreateAccountScreen, showOpeningScreen: $showOpeningScreen)
            }
            if advanceToApp == true {
                RootView()
            }
        }
    }
}

struct OpeningScreenView: View {
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 25)
    
    @Binding var showLoginScreen: Bool
    @Binding var showCreateAccountScreen: Bool
    @Binding var showOpeningScreen: Bool
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Image("Logo")
                Button {
                    showLoginScreen = true
                    showOpeningScreen = false
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
                    showCreateAccountScreen = true
                    showOpeningScreen = false
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

struct ShowLoginScreen: View {
    
    var readData = ReadDatabase()
    
    @Binding var showLoginScreen: Bool
    @Binding var showCreateAccountScreen: Bool
    @Binding var advanceToApp: Bool
    @Binding var showOpeningScreen: Bool
    
    @State var enteredEmail = ""
    @State var enteredPassword = ""
    
    @State private var accountMessage: String = ""
    @State private var showAccountMessage: Bool = false
    
    @State private var emailPasswordDict: [String: String] = [:]
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 20)
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Button {
                    showOpeningScreen = true
                    showLoginScreen = false
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
                    UIApplication.shared.resignFirstResponder()
                    if !enteredEmail.isEmpty {
                        if !enteredPassword.isEmpty {
                            if let password = emailPasswordDict[enteredEmail.lowercased()] {
                                if password == enteredPassword {
                                    advanceToApp = true
                                    showLoginScreen = false
                                } else {
                                    accountMessage = "Incorrect Password"
                                }
                        } else {
                            accountMessage = "Email or password not found"
                        }
                    } else {
                        accountMessage = "Please enter a password"
                    }
                } else {
                    accountMessage = "Please enter an email"
                }
                showAccountMessage = true
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
                .alert(isPresented: $showAccountMessage) {
                    Alert(title: Text(accountMessage), dismissButton: .default(Text("OK")))
                }
                Button {
                    showCreateAccountScreen = true
                    showLoginScreen = false
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
        .onAppear {
            // Get all users and passwords in a dictionary, then can do quick reference
            let doThis = Firestore.firestore()
            doThis.collection("users").getDocuments { [self] snapshot, error in
                if error == nil {
                    // No errors
                    if let snapshot = snapshot {
                        
                        for user in snapshot.documents {
                            emailPasswordDict[user.documentID] = user["password"] as? String ?? ""
                        }
                    }
                }
            }
        }
        
    }
    
}

struct ShowCreateAccountScreen: View {
    
    var readData = ReadDatabase()
    
    @Binding var showLoginScreen: Bool
    @Binding var showCreateAccountScreen: Bool
    @Binding var showOpeningScreen: Bool
    @Binding var advanceToApp: Bool
    
    @State var enteredEmail = ""
    @State var enteredPassword = ""
    @State var confirmPassword = ""
    
    @State private var accountMessage: String = ""
    @State private var showAccountMessage: Bool = false
    
    let font: Font = Font.custom("LexendDeca-Regular", size: 20)
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            VStack {
                Button {
                    showOpeningScreen = true
                    showCreateAccountScreen = false
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
                    if !enteredEmail.isEmpty {
                        if !enteredPassword.isEmpty {
                                if enteredPassword == confirmPassword {
                                    if readData.addUser(email: enteredEmail.lowercased(), password: enteredPassword) == true {
                                        advanceToApp = true
                                        showCreateAccountScreen = false
                                        accountMessage = "Account successfully created"
                                    } else {
                                        accountMessage = "Already a user"
                                    }
                                } else {
                                    accountMessage = "Passwords do not match"
                                }
                            } else {
                                accountMessage = "Please enter a password"
                            }
                        } else {
                            accountMessage = "Please enter an email"
                        }
                    showAccountMessage = true
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
                    .alert(isPresented: $showAccountMessage) {
                        Alert(title: Text(accountMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .padding([.bottom], 200)
        }
        
    }
}

