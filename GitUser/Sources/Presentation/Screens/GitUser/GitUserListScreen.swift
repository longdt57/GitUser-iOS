//
//  GitUserListScreen.swift
//  Git Users
//
//  Created by Long Do on 31/12/2024.
//

import Domain
import Resolver
import SwiftUI

struct GitUserListScreen: View {

    @StateObject var viewModel: GitUserListViewModel = Resolver.resolve()

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.uiModel.users.isEmpty.not() {
                    userListView()
                } else if viewModel.isLoading().not() {
                    GitUserListEmpty(onRefresh: {
                        viewModel.handleAction(action: .loadIfEmpty)
                    })
                }
            }
            .showLoading(loadingState: $viewModel.loading)
            .showError(
                error: $viewModel.error,
                primaryAction: { errorState in
                    viewModel.onErrorPrimaryAction(errorState: errorState)
                }, secondaryAction: { errorState in
                    viewModel.onErrorSecondaryAction(errorState: errorState)
                }
            )
            .onAppear {
                viewModel.handleAction(action: .loadIfEmpty)
            }
            .navigationTitle(R.string.localizable.git_user_list_screen_title())
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func userListView() -> some View {
        GitUserList(
            users: viewModel.uiModel.users,
            onClick: { _ in },
            onLoadMore: { viewModel.handleAction(action: .loadMore) }
        )
    }
}

#Preview {
    GitUserListScreen()
}
