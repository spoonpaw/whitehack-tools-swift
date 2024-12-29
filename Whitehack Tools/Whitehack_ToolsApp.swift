import SwiftUI
#if os(macOS)
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
    }
}
#else
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(" App launched with options: \(String(describing: launchOptions))")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print(" App opened with URL: \(url)")
        print(" URL options: \(options)")
        return true
    }
}
#endif

@main
struct Whitehack_ToolsApp: App {
    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #else
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif
    
    @StateObject private var characterStore = CharacterStore()
    @StateObject private var importViewModel = CharacterImportViewModel()
    @State private var openURL: URL?
    @State private var showingImportSheet = false
    
    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            CharacterListView(showingImportSheet: $showingImportSheet)
                .frame(minWidth: 375, idealWidth: 500, maxWidth: .infinity, minHeight: 600)
                .environmentObject(characterStore)
                .environmentObject(importViewModel)
            #else
            NavigationView {
                CharacterListView(showingImportSheet: $showingImportSheet)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(characterStore)
            .environmentObject(importViewModel)
            .onOpenURL { url in
                print(" onOpenURL called with URL: \(url)")
                print(" URL scheme: \(url.scheme ?? "none")")
                print(" URL path: \(url.path)")
                openURL = url
                importViewModel.handleIncomingFile(url: url)
                showingImportSheet = true
            }
            #endif
        }
        #if os(macOS)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        #endif
    }
}
