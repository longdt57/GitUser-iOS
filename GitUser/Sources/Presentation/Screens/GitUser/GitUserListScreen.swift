//
//  GitUserListScreenView.swift
//  iOS MVVM
//
//  Created by Long Do on 31/12/2024.
//

import SwiftUI
import Resolver
import Domain

struct GitUserListScreen: View {
    
    @StateObject var viewModel: GitUserListViewModel = Resolver.resolve()
    
    var body: some View {
        NavigationView {
            VStack {
                if (viewModel.uiModel.users.isEmpty.not()) {
                    userListView()
                } else if (viewModel.isLoading().not()) {
                    GitUserListEmpty(onRefresh: {
                        viewModel.handleAction(action: .loadIfEmpty)
                    })
                }
            }
            .showLoading(loadingState:  $viewModel.loading)
            .showError(error: $viewModel.error, primaryAction: {
                viewModel.onErrorPrimaryAction()
            }, secondaryAction: {
                viewModel.onErrorSecondaryAction()
            })
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
            onClick: { user in  },
            onLoadMore: { viewModel.handleAction(action: .loadMore)}
        )
    }
}

#Preview {
    GitUserListScreen()
}


