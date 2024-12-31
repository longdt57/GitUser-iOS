//
//  UserDetailCard.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

struct GitUserDetailCard: View {
    let name: String
    let avatarUrl: String
    let location: String
    
    var body: some View {
        UserCard {
            GitUserDetailItem(
                name: name,
                avatarUrl: avatarUrl,
                location: location
            )
            .padding(12)
        }
    }
}

struct GitUserDetailItem: View {
    let name: String
    let avatarUrl: String
    let location: String
    
    var body: some View {
        HStack(alignment: .top) {
            UserAvatar(avatarUrl: avatarUrl).frame(width: 120, height: 120)
            Spacer().frame(width: 16)
            VStack(alignment: .leading, spacing: 8) {
                GitUserDetailTitle(title: name)
                AppHorizontalDivider(thickness: 1.5)
                GitUserDetailLocation(location: location)
            }
        }
    }
}

struct GitUserDetailTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct GitUserDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        GitUserDetailCard(
            name: "longdt57",
            avatarUrl: "https://avatars.githubusercontent.com/u/1?v=4",
            location: "San Francisco, CA"
        )
        .padding()
    }
}
