import UIKit
import SnapKit

class TableViewCell: UITableViewCell {
    
    private weak var stackView: UIStackView?
    private weak var modelLabel: UILabel?
    private weak var companyLabel: UILabel?
    
    private weak var imageview: UIImageView!
    private weak var indicator: UIActivityIndicatorView!
    
    private var item: Item!
    
    enum LoadState {
        case notLoaded(UIImage)
        case loading
        case loaded(UIImage)
    }
    
    private var imageState: LoadState = .loading {
        didSet {
            func config(img: UIImage) {
                Storage.shared.pics[item.id!] = img.pngData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: { [unowned self] in
                    indicator.stopAnimating()
                    imageview.image = img
                })
            }
            switch imageState {
            case let .notLoaded(img):
                config(img: img)
            case .loading:
                DispatchQueue.main.async { [unowned self] in
                    indicator.startAnimating()
                    imageview.image = nil
                }
            case let .loaded(img):
                config(img: img)
            }
        }
    }
    
    func config(with item: Item) {
        stackView?.arrangedSubviews.forEach({$0.removeFromSuperview()})
        self.item = item
        
        if let text = item.company?.name {
            let company = UILabel()
            company.font = .boldSystemFont(ofSize: 20)
            company.text = text
            stackView?.addArrangedSubview(company)
            companyLabel = company
        } else {
            modelLabel?.font = .boldSystemFont(ofSize: 19)
        }
        if let text = item.name {
            let model = UILabel()
            model.text = text
            stackView?.addArrangedSubview(model)
            modelLabel = model
        }
        
        if let id = item.id, let info = Storage.shared.info[id] {
            guard let url = info.imageURL else {
                imageState = .notLoaded(#imageLiteral(resourceName: "nophoto"))
                return
            }
            
            Interactor.shared.loadImage(url: url, { [self] data in
                guard let data = data, let image = UIImage(data: data) else {
                    imageState = .notLoaded(#imageLiteral(resourceName: "nophoto"))
                    return
                }
                imageState = .loaded(image)
            })
        }
    }
    
    fileprivate func imageViewSetup() {
        guard imageview == nil else { fatalError("Crash on reuse!") }
        
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.tintColor = .lightGray // for placeholder
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFit
        addSubview(iv)
        
        iv.snp.makeConstraints({
            $0.topMargin.equalToSuperview()
            $0.leadingMargin.equalToSuperview()
            $0.bottomMargin.equalToSuperview()
            $0.width.equalTo(iv.snp.height)
        })
        iv.layoutIfNeeded()
        iv.layer.borderWidth = 0.5
        iv.layer.borderColor = iv.tintColor.cgColor
        iv.layer.cornerRadius = iv.frame.width.squareRoot()
        
        let ind = UIActivityIndicatorView(style: .gray)
        ind.hidesWhenStopped = true
        iv.addSubview(ind)
        
        ind.snp.makeConstraints({
            $0.leading.equalTo(iv.snp.leading)
            $0.trailing.equalTo(iv.snp.trailing)
            $0.top.equalTo(iv.snp.top)
            $0.bottom.equalTo(iv.snp.bottom)
        })
        ind.layoutIfNeeded()
        ind.startAnimating()
        
        self.indicator = ind
        self.imageview = iv
    }
    
    fileprivate func stackViewSetupAndLabels() {
        guard stackView == nil else { fatalError("Crash on reuse!") }
        
        // MARK: StackView
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.axis = .vertical
        addSubview(stack)
        
        // StackView Constraints
        stack.snp.makeConstraints {
            $0.topMargin.equalTo(imageview.snp.top)
            $0.trailingMargin.equalTo(snp.trailingMargin)
            $0.leadingMargin.equalTo(imageview.snp.trailing).offset(10)
            $0.bottomMargin.equalTo(imageview.snp.bottom)
        }
        stack.layoutIfNeeded()
        stackView = stack
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageview.image = nil
        imageState = .loading
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imageViewSetup() // 1
        stackViewSetupAndLabels() // 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
