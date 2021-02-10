//
//  ContentView.swift
//  ReadingAndWritingFilesInSwiftUI
//
//  Created by ramil on 10.02.2021.
//

import SwiftUI

struct ContentView: View {
    @State private var text = ""
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.05)
            VStack {
                TextEditor(text: $text)
                    .cornerRadius(10)
                    .padding()
                
                HStack {
                    Spacer()
                    Button(action: {
                        writeTo(file: "appText.txt", value: text, newline: false, overwrite: true)
                    }, label: {
                        Text("Save")
                            .foregroundColor(.primary)
                    }).padding()
                    Spacer()
                    Button(action: {
                        text = readFrom(file: "appText.txt")
                    }, label: {
                        Text("Load")
                            .foregroundColor(.primary)
                    }).padding()
                    Spacer()
                }
            }
        }
    }
    
    private func readFrom(file: String) -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pathToFile = (paths as NSString).appendingPathComponent(file)
        
        if FileManager.default.fileExists(atPath: pathToFile) {
            return String(data: NSData(contentsOfFile: pathToFile)! as Data, encoding: String.Encoding.utf8)!
        } else {
            return ""
        }
    }
    
    private func writeTo(file: String, value: String, newline: Bool, overwrite: Bool) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let dir: String = paths[0]
        let filePath = "\(dir)/\(file)"
        if !overwrite {
            if newline {
                try! (readFrom(file: file) + "\n" + value).write(toFile: filePath, atomically: true, encoding: .utf8)
            } else {
                try! (readFrom(file: file) + value).write(toFile: filePath, atomically: true, encoding: .utf8)
            }
        } else {
            try! value.write(to: URL(fileURLWithPath: filePath), atomically: true, encoding: .utf8)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
