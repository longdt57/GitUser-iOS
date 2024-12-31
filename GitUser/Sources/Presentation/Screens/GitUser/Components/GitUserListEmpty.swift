//
//  GitUserListEmpty.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

struct GitUserListEmpty: View {
    let onRefresh: () -> Void

    var body: some View {
        VStack {
            Button(action: onRefresh) {
                Text(R.string.localizable.common_retry())
                    .font(.title2)
                    .foregroundColor(.blue) // You can customize this color
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Center the content
    }
}

struct GitUserListEmpty_Previews: PreviewProvider {
    static var previews: some View {
        GitUserListEmpty {
            // Add your action for refresh here
            print("Retry action triggered")
        }
        .previewLayout(.sizeThatFits)
    }
}
