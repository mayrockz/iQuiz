//
//  FinishedViewController.swift
//  iQuiz
//



import UIKit

class FinishedViewController: UIViewController
{
    private let score: Int
    private let total: Int

    init(score: Int, total: Int)
    {
        self.score = score
        self.total = total
        
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
    }

    private func setupUI()
    {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        let message: String
        if score == total
        {
            message = "Perfect!"
        }
        else if score >= total / 2
        {
            message = "Almost!"
        }
        else
        {
            message = "Better luck next time!"
        }

        label.text = """
        \(message)

        You got \(score) out of \(total) correct!
        """

        let doneButton = UIButton(type: .system)
        doneButton.setTitle("Back to Topics", for: .normal)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(label)
        view.addSubview(doneButton)

        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            doneButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc private func doneTapped()
    {
        navigationController?.popToRootViewController(animated: true)
    }
}
