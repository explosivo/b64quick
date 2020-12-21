//
//  ContentView.swift
//  b64quick
//
//

import SwiftUI

struct ContentView: View {
    @State private var isEncoding = true
    @State private var utf_str: String = ""
    @State private var b64_str: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Picker(selection: $isEncoding, label: Text("")) {
                Text("encode").tag(true)
                Text("decode").tag(false)
            }.pickerStyle(RadioGroupPickerStyle())
            .horizontalRadioGroupLayout()
            .labelsHidden()
            
            TextField("Enter text...", text: isEncoding ? $b64_str : $utf_str)
            
            
            HStack(alignment: .top) {
                Text(" \(convertText(isEncoding: isEncoding, text: isEncoding ? b64_str : utf_str))")
                    .lineLimit(7)
                    .frame(width: 350, alignment: .leading)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: true, vertical: true)
    
                Button(action: {
                    let pasteboard = NSPasteboard.general
                    pasteboard.declareTypes([.string], owner: nil)
                    pasteboard.setString(convertText(isEncoding: isEncoding, text: isEncoding ? b64_str : utf_str), forType: .string)
                }) {
                    if #available(OSX 11.0, *) {
                        Image(systemName: "doc.on.clipboard")
                    } else {
                        Text("copy")
                    }
                }
            }
        }.padding()
    }
}

func convertText(isEncoding: Bool!, text: String!) -> String {
    if isEncoding {
        return Data(text.utf8).base64EncodedString()
    }
    else {
        if let data = Data(base64Encoded: text, options: .ignoreUnknownCharacters) {
            let decoded = String(data: data, encoding: .utf8)
            return decoded != nil ? decoded! : ""
        }
    }
    return ""
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
