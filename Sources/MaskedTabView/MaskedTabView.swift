//
//  MaskedTabView.swift
//
//
//  Created by Kristof Kalai on 2022. 12. 22..
//

import SwiftUI

public struct MaskedTabView<Content: View, TabView: View, Tab: Identifiable & Equatable>: View {
    @State private var isTapped = false
    @State private var isAnimating = false
    @Binding private var offset: CGFloat
    @Binding private var index: Int
    private let overlayColor: Color
    private let bounces: Bool
    private let tabs: [Tab]
    private let tabView: (Tab, Bool) -> TabView
    private let content: () -> Content

    public init(offset: Binding<CGFloat>,
                index: Binding<Int>,
                overlayColor: Color,
                bounces: Bool = true,
                tabs: [Tab],
                tabView: @escaping (Tab, Bool) -> TabView,
                content: @escaping () -> Content) {
        self._offset = offset
        self._index = index
        self.overlayColor = overlayColor
        self.bounces = bounces
        self.tabs = tabs
        self.tabView = tabView
        self.content = content
    }
}

extension MaskedTabView {
    public var body: some View {
        GeometryReader { proxy in
            VStack(spacing: .zero) {
                header(size: proxy.size)
                content()
            }
        }
    }
}

extension MaskedTabView {
    private func header(size: CGSize) -> some View {
        HStack(spacing: .zero) {
            ForEach(tabs) {
                tabView($0, false)
                    .frame(width: tabWidth(size: size))
            }
        }
        .overlay(alignment: .leading) {
            overlay(size: size)
        }
    }

    private func overlay(size: CGSize) -> some View {
        Capsule()
            .fill(overlayColor)
            .overlay(alignment: .leading) {
                HStack(spacing: .zero) {
                    ForEach(tabs) {
                        overlayTab(tab: $0, size: size)
                    }
                    .offset(x: -tabOffset(size: size))
                }
            }
            .mask(Capsule())
            .offset(x: tabOffset(size: size))
            .frame(width: tabWidth(size: size))
    }

    private func overlayTab(tab: Tab, size: CGSize) -> some View {
        tabView(tab, true)
            .frame(width: tabWidth(size: size))
            .contentShape(Capsule())
            .onTapGesture {
                guard !isAnimating, let index = tabs.firstIndex(of: tab) else { return }
                isTapped = true
                isAnimating = true

                offset = CGFloat(index) * size.width

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isTapped = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    isAnimating = false
                }
            }
    }

    private func tabOffset(size: CGSize) -> CGFloat {
        let adjustedOffset: CGFloat = {
            if isTapped {
                return CGFloat(index) * size.width
            }
            return offset
        }()
        if !bounces {
            if adjustedOffset <= .zero {
                return .zero
            } else if offset >= CGFloat(tabs.count) * tabWidth(size: size) {
                return CGFloat(tabs.count - 1) * tabWidth(size: size)
            }
        }
        return adjustedOffset / CGFloat(tabs.count)
    }

    private func tabWidth(size: CGSize) -> CGFloat {
        size.width / CGFloat(tabs.count)
    }
}
