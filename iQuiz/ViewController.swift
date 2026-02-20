//
//  ViewController.swift
//  iQuiz
//



import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    private var quizzes: [Quiz] =
    [
        Quiz(
            title: "Mathematics",
            description: "Test your math knowledge!",
            iconName: "function",
            questions:
            [
                Question(
                    text: "What is 2 + 2?",
                    answers: ["0", "4", "5"],
                    correctIndex: 1
                ),
                Question(
                    text: "What is 10 / 2?",
                    answers: ["0", "20", "5"],
                    correctIndex: 2
                )
            ]
        ),
        Quiz(
            title: "Marvel Super Heroes",
            description: "Test your Marvel knowledge!",
            iconName: "bolt.fill",
            questions:
            [
                Question(
                    text: "Who is Iron Man?",
                    answers: ["Tony Stark", "Steve Rogers", "Thor"],
                    correctIndex: 0
                )
            ]
        ),
        Quiz(
            title: "Science",
            description: "Test your science knowledge!",
            iconName: "atom",
            questions:
            [
                Question(
                    text: "What planet is known as the Red Planet?",
                    answers: ["Mars", "Saturn", "Venus"],
                    correctIndex: 0
                )
            ]
        )
    ]

    private let tableView = UITableView()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "iQuiz"
        view.backgroundColor = .systemBackground

        setupTableView()
        setupNavigationBar()
    }

    private func setupTableView()
    {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(QuizTableViewCell.self, forCellReuseIdentifier: QuizTableViewCell.identifier)

        view.addSubview(tableView)
    }

    private func setupNavigationBar()
    {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(settingsTapped)
        )
    }

    @objc private func settingsTapped()
    {
        let alert = UIAlertController(
            title: "Settings",
            message: "Settings go here",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

// tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return quizzes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: QuizTableViewCell.identifier, for: indexPath) as? QuizTableViewCell else { return UITableViewCell() }
                   
        let quiz = quizzes[indexPath.row]
        
        cell.configure(with: quiz)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedQuiz = quizzes[indexPath.row]
        let questionVC = QuestionViewController(
            quiz: selectedQuiz,
            currentQuestionIndex: 0,
            score: 0
        )
        
        navigationController?.pushViewController(questionVC, animated: true)
    }
}
