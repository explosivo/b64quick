//
//  MenuView.swift
//  b64quick
//
//  Created by Zach Nickell on 3/10/21.
//

import Cocoa

class MenuView: NSViewController {
    private var isEncoding = true
    private var lastTextField = ""
    private var lastResultText = ""
    
    @IBOutlet weak var encodeButton: NSButton!
    @IBOutlet weak var decodeButton: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var resultText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        textField.becomeFirstResponder()
    }
    
    func b64Encode(_ text: String!) -> String {
        return Data(text.utf8).base64EncodedString()
    }
    
    func b64Decode(_ text: String!) -> String {
        var decoded_str = ""
        
        if let data = Data(base64Encoded: text, options: .ignoreUnknownCharacters) {
            let decoded = String(data: data, encoding: .utf8)
            decoded_str = decoded != nil ? decoded! : ""
        }
        
        return decoded_str
    }
    
    func toggleEncodeDecode() {
        isEncoding = !isEncoding
        
        var temp = resultText.stringValue
        resultText.stringValue = lastResultText
        lastResultText = temp
        
        temp = textField.stringValue
        textField.stringValue = lastTextField
        lastTextField = temp
    }
    
    @IBAction func encodeDecodeButtonPressed(_ sender: NSButton) {
        if sender == encodeButton && !isEncoding {
            toggleEncodeDecode()
        }
        else if sender == decodeButton && isEncoding {
            toggleEncodeDecode()
        }
    }
    
    @IBAction func copyButtonPressed(_ sender: Any) {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(resultText.stringValue, forType: .string)
    }
}

extension MenuView : NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {
        let text = textField.stringValue
        resultText.stringValue = isEncoding ? b64Encode(text) : b64Decode(text)
    }
}
