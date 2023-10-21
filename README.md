# MaskedTabView
TabView with a mask! 🎭

## Setup

Add the following to `Package.swift`:

```swift
.package(url: "https://github.com/stateman92/MaskedTabView", exact: .init(0, 0, 2))
```

[Or add the package in Xcode.](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app)

## Usage

```swift
MaskedTabView(offset: $viewModel.offset, index: $viewModel.index, overlayColor: .red, bounces: bounces, tabs: tabs, tabView: tabView, content: content)
```

For this you should use a `PagingTabViewViewModel` from [this package](https://github.com/stateman92/PagingTabView). 

For details see the Example app.

## Example

<p style="text-align:center;"><img src="https://github.com/stateman92/MaskedTabView/blob/main/Resources/screenrecording.gif?raw=true" width="50%" alt="Example"></p>
