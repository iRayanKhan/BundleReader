//
//  CodeResourcesReaderView.swift
//  BundleReader tvOS
//
//  Created by Rayan Khan on 4/4/24.
//

import SwiftUI

struct CodeResourcesReaderView: View {
    let codeResourcesContents: [String: Any] = readCodeResources()
    
    var body: some View {
        Form {
            ForEach(codeResourcesContents.keys.sorted(), id: \.self) { key in
                Section(header: Text(key).font(.headline)) {
                    if let arrayValue = codeResourcesContents[key] as? [Any] {
                        ForEach(arrayValue.indices, id: \.self) { index in
                            Text(String(describing: arrayValue[index]))
                                .font(.body)
                                .foregroundColor(.gray)
                        }
                    } else {
                        Text(valueToString(codeResourcesContents[key]))
                            .font(.body)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
    
    static func readCodeResources() -> [String: Any] {
        guard let resourcesPath = Bundle.main.url(forResource: "CodeResources", withExtension: nil, subdirectory: "_CodeSignature"),
              let data = try? Data(contentsOf: resourcesPath),
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
    CodeResourcesReaderView()
}
