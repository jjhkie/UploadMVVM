

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PriceTextFieldCell: UITableViewCell{
    let disposeBag = DisposeBag()
    
    let priceInputField = UITextField()
    let freeshareButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ VM: PriceTextFieldCellViewModel){
        
        ///showFreeShareButton 의 값이 false라면
        ///!로 인하여 true 값이 전달될 것이며
        ///isHidden 값은 true이므로 버튼을 안보이도록 설정한다.
        VM.showFreeShareButton
            .map{ !$0 }
            .emit(to: freeshareButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        VM.resetPrice
            .map{ _ in ""}
            .emit(to: priceInputField.rx.text)
            .disposed(by: disposeBag)
        
        priceInputField.rx.text
            .bind(to: VM.priceValue)
            .disposed(by: disposeBag)
        
        freeshareButton.rx.tap
            .bind(to: VM.freeShareButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        freeshareButton.setTitle("무료나눔", for: .normal)
        freeshareButton.setTitleColor(.orange, for: .normal)
        freeshareButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        freeshareButton.titleLabel?.font = .systemFont(ofSize: 18)
        freeshareButton.tintColor = .orange
        freeshareButton.backgroundColor = .white
        freeshareButton.layer.borderColor = UIColor.orange.cgColor
        freeshareButton.layer.borderWidth = 1.0
        freeshareButton.layer.cornerRadius = 10.0
        freeshareButton.clipsToBounds = true
        freeshareButton.isHidden = true
        freeshareButton.semanticContentAttribute = .forceRightToLeft
        
        priceInputField.keyboardType = .numberPad
        priceInputField.font = .systemFont(ofSize: 17)
        
    }
    private func layout(){
        
        [priceInputField,freeshareButton].forEach{
            contentView.addSubview($0)
        }
        
        priceInputField.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(20)
        }
        
        freeshareButton.snp.makeConstraints{
            $0.top.bottom.leading.equalToSuperview().inset(15)
            $0.width.equalTo(100)
        }
        
    }
}
