//
//  GamesFlowView.swift
//
//  Created by Nikita Makhov on 05.02.2026.
//

import SwiftUI

struct GamesFlowView: View {
    @StateObject private var vm = GamesListViewModel()

    var body: some View {
        NavigationStack {
            GamesListView(vm: vm)
                .navigationTitle("Матчи")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button(vm.contextTitle) { vm.isLeaguePickerPresented = true }
                    }
                }
                .sheet(isPresented: $vm.isLeaguePickerPresented) {
                    LeagueSeasonPickerView(vm: vm)
                }
                .task { await vm.bootstrapIfNeeded() }
        }
    }
}
