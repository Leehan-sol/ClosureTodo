//
//  ClosureViewModel.swift
//  ClosureTodo
//
//  Created by hansol on 2023/12/31.
//

import Foundation

protocol ClosureViewModelProtocol {
    var didChangedClosureTodo: ((ClosureViewModel) -> Void)? { get set }
    var todo: [TodoModel] { get set }
    var todoCount: Int { get }
    var todoDescription: (Int) -> String? { get }
    func addTodo(description: String)
    func removeTodo(at index: Int)
    func todoDescription(at index: Int) -> String?
}

class ClosureViewModel: ClosureViewModelProtocol {
    var didChangedClosureTodo: ((ClosureViewModel) -> Void)?
    
    // 3. todo가 변하면 didChangedClosureViewModel()호출
    var todo: [TodoModel] = [] {
        didSet {
            didChangedClosureTodo?(self)
        }
    }
    
    var todoCount: Int {
        return todo.count
    }
    
    var todoDescription: (Int) -> String? {
        return { [weak self] index in
            return self?.todoDescription(at: index)
        }
    }
    
    // 2. addTodo가 호출되면 뷰모델의 todo가 변함
    func addTodo(description: String){
        todo.append(TodoModel(description: description))
    }
    
    func removeTodo(at index: Int) {
        todo.remove(at: index)
    }
    
    func todoDescription(at index: Int) -> String? {
        guard index >= 0, index < todo.count else {
            return nil
        }
        return todo[index].description
    }
    
}
