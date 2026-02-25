//
//  Question.swift
//  iQuiz
//



import Foundation

struct Question: Codable
{
    let text: String
    let answers: [String]
    let answer: String
    
    var correctIndex: Int
    {
        return answers.firstIndex(of: answer) ?? 0
    }
}
