//
//  ErrorState.swift
// iOS MVVM
//
//  Created by Long Do on 12/12/2024.
//

import Foundation

enum ErrorState {
    case none
    case messageError(MessageError)
    
    struct MessageError {
        let errorCode: Int?
        let iconRes: Int?
        let title: String
        let message: String
        let primaryButton: String
        let secondaryButton: String?
        
        static let common = MessageError(
            errorCode: nil,
            iconRes: nil,
            title: R.string.localizable.popup_error_unknown_title(),
            message: R.string.localizable.popup_error_unknown_body(),
            primaryButton: R.string.localizable.common_close(),
            secondaryButton: nil
        )
        
        static func network(
            errorCode: Int? = nil,
            iconRes: Int? = nil,
            title: String = R.string.localizable.popup_error_no_connection_title(),
            message: String = R.string.localizable.popup_error_no_connection_body(),
            primaryButton: String = R.string.localizable.common_retry(),
            secondaryButton: String = R.string.localizable.common_close()
        ) -> MessageError {
            MessageError(
                errorCode: errorCode,
                iconRes: iconRes,
                title: title,
                message: message,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        }
        
        static func api(
            errorCode: Int? = nil,
            iconRes: Int? = nil,
            title: String = R.string.localizable.popup_error_unknown_title(),
            message: String = R.string.localizable.popup_error_unknown_body(),
            primaryButton: String = R.string.localizable.common_retry(),
            secondaryButton: String = R.string.localizable.common_close(),
            messageBody: String? = nil
        ) -> MessageError {
            MessageError(
                errorCode: errorCode,
                iconRes: iconRes,
                title: title,
                message: messageBody ?? message,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        }
        
        static func server(
            errorCode: Int? = nil,
            iconRes: Int? = nil,
            title: String = R.string.localizable.popup_error_timeout_title(),
            message: String = R.string.localizable.popup_error_timeout_body(),
            primaryButton: String = R.string.localizable.common_close(),
            secondaryButton: String? = nil
        ) -> MessageError {
            MessageError(
                errorCode: errorCode,
                iconRes: iconRes,
                title: title,
                message: message,
                primaryButton: primaryButton,
                secondaryButton: secondaryButton
            )
        }
    }
}
