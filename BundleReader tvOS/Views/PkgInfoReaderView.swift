//
//  PkgInfoReaderView.swift
//  BundleReader tvOS
//
//  Created by Rayan Khan on 4/4/24.
//

import SwiftUI

struct PkgInfoReaderView: View {
    let pkgInfoContent: String = readPkgInfo()
    
    var body: some View {
        Form {
            Section(header: Text("PkgInfo").font(.headline)) {
                Text(pkgInfoContent)
                    .font(.body)
                    .foregroundColor(.gray)
            }
        }
        .navigationBarTitle("PkgInfo")
    }
    
    static func readPkgInfo() -> String {
        guard let pkgInfoPath = Bundle.main.url(forResource: "PkgInfo", withExtension: nil),
              let content = try? String(contentsOf: pkgInfoPath, encoding: .utf8) else {
            return "Content not found"
        }
        return content
    }
}

#Preview {
    PkgInfoReaderView()
}
