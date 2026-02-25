//
//  Quiz.swift
//  iQuiz
//



import Foundation

struct Quiz: Codable
{
    let title: String
    let desc: String
    let questions: [ Question ]
    
    var description: String { desc }
    var iconName: String { "questionmark.circle" }
}
