//
//  ViewController.swift
//  iQuiz
//



import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    private let defaultURL = "http://tednewardsandbox.site44.com/questions.json"
    
    private var quizzes: [Quiz] = []
    private let tableView = UITableView()
    
    private let refreshControl = UIRefreshControl()
    private var refreshTimer: Timer?
    
    @objc private func handleRefresh()
    {
        let savedURL = UserDefaults.standard.string(forKey: "quizURL") ?? defaultURL
        downloadQuizzes(from: savedURL)
    }
    
    private func startAutoRefresh()
    {
        refreshTimer?.invalidate()

        let interval = UserDefaults.standard.double(forKey: "refreshInterval")

        guard interval > 0 else { return }

        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval,
                                             repeats: true) { _ in
            let savedURL = UserDefaults.standard.string(forKey: "quizURL") ?? self.defaultURL
            self.downloadQuizzes(from: savedURL)
        }
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()

        title = "iQuiz"
        view.backgroundColor = .systemBackground
        
        let savedURL = UserDefaults.standard.string(forKey: "quizURL") ?? defaultURL

        downloadQuizzes(from: savedURL)

        setupTableView()
        setupNavigationBar()
        startAutoRefresh()
    }

    private func setupTableView()
    {
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(QuizTableViewCell.self,
                           forCellReuseIdentifier: QuizTableViewCell.identifier)

        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh),
                                 for: .valueChanged)
        tableView.refreshControl = refreshControl

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
            message: "Enter quiz data URL",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.text = UserDefaults.standard.string(forKey: "quizURL") ??
                             "http://tednewardsandbox.site44.com/questions.json"
        }
        
        let checkNow = UIAlertAction(title: "Save", style: .default) { _ in
            let urlString = alert.textFields?[0].text ?? ""
            let intervalText = alert.textFields?[1].text ?? ""

            UserDefaults.standard.set(urlString, forKey: "quizURL")

            if let interval = Double(intervalText) {
                UserDefaults.standard.set(interval, forKey: "refreshInterval")
            }

            self.downloadQuizzes(from: urlString)
            self.startAutoRefresh()
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Refresh interval (seconds)"
            let savedInterval = UserDefaults.standard.double(forKey: "refreshInterval")
            if savedInterval > 0 {
                textField.text = "\(savedInterval)"
            }
            textField.keyboardType = .numberPad
        }
        
        alert.addAction(checkNow)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }

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
    
    private func downloadQuizzes(from urlString: String)
    {
        NetworkManager.shared.fetchQuizzes(from: urlString) { result in
            self.refreshControl.endRefreshing()

            switch result
            {
                case .success(let quizzes):
                    self.quizzes = quizzes
                    self.tableView.reloadData()

                    QuizStorageManager.shared.save(quizzes)

                case .failure:
                    print("Network failed. Trying local storage...")

                if let localQuizzes = QuizStorageManager.shared.load()
                {
                    self.quizzes = localQuizzes
                    self.tableView.reloadData()
                }
                else
                {
                    self.showNetworkError()
                }
            }
        }
    }
    
    private func showNetworkError()
    {
        let alert = UIAlertController(
            title: "Network error!",
            message: "Unable to download quiz data. Please check your connection.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

