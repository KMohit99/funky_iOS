//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import connectivity_plus_macos
import firebase_auth
import firebase_core
import nb_utils
import path_provider_macos
import photo_manager
import shared_preferences_macos
import sqflite

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  ConnectivityPlugin.register(with: registry.registrar(forPlugin: "ConnectivityPlugin"))
  FLTFirebaseAuthPlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseAuthPlugin"))
  FLTFirebaseCorePlugin.register(with: registry.registrar(forPlugin: "FLTFirebaseCorePlugin"))
  NbUtilsPlugin.register(with: registry.registrar(forPlugin: "NbUtilsPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  ImageScannerPlugin.register(with: registry.registrar(forPlugin: "ImageScannerPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
}
