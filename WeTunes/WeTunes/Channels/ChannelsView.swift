//
//  ChannelsView.swift
//  WeTunes
//
//  Created by Evan Eissler on 5/18/23.
//

import SwiftUI

struct ChannelsView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text("Channels Coming Soon!")
        }
    }
}

struct ChannelsView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelsView()
    }
}
