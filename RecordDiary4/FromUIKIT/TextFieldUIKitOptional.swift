//
//  TextFieldUIKitOptional.swift
//  RecordDiary4
//
//  Created by Dostan Turlybek on 03.08.2025.
//

import Foundation
import SwiftUI

struct TextFieldUIKitOptional: UIViewRepresentable {
    
    @Binding var text: String?
    var placeholder: String
    let placeholderColor: UIColor
    var fontSize: CGFloat
    var fontName: String
    var onSubmit: () -> Void
    
    init(text: Binding<String?>, placeholder: String = "Default placeholder...", placeholderColor: UIColor = .red, fontSize: CGFloat = 28, fontName: String = "BebasNeue-Regular", onSubmit: @escaping () -> Void = {}) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
        self.fontSize = fontSize
        self.fontName = fontName
        self.onSubmit = onSubmit
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textfield = getTextField()
        textfield.delegate = context.coordinator
        return textfield
    }
    
    // from SwiftUI to UIKit
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    private func getTextField() -> UITextField {
        let textfield = UITextField(frame: .zero)
        textfield.font = UIFont(name: fontName, size: fontSize)
        textfield.textColor = UIColor(ColorTheme.pink.color)

        let attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [
                .foregroundColor: placeholderColor,
                .font: UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
            ])
        textfield.attributedPlaceholder = attributedPlaceholder
        return textfield
    }
    
    func updatePlaceholder(_ text: String) -> TextFieldUIKitOptional {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    // from UIKit to SwiftUI
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text, onSubmit: onSubmit)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String?
        var onSubmit: () -> Void
        
        init(text: Binding<String?>, onSubmit: @escaping () -> Void) {
                self._text = text
                self.onSubmit = onSubmit
            }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            onSubmit()
            return true
        }
    }
    
}
