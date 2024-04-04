//
//  EmbeddedReaderView.swift
//  EmbeddedReader watchOS Watch App
//
//  Created by Rayan Khan on 3/19/24.
//

import SwiftUI

struct EmbeddedReaderView: View {
    let provisionContents: [String: Any] = readMobileProvision()
    
    var body: some View {
        Form {
            ForEach(provisionContents.keys.sorted(), id: \.self) { key in
                Section(header: Text(key).font(.headline)) {
                    if let arrayValue = provisionContents[key] as? [Any] {
                        ForEach(arrayValue.indices, id: \.self) { index in
                            Text(String(describing: arrayValue[index]))
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text(valueToString(provisionContents[key]))
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .navigationBarTitle("embedded.mobileprovision")
    }
    
    static func readMobileProvision() -> [String: Any] {
        guard let provisionPath = Bundle.main.url(forResource: "embedded", withExtension: "mobileprovision"),
              let data = try? Data(contentsOf: provisionPath) else {
            return [:]
        }
        
        guard let plistString = extractPlistString(from: data),
              let plistData = plistString.data(using: .utf8),
              let result = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil) as? [String: Any] else {
            return [:]
        }
        
        return result
    }
    
    static func extractPlistString(from data: Data) -> String? {
        guard let startRange = data.range(of: Data("<?xml".utf8)),
              let endRange = data.range(of: Data("</plist>".utf8)) else {
            return nil
        }
        
        let plistData = data.subdata(in: startRange.lowerBound..<endRange.upperBound)
        return String(data: plistData, encoding: .utf8)
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
    EmbeddedReaderView()
}
