//
//  SettingsView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/18/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("Welcome to settings!")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
