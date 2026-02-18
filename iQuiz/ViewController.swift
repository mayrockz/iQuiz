//
//  ViewController.swift
//  iQuiz
//



import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    private var quizzes: [Quiz] =
    [
        Quiz(title: "Mathematics",
             description: "Test your math knowledge!",
             iconName: "function"),
        
        Quiz(title: "Marvel Super Heroes",
             description: "Test your Marvel Super Hero knowledge!",
             iconName: "bolt.fill"),
        
        Quiz(title: "Science",
             description: "Test your science knowledge!",
             iconName: "atom")
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
}
