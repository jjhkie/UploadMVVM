
import UIKit
import RxSwift
import RxCocoa


class CategoryListViewController: UIViewController{
    let disposeBag = DisposeBag()
    
    let tableView = UITableView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ VM: CategoryViewModel){
        VM.cellData
            .drive(tableView.rx.items){ tv, row, data in
                
                let cell =
                tv.dequeueReusableCell(withIdentifier: "CategoryListCell", for: IndexPath(row: row, section: 0))
                
                cell.textLabel?.text = data.name
                return cell
                
            }
            .disposed(by: disposeBag)
        
        ///pop Event를 받았을 때 emit에 있는 기능이 실행된다.
        VM.pop
            .emit(onNext: {[weak self] _ in
                self?.navigationController?.popViewController(animated: true)
                
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map{ $0.row}
            .bind(to: VM.itemSelected)
            .disposed(by: disposeBag)
    }
    

    
    private func attribute(){
        view.backgroundColor = .systemBackground
        
        tableView.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CategoryListCell")
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}

