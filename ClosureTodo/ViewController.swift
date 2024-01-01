//
//  ViewController.swift
//  ClosureTodo
//
//  Created by hansol on 2023/12/31.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI Component
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let closureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("투두추가(클로저)", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(closureButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Properties
    var closureViewModel: ClosureViewModelProtocol
    
    // 0. 의존성 주입을 통해 ClosureViewModel 전달 (의존성 제거)
    init(closureVM: ClosureViewModelProtocol) {
        self.closureViewModel = closureVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
        setBindings()
    }
    
    // MARK: - Method
    func setUI(){
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        view.addSubview(closureButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            
            closureButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            closureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
    }
    
    func setTableView(){
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    
    // MARK: - @objc
    // 클로저이용 1. addButton을 누르면 뷰모델의 addTodo() 호출
    @objc func closureButtonTapped() {
        let alert = UIAlertController(title: "Add Todo", message: "Enter a new todo item", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Todo item"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let newTodo = alert.textFields?.first?.text {
                self?.closureViewModel.addTodo(description: newTodo)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    // 4. 뷰모델의 didChangedClosureViewModel 정의
    func setBindings(){
        closureViewModel.didChangedClosureTodo = { [weak self] viewModel in
            self?.tableView.reloadData()
        }
    }
    
}


// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            closureViewModel.removeTodo(at: indexPath.row)
        }
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return closureViewModel.todoCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          
          cell.textLabel?.text = closureViewModel.todoDescription(indexPath.row)

          return cell
      }
    
}
