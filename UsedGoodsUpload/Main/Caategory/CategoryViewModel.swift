

import RxCocoa
import RxSwift

struct CategoryViewModel {
    
    let disposeBag = DisposeBag()
    
    //ViewModel -> View
    let cellData: Driver<[Category]>
    let pop: Signal<Void>
    
    //View -> ViewModel
    let itemSelected = PublishRelay<Int>()
    
    
    //ViewModel -> ParentViewModel
    let selectedCategory = PublishSubject<Category>()
    
    init(){
        let categories = [
            Category(id: 1, name: "1"),
            Category(id: 2, name: "2"),
            Category(id: 3, name: "3"),
            Category(id: 4, name: "4"),
            Category(id: 5, name: "5"),
            Category(id: 6, name: "6"),
            Category(id: 7, name: "7"),
            Category(id: 8, name: "8"),
            Category(id: 9, name: "9"),
            Category(id: 10, name: "10"),
            Category(id: 11, name: "11")
        ]
        
        self.cellData = Driver.just(categories)
        
        self.itemSelected
            .map{categories[$0]}
            .bind(to: selectedCategory)
            .disposed(by: disposeBag)
        
        self.pop = itemSelected
            .map{_ in Void()}
            .asSignal(onErrorSignalWith: .empty())
    }
    
}
