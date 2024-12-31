//
//  View+ToastUI.swift
//  app
//
//  Created by Long Do on 06/10/2022.
//

import AlertToast
import SwiftUI

extension View {

    func showToast(isPresenting: Binding<Bool>, message: String) -> some View {
        toast(isPresenting: isPresenting) {
            AlertToast(type: .regular, subTitle: message)
        }
    }
}
