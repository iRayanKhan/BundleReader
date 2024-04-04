//
//  PlistReaderView.swift
//  EmbeddedReader
//
//  Created by Rayan Khan on 1/16/24.
//

import SwiftUI

struct PlistReaderView: View {
    let plistContents: [String: Any] = readPlist()
    
    var body: some View {
        Form {
            ForEach(plistContents.keys.sorted(), id: \.self) { key in
                Section(header: Text(key).font(.headline)) {
                    if let arrayValue = plistContents[key] as? [Any] {
                        ForEach(arrayValue.indices, id: \.self) { index in
                            Text(String(describing: arrayValue[index]))
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text(valueToString(plistContents[key]))
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationBarTitle("Info.plist")
    }
    
    static func readPlist() -> [String: Any] {
        guard let infoPlistPath = Bundle.main.url(forResource: "Info", withExtension: "plist"),
              let data = try? Data(contentsOf: infoPlistPath),
              let result = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] else {
            return [:]
        }
        return result
    }
    
    private func valueToString(_ value: Any?) -> String {
        guard let value = value else { return "nil" }
        if let stringValue = value as? String {
            return stringValue
        } else if let intValue = value as? Int {
            return String(intValue)
        } else if value is [Any] {
            return "Array (see contents below)"
        } else if let dictValue = value as? [String: Any] {
            return dictValue.map { "\($0.key): \($0.value)" }.joined(separator: ", ")
        } else {
            return String(describing: value)
        }
    }
}


#Preview {
    PlistReaderView()
}




