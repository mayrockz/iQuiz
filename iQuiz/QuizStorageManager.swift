//
//  QuizStorageManager.swift
//  iQuiz
//



import Foundation

class QuizStorageManager
{

    static let shared = QuizStorageManager()
    private init() {}

    private var fileURL: URL
    {
        let documents = FileManager.default.urls(for: .documentDirectory,
                                                 in: .userDomainMask).first!
        return documents.appendingPathComponent("quizzes.json")
    }

    func save(_ quizzes: [Quiz])
    {
        do
        {
            let data = try JSONEncoder().encode(quizzes)
            try data.write(to: fileURL)
            print("Saved quizzes locally")
        }
        catch
        {
            print("Error saving quizzes:", error)
        }
    }

    func load() -> [Quiz]?
    {
        do
        {
            let data = try Data(contentsOf: fileURL)
            let quizzes = try JSONDecoder().decode([Quiz].self, from: data)
            print("Loaded quizzes from local storage.")
            return quizzes
        }
        catch
        {
            print("No local quizzes found.")
            return nil
        }
    }
}
