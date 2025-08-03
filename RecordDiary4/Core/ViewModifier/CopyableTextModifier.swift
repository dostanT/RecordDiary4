//
//  CopyableTextModifier.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 03.08.2025.
//
import SwiftUI

struct CopyableTextModifier: ViewModifier {
    let textToCopy: String
    @State private var showCopied = false

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                UIPasteboard.general.string = textToCopy
                HapticService.instance.light()
                withAnimation {
                    showCopied = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation {
                        showCopied = false
                    }
                }
            }
            .overlay(alignment: .top) {
                if showCopied {
                    Text("Copied")
                        .pinkAndCozyTextModifier(fontSize: 12)
                        .offset(y: -12)
                }
            }
    }
}

extension View {
    func copyableText(_ text: String) -> some View {
        self.modifier(CopyableTextModifier(textToCopy: text))
    }
}

