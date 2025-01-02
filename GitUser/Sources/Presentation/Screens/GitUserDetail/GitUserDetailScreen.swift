//
//  GitUserDetailScreen.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Resolver
import SwiftUI

struct GitUserDetailScreen: View {

    var login: String

    @StateObject var viewModel: GitUserDetailViewModel = Resolver.resolve()

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // Access to presentation mode

    var body: some View {
        VStack {
            content(uiModel: viewModel.uiModel)
        }
        .showLoading(loadingState: $viewModel.loading)
        .showError(
            error: $viewModel.error,
            primaryAction: {
                viewModel.onErrorPrimaryAction(errorState: $0)
            }, secondaryAction: {
                viewModel.onErrorSecondaryAction(errorState: $0)
            }
        )
        .onAppear {
            viewModel.handleAction(action: .setUserLogin(login: login))
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(R.string.localizable.git_user_detail_screen_title())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
        })
    }

    private func content(uiModel: GitUserDetailUiModel) -> some View {
        ScrollView {
            VStack(alignment: .leading) {
                GitUserDetailCard(
                    name: uiModel.name,
                    avatarUrl: uiModel.avatarUrl,
                    location: uiModel.location
                )
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.top, 16)

                GitUserDetailFollows(
                    followers: uiModel.followers,
                    following: uiModel.following
                )
                .frame(maxWidth: .infinity)
                .padding(.top, 24)
                .padding(.horizontal, 80)

                GitUserDetailBlog(blog: uiModel.blog)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
            }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
        }
    }
}

#Preview {
    GitUserDetailScreen(login: "longdt57")
}
