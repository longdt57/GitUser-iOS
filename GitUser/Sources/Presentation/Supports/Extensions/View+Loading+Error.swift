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
            set: { _ in }
        )

        let message = loadingState.wrappedValue.message

        return toast(isPresenting: isPresenting) {
            AlertToast(type: .loading, subTitle: message)
        }
    }

    func showError(
        error: Binding<ErrorState>,
        primaryAction: @escaping ((ErrorState) -> Void),
        secondaryAction: @escaping ((ErrorState) -> Void)
    ) -> some View {
        let isPresenting = Binding(
            get: {
                if case .messageError = error.wrappedValue { return true } else { return false }
            },
            set: { _ in }
        )

        return self.alert(isPresented: isPresenting) {
            guard case let .messageError(messageError) = error.wrappedValue else {
                return Alert(title: Text("Unexpected Error"), message: nil, dismissButton: .default(Text("OK")))
            }
            
            if let secondaryButton = messageError.secondaryButton {
                return Alert(
                    title: Text(messageError.title),
                    message: Text(messageError.message),
                    primaryButton: .default(
                        Text(messageError.primaryButton),
                        action: { primaryAction(error.wrappedValue) }
                    ),
                    secondaryButton: .cancel(
                        Text(secondaryButton),
                        action: { secondaryAction(error.wrappedValue) }
                    )
                )
            } else {
                return Alert(
                    title: Text(messageError.title),
                    message: Text(messageError.message),
                    dismissButton: .default(
                        Text(messageError.primaryButton),
                        action: { primaryAction(error.wrappedValue) }
                    )
                )
            }
        }
    }
}
