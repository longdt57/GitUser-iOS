//
//  UserAvatar.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

struct UserAvatar: View {

    var avatarUrl: String?

    init(avatarUrl: String?) {
        self.avatarUrl = avatarUrl
    }

    var body: some View {
        ZStack {
            // AsyncImage for loading the avatar
            AsyncImage(
                url: URL(string: avatarUrl ?? ""),
                content: { phase in
                    switch phase {
                    case .empty:
                        // Placeholder state
                        Image("ImageAvatarPlaceHolder")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(4)
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(4)
                    case .failure:
                        // Error state
                        Image("ImageAvatarPlaceHolder")
                            .resizable()
                            .scaledToFill()
                            .clipShape(Circle())
                            .padding(4)
                    @unknown default:
                        EmptyView()
                    }
                }
            )
            .clipShape(Circle()) // Circle shape for the avatar
            .padding(4) // Padding inside the circle
        }
        .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
        .clipShape(RoundedRectangle(cornerRadius: 8)) // Ensure the background is clipped
    }
}

struct UserAvatar_Previews: PreviewProvider {
    static var previews: some View {
        UserAvatar(avatarUrl: "https://example.com/avatar.jpg")
            .frame(width: 100, height: 100)
            .padding()
    }
}
