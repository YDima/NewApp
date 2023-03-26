//
//  Keychain.swift
//  New
//
//  Created by Dmytro Yurchenko on 24.03.2023.
//

import Foundation
import Security

class Keychain {
    
    public static let shared = Keychain()
    
    private let service = "com.example.app"
    
    private func query(forKey key: String) -> [String: Any] {
        var query: [String: Any] = [:]
        query[String(kSecClass)] = kSecClassGenericPassword
        query[String(kSecAttrService)] = service
        query[String(kSecAttrAccount)] = key
        return query
    }
    
    public func setValue(_ value: String, for username: String) -> Bool {
        guard let encodedPassword = value.data(using: .utf8) else {
            return false
        }
        
        var query = query(forKey: username)
        
        var status = SecItemCopyMatching(query as CFDictionary, nil)
        
        switch status {
        case errSecSuccess:
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = encodedPassword
            
            status = SecItemUpdate(query as CFDictionary,
                                   attributesToUpdate as CFDictionary)
            if status != errSecSuccess {
                print("Failed to save login to keychain")
                return false
            }
        case errSecItemNotFound:
            query[String(kSecValueData)] = encodedPassword
            
            status = SecItemAdd(query as CFDictionary, nil)
            if status != errSecSuccess {
                print("Failed to save login to keychain")
                return false
            }
        default:
            print("Failed to save login to keychain")
            return false
        }
        
        return true
    }
    
    public func getValue(for username: String) -> String? {
      var query = query(forKey: username)
      query[String(kSecMatchLimit)] = kSecMatchLimitOne
      query[String(kSecReturnAttributes)] = kCFBooleanTrue
      query[String(kSecReturnData)] = kCFBooleanTrue

      var queryResult: AnyObject?
      let status = withUnsafeMutablePointer(to: &queryResult) {
        SecItemCopyMatching(query as CFDictionary, $0)
      }

      switch status {
      case errSecSuccess:
        guard
          let queriedItem = queryResult as? [String: Any],
          let passwordData = queriedItem[String(kSecValueData)] as? Data,
          let password = String(data: passwordData, encoding: .utf8)
          else {
            return nil
        }
        return password
      case errSecItemNotFound:
        return nil
      default:
        return nil
      }
    }
    
    func saveLogin(_ login: String) {
        let query = [
            kSecValueData: login.data(using: .utf8)!,
            kSecAttrService: service,
            kSecAttrAccount: login,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Try updating the existing item first
        var status = SecItemAdd(query, nil)
        
        if status != errSecSuccess {
            print("Failed to save login to keychain")
        }
    }
    
    func savePassword(for username: String, _ password: String) {
        let query = self.query(forKey: username)
        let attributes: [CFString: Any] = [
            kSecValueData: password.data(using: .utf8)!
        ]
        var result: CFTypeRef?
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
//        if status != errSecSuccess {
//            var query = self.query(forKey: username)
//            query[kSecValueData] = password.data(using: .utf8)!
//            let status = SecItemAdd(query as CFDictionary, &result)
//            if status != errSecSuccess {
//                print("Failed to save password to keychain")
//            }
//        }
    }
    
//    func login(for username: String) -> String? {
//        var query = self.query(forKey: username)
//        query[kSecReturnData] = true
//        var result: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &result)
//        if status == errSecSuccess, let data = result as? Data {
//            return String(data: data, encoding: .utf8)
//        } else {
//            return nil
//        }
//    }
//
//    func password(for username: String) -> String? {
//        var query = self.query(forKey: username)
//        query[kSecReturnData] = true
//        var result: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, &result)
//        if status == errSecSuccess, let data = result as? Data {
//            return String(data: data, encoding: .utf8)
//        } else {
//            return nil
//        }
//    }
    
}

