//
//  NetworkManager.swift
//  iQuiz
//



import Foundation
import UIKit

class NetworkManager
{
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchQuizzes(from urlString: String, completion: @escaping (Result<[Quiz], Error>) -> Void)
    {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0)))
            return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error
            {
                DispatchQueue.main.async
                {
                    completion(.failure(error))
                }
                return
            }
            
            guard let data = data else
            {
                DispatchQueue.main.async
                {
                    completion(.failure(NSError(domain: "No Data", code: 0)))
                }
                return
            }
            
            do
            {
                let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
                
                DispatchQueue.main.async
                {
                    completion(.success(quizzes))
                }
            }
            catch
            {
                DispatchQueue.main.async
                {
                    completion(.failure(error))
                }
            }
            
        }.resume()
    }
}
