//
//  QuestionViewController.swift
//  iQuiz
//



import UIKit

class QuestionViewController: UIViewController
{
    private let quiz: Quiz
    private var currentQuestionIndex: Int
    private var score: Int
    private var selectedAnswerIndex: Int?
    private let questionLabel = UILabel()
    private let stackView = UIStackView()
    private let submitButton = UIButton(type: .system)
    private var answerButtons: [UIButton] = []
    private let hintLabel = UILabel()

    init(quiz: Quiz, currentQuestionIndex: Int = 0, score: Int = 0)
    {
        self.quiz = quiz
        self.currentQuestionIndex = currentQuestionIndex
        self.score = score
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
        title = quiz.title
        
        setupUI()
        setupGestures()
        showQuestion()
    }

    private func setupUI()
    {
        questionLabel.numberOfLines = 0
        questionLabel.translatesAutoresizingMaskIntoConstraints = false

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false

        submitButton.setTitle("Submit", for: .normal)
        submitButton.isEnabled = false
        submitButton.alpha = 0.5
        submitButton.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
        hintLabel.text = "Swipe right to continue or swipe left to go back"
        hintLabel.font = UIFont.systemFont(ofSize: 12)
        hintLabel.textColor = .secondaryLabel
        hintLabel.textAlignment = .center
        hintLabel.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(questionLabel)
        view.addSubview(stackView)
        view.addSubview(submitButton)
        view.addSubview(hintLabel)

        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            submitButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            hintLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            hintLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func showQuestion()
    {
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text

        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        answerButtons.removeAll()
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
        submitButton.alpha = 0.5

        for (index, answer) in question.answers.enumerated()
        {
            var config = UIButton.Configuration.plain()
            config.title = answer
            //config.baseForegroundColor = .label
            config.contentInsets = NSDirectionalEdgeInsets(
                top: 12,
                leading: 12,
                bottom: 12,
                trailing: 12
            )

            let button = UIButton(configuration: config)
            button.tag = index
            button.contentHorizontalAlignment = .leading
            button.layer.cornerRadius = 8
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            //button.backgroundColor = .clear

            button.addTarget(self, action: #selector(answerSelected(_:)), for: .touchUpInside)

            stackView.addArrangedSubview(button)
            answerButtons.append(button)
        }
    }

    @objc private func answerSelected(_ sender: UIButton)
   {
       selectedAnswerIndex = sender.tag

       for button in answerButtons
       {
           button.backgroundColor = .clear
           button.layer.borderColor = UIColor.systemGray4.cgColor
       }

       sender.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
       sender.layer.borderColor = UIColor.systemBlue.cgColor

       submitButton.isEnabled = true
       submitButton.alpha = 1.0
   }

    @objc private func submitTapped()
    {
        guard let selected = selectedAnswerIndex else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred()

        let question = quiz.questions[currentQuestionIndex]
        let isCorrect = selected == question.correctIndex

        if isCorrect { score += 1 }

        let answerVC = AnswerViewController(
            quiz: quiz,
            currentQuestionIndex: currentQuestionIndex,
            score: score,
            wasCorrect: isCorrect
        )

        navigationController?.pushViewController(answerVC, animated: true)
    }
    
    private func setupGestures()
    {
        // submit on swipe right
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeLeft))
        swipeLeft.direction = .right
        view.addGestureRecognizer(swipeLeft)

        // abandon quiz on swipe left
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeRight))
        swipeRight.direction = .left
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func handleSwipeRight()
    {
        // submit only if an answer is selected
        if selectedAnswerIndex != nil
        {
            submitTapped()
        }
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
