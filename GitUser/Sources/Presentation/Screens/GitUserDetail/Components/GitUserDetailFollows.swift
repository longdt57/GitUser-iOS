//
//  GitUserDetailFollows.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

struct GitUserDetailFollows: View {
    let followers: String
    let following: String
    
    var body: some View {
        HStack {
            GitUserDetailFollowItem(
                value: followers,
                iconName: "person.circle.fill", // Replace with appropriate SF Symbol
                text: R.string.localizable.followers()
            )
            .frame(maxWidth: .infinity) // Equivalent to Modifier.weight(1f)
            
            Spacer().frame(width: 16)
            
            GitUserDetailFollowItem(
                value: following,
                iconName: "face.smiling.fill", // Replace with appropriate SF Symbol
                text: R.string.localizable.following()
            )
            .frame(maxWidth: .infinity)
        }
    }
}

struct GitUserDetailFollowItem: View {
    let value: String
    let iconName: String
    let text: String
    
    var body: some View {
        VStack(alignment: .center) {
            Image(systemName: iconName) // Use SF Symbols for icons
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.gray.opacity(0.5))
            
            Text(value).font(.body)
            
            Text(text)
                .font(.body)
                .foregroundColor(Color.gray.opacity(0.8))
        }
    }
}

struct FollowersPreview: PreviewProvider {
    static var previews: some View {
        GitUserDetailFollows(
            followers: "999+",
            following: "99+"
        )
        .padding(.horizontal, 60)
        .previewLayout(.sizeThatFits)
    }
}

