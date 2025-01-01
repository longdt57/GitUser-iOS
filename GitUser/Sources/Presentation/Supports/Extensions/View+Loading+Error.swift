//
//  View+Loading+Error.swift
//  app
//
//  Created by Long Do
//

import AlertToast
import SwiftUI

extension View {

    func showLoading(loadingState: Binding<LoadingState>) -> some View {
        let isPresenting = Binding(
            get: {
                if case .loading = loadingState.wrappedValue { return true } else { return false }
            },
            set: { isLoading in
                loadingState.wrappedValue = isLoading ? .loading() : .none
            }
        )

        let message = loadingState.wrappedValue.message

        return toast(isPresenting: isPresenting) {
            AlertToast(type: .loading, subTitle: message)
        }
    }

    func showError(
        error: Binding<ErrorState>,
        primaryAction: (() -> Void)? = {},
        secondaryAction: (() -> Void)? = {}
    ) -> some View {
        let isPresenting = Binding(
            get: {
                if case .messageError = error.wrappedValue { return true } else { return false }
            },
            set: { isErrorPresent in
                if !isErrorPresent {
                    error.wrappedValue = .none
                }
            }
        )

        return alert(isPresented: isPresenting) {
            switch error.wrappedValue {
            case .none:
                return Alert(title: Text(""), message: nil, dismissButton: .default(Text("")))

            case let .messageError(messageError: messageError):
                if let secondaryButton = messageError.secondaryButton {
                    return Alert(
                        title: Text(messageError.title),
                        message: Text(messageError.message),
                        primaryButton: .default(Text(messageError.primaryButton), action: primaryAction),
                        secondaryButton: .cancel(Text(secondaryButton), action: secondaryAction)
                    )
                } else {
                    return Alert(
                        title: Text(messageError.title),
                        message: Text(messageError.message),
                        dismissButton: .default(Text(messageError.primaryButton), action: primaryAction)
                    )
                }
            }
        }
    }
}
