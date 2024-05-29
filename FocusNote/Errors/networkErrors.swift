//
//  networkErrors.swift
//  FocusNote
//
//  Created by Joseph Garcia on 29/05/24.
//

import Foundation


enum GHError {
    
}

class QuoteManager {
    
    private let quoteKey = "storedQuote"
    private let timestampKey = "quoteTimestamp"
    private let expirationInterval: TimeInterval = 12 * 60 * 60 // 12 hours in seconds
    
    func loadQuote(completion: @escaping (String) -> Void) {
        if let storedQuote = getStoredQuote(), !isQuoteExpired() {
            completion(storedQuote)
        } else {
            fetchRandomQuote { fetchedQuote in
                if let quote = fetchedQuote {
                    self.storeQuote(quote)
                    completion(quote)
                } else {
                    completion("Failed to load quote")
                }
            }
        }
    }
    
    
    //API Call from Public source https://github.com/lukePeavey/quotable
    private func fetchRandomQuote(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api.quotable.io/random?tags=motivational") else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let quoteText = json["content"] as? String {
                    completion(quoteText)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    private func getStoredQuote() -> String? {
        return UserDefaults.standard.string(forKey: quoteKey)
    }
    
    private func getStoredTimestamp() -> Date? {
        return UserDefaults.standard.object(forKey: timestampKey) as? Date
    }
    
    private func isQuoteExpired() -> Bool {
        guard let storedTimestamp = getStoredTimestamp() else {
            return true
        }
        return Date().timeIntervalSince(storedTimestamp) > expirationInterval
    }
    
    private func storeQuote(_ quote: String) {
        UserDefaults.standard.setValue(quote, forKey: quoteKey)
        UserDefaults.standard.setValue(Date(), forKey: timestampKey)
    }
}
