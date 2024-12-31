//
//  GitUserDetailLocation.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI

struct GitUserDetailLocation: View {
    let location: String
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin.and.ellipse") // SF Symbol for "Place" equivalent
                .resizable()
                .frame(width: 16, height: 16)
            
            Spacer().frame(width: 8)
            
            Text(location)
                .font(.body)
                .fontWeight(.regular)
                .lineLimit(1)
        }
    }
}

struct GitUserDetailLocation_Previews: PreviewProvider {
    static var previews: some View {
        GitUserDetailLocation(location: "San Francisco, CA")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

