//
//  GitUserDetailBlog.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

struct GitUserDetailBlog: View {
    let blog: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(R.string.localizable.blog())
                .font(.title)
                .fontWeight(.bold)

            Text(blog)
                .font(.body)
                .foregroundColor(Color.gray.opacity(0.8))
                .underline()
                .onTapGesture {
                    openUrl(blog)
                }
        }
    }

    private func openUrl(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct BlogPreview: PreviewProvider {
    static var previews: some View {
        GitUserDetailBlog(blog: "https://www.google.com")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
