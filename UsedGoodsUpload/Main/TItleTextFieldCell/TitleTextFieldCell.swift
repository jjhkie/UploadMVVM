

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class TitleTextFieldCell: UITableViewCell{
    
    let disposeBag = DisposeBag()
    
    let titleInputField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ VM: TitleTextFieldCellViewModel){
        titleInputField.rx.text
            .bind(to: VM.titleText)
            .disposed(by: disposeBag)
    }
    
    
    private func attribute(){
        titleInputField.font = .systemFont(ofSize: 17.0, weight: .bold)
    }
    
    private func layout(){
        contentView.addSubview(titleInputField)
        
        titleInputField.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(20)
        }
    }
    
    
}
