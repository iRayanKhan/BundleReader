//
//  ContentView.swift
//  EmbeddedReader watchOS Watch App
//
//  Created by Rayan Khan on 3/19/24.
//

import SwiftUI

struct ContentView: View {
    @State private var fileNames: [String] = []
    @State private var showEmbeddedReader = false
    @State private var showPlistReader = false
    @State private var showPkgInfoReader = false
    
    var body: some View {
        NavigationView {
            VStack() {
                List(fileNames, id: \.self) { fileName in
                    if isDirectory(fileName: fileName) {
                        NavigationLink(fileName, destination: FolderContentView(folderName: fileName))
                    } else if fileName == "embedded.mobileprovision" {
                        NavigationLink(
                            fileName,
                            destination: EmbeddedReaderView(),
                            isActive: $showEmbeddedReader
                        )
                    } else if fileName == "PkgInfo" {
                        NavigationLink(
                            fileName,
                            destination: PkgInfoReaderView(),
                            isActive: $showPkgInfoReader
                        )
                    } else if fileName == "Info.plist" {
                        NavigationLink(
                            fileName,
                            destination: PlistReaderView(),
                            isActive: $showPlistReader
                        )
                    }
                    else {
                        Text(fileName)
                    }
                }
            }
            .onAppear(perform: loadFiles)
            .navigationTitle("Bundle Viewer")
        }
    }
    
    func loadFiles() {
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        do {
            let contents = try fileManager.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: [.isDirectoryKey])
            self.fileNames = contents.map { $0.lastPathComponent }
        } catch {
            print("Error reading bundle contents: \(error)")
        }
    }
    
    func isDirectory(fileName: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = Bundle.main.bundleURL.appendingPathComponent(fileName).path
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: filePath, isDirectory: &isDir) {
            return isDir.boolValue
        }
        return false
    }
}

struct FolderContentView: View {
    var folderName: String
    @State private var fileNames: [String] = []
    @State private var showCodeResourcesView : Bool = false
    
    var body: some View {
        List(fileNames, id: \.self) { fileName in
            if fileName == "CodeResources" {
                NavigationLink(
                    fileName,
                    destination: CodeResourcesReaderView(),
                    isActive: $showCodeResourcesView
                )
            } else {
                Text(fileName)
            }
        }
        .onAppear(perform: loadFiles)
        .navigationTitle(folderName)
    }
    
    func loadFiles() {
        let fileManager = FileManager.default
        let folderURL = Bundle.main.bundleURL.appendingPathComponent(folderName)
        do {
            let contents = try fileManager.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            self.fileNames = contents.map { $0.lastPathComponent }
        } catch {
            print("Error reading folder contents: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
