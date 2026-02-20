//
//  AnswerViewController.swift
//  iQuiz
//



import UIKit

class AnswerViewController: UIViewController
{
    private let quiz: Quiz
    private var currentQuestionIndex: Int
    private let score: Int
    private let wasCorrect: Bool
    //private let selectedAnswer: Int
    private let hintLabel = UILabel()

    init(quiz: Quiz, currentQuestionIndex: Int, score: Int, wasCorrect: Bool)
    {
        self.quiz = quiz
        self.currentQuestionIndex = currentQuestionIndex
        self.score = score
        self.wasCorrect = wasCorrect
        
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not yet been implemented")
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupUI()
        setupGestures()
    }

    private func setupUI()
    {
        let question = quiz.questions[currentQuestionIndex]

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let resultText = wasCorrect ? "Correct!" : "Wrong!"
        let correctAnswer = question.answers[question.correctIndex]

        label.text = """
        \(resultText)

        Correct Answer:
        \(correctAnswer)
        """

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        hintLabel.text = "Swipe right to continue or swipe left to go back"
        hintLabel.font = UIFont.systemFont(ofSize: 12)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(nextButton)
        view.addSubview(hintLabel)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            nextButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        
            hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func nextTapped()
    {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let nextIndex = currentQuestionIndex + 1

        if nextIndex < quiz.questions.count
        {
            let questionVC = QuestionViewController(
                quiz: quiz,
                currentQuestionIndex: nextIndex,
                score: score
            )
            navigationController?.pushViewController(questionVC, animated: true)
        }
        else
        {
            let finishedVC = FinishedViewController(
                score: score,
                total: quiz.questions.count
            )
            navigationController?.pushViewController(finishedVC, animated: true)
        }
    }
    
    private func setupGestures()
    {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .right
        view.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .left
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipeRight()
    {
        nextTapped()
    }

    @objc private func handleSwipeLeft()
    {
        confirmAbandonQuiz()
    }
    
    private func confirmAbandonQuiz()
    {
        let alert = UIAlertController(
            title: "Abandon quiz?",
            message: "Your current progress will be lost!",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Abandon", style: .destructive) { _ in self.navigationController?.popToRootViewController(animated: true)
        })

        present(alert, animated: true)
    }
}
