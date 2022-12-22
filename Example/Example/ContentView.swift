//
//  ContentView.swift
//  Example
//
//  Created by Kristof Kalai on 2022. 12. 22..
//

import MaskedTabView
import PagingTabView
import SwiftUI

struct ContentView: View {
    struct Tab: Identifiable, Equatable {
        var id: String {
            title
        }
        let title: String
    }

    @ObservedObject private var viewModel: PagingTabViewViewModel
    private let padding = EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
    private let tabs = [Tab(title: "first"), Tab(title: "second"), Tab(title: "third")]
    private let bounces = true

    init(viewSize: CGSize, horizontal: Bool = true) {
        self.viewModel = PagingTabViewViewModel(viewSize: .init(width: viewSize.width - padding.leading - padding.trailing,
                                                                height: viewSize.height - padding.top - padding.bottom),
                                                horizontal: horizontal)
    }
}

extension ContentView {
    var body: some View {
        MaskedTabView(offset: $viewModel.offset, index: $viewModel.index, overlayColor: .red, bounces: bounces, tabs: tabs, tabView: tabView, content: content)
            .padding(padding)
    }
}

extension ContentView {
    private func tabView(tab: Tab, isSelected: Bool) -> some View {
        HStack(spacing: .zero) {
            Image(systemName: "circle")
                .frame(width: 16, height: 16)
            Spacer()
                .frame(width: 8)
            Text(tab.title)
        }
        .fontWeight(isSelected ? .black : .light)
        .foregroundColor(isSelected ? .white : .red)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }

    private func content() -> some View {
        GeometryReader {
            PagingTabView(offset: $viewModel.offset, index: $viewModel.index, viewSize: $0.size, bounces: bounces, horizontal: true) {
                ForEach(tabs) { tab in
                    VStack(spacing: .zero) {
                        Image(systemName: "circle")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.red)
                        Text(tab.title)
                    }
                    .padding()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {
            ContentView(viewSize: $0.size)
        }
    }
}
