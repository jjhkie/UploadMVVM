
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {

    let disposeBag = DisposeBag()
    
    ///UI
    let tableView = UITableView()
    let submitButton = UIBarButtonItem()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ VM: MainViewModel){
        VM.cellData
            .drive(tableView.rx.items){tv, row, data in
                switch row{
                case 0:
                    let cell = tv.dequeueReusableCell(withIdentifier: "titleTextFieldCell", for: IndexPath(row: row, section: 0)) as! TitleTextFieldCell
                    
                    cell.selectionStyle = .none
                    cell.titleInputField.placeholder = data
                    cell.bind(VM.titleTextFieldCellViewModel)
                    return cell
                    
                case 1:
                    let cell = tv.dequeueReusableCell(withIdentifier: "CategorySelectCell", for: IndexPath(row: row, section: 0))
                    
                    cell.selectionStyle = .none
                    cell.textLabel?.text = data
                    cell.accessoryType = .disclosureIndicator
                    return cell
                    
                case 2:
                    let cell = tv.dequeueReusableCell(withIdentifier: "PriceTextFieldCell", for: IndexPath(row: row, section: 0)) as! PriceTextFieldCell
                    
                    cell.selectionStyle = .none
                    cell.priceInputField.placeholder = data
                    cell.bind(VM.priceTextFieldCellViewModel)
                    return cell
                case 3:
                    let cell = tv.dequeueReusableCell(withIdentifier: "DetailWriteFormCell", for: IndexPath(row: row, section: 0)) as! DetailWriteFormCell
                    
                    cell.selectionStyle = .none
                    cell.contentInputView.text = data
                    cell.bind(VM.detailWriteFormCelLViewModel)
                    return cell
                    
                default:
                    fatalError()
                }
            }
            .disposed(by: disposeBag)
        
        
        VM.presentAlert
            .emit(to: self.rx.setAlert)
            .disposed(by: disposeBag)
        
        VM.push
            .drive(onNext: {viewModel in
            let viewController = CategoryListViewController()
            viewController.bind(viewModel)
            self.show(viewController, sender: nil)
            
        })
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map{ $0.row}
            .bind(to: VM.submitButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        title = "중고거래 글쓰기"
        view.backgroundColor = .white
        
        submitButton.title = "제출"
        submitButton.style = .done
        
        navigationItem.setRightBarButton(submitButton, animated: true)
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        
        //titleTextField :: index row 0
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "TitleTextfieldCell")
        
        //categoryTextField :: index row 1
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "CategorySelectCell")
        
        //priceTextField :: index row 2
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "PriceTextfieldCell")
        
        //detailTextField :: index row 3
        tableView.register(TitleTextFieldCell.self, forCellReuseIdentifier: "DetailWriteFormCell")
        
    }
    
    private func layout(){
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
}


typealias Alert = (title: String, message: String?)

extension Reactive where Base: MainViewController{
    
    var setAlert: Binder<Alert>{
        return Binder(base) { base, data in
            let alertController = UIAlertController(title: data.title, message: data.message, preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            
            alertController.addAction(action)
            
            base.present(alertController, animated: true, completion:  nil)
        }
    }
}
