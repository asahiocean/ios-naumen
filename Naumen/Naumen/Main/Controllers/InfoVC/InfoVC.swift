import UIKit
import SnapKit

class InfoVC: UIViewController {
    
    weak var mainScrollView: UIScrollView?
    weak var imagesScrollView: UIScrollView?
    weak var nameStack: UIStackView?
    weak var introducedStack: UIStackView?
    weak var discountedStack: UIStackView?
    weak var descriptionStack: UIStackView?
    
    private var similars: Similars = []
    
    fileprivate func scrollViewSetup() {
        let scroll = UIScrollView(frame: view.frame)
        scroll.contentSize = scroll.frame.size
        view.addSubview(scroll)
        scroll.snp.makeConstraints({
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        })
        mainScrollView = scroll
    }
    
    fileprivate func imageViewSetup() {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        mainScrollView?.addSubview(scroll)
        scroll.snp.makeConstraints({
            guard let scroll = mainScrollView else { return }
            $0.top.equalTo(scroll.snp.top)
            $0.centerX.equalTo(scroll.snp.centerX)
            $0.width.equalTo(scroll.snp.width).offset(-50)
            $0.height.equalTo(scroll.snp.width)
        })
        scroll.layoutIfNeeded()
        scroll.layer.borderWidth = 1
        scroll.layer.borderColor = #colorLiteral(red: 0.5960784314, green: 0.5960784314, blue: 0.6156862745, alpha: 0.5).cgColor
        imagesScrollView = scroll
    }
    
    fileprivate func imageSetup(i index: Int) {
        if let data = Storage.shared.pics[index] {
            for _ in 0...4 {
                DispatchQueue.main.async { [self] in
                    let iv = UIImageView(image: UIImage(data: data))
                    iv.contentMode = .scaleAspectFit
                    guard let scroll = imagesScrollView else { return }
                    scroll.addSubview(iv)
                    iv.snp.makeConstraints({
                        $0.width.equalTo(scroll.snp.width)
                        $0.height.equalTo(scroll.snp.height)
                        $0.leading.equalTo(scroll.contentSize.width)
                    })
                    iv.layoutIfNeeded()
                    scroll.contentSize.width += iv.bounds.width
                }
            }
        }
    }
    
    fileprivate func addLabelStack(l label: String, t text: String?, s stackView: inout UIStackView?, after: UIView?) {
        let stack = UIStackView()
        stack.spacing = UIStackView.spacingUseSystem
        stack.axis = .vertical
        let titleLabel = UILabel()
        titleLabel.text = label
        titleLabel.sizeToFit()
        stack.addArrangedSubview(titleLabel)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text ?? "Not indicated"
        label.font = .boldSystemFont(ofSize: 18)
        label.sizeToFit()
        stack.addArrangedSubview(label)
        mainScrollView?.addSubview(stack)
        guard let after = after else { return }
        stack.snp.makeConstraints({
            $0.top.equalTo(after.snp.bottomMargin).offset(20)
            $0.centerX.equalTo(view.snp.centerX)
            $0.width.equalTo(after.snp.width)
        })
        stack.layoutIfNeeded()
        stackView = stack
    }
    
    func loadSimilars(id info: Info) {
        guard let id = info.id else { return }
        
        Interactor.shared.similar(id: id, { [self] in
            let stack = UIStackView()
            stack.spacing = UIStackView.spacingUseSystem
            stack.axis = .vertical
            
            let titleLabel = UILabel()
            titleLabel.text = "We recommend that you watch:"
            titleLabel.sizeToFit()
            stack.addArrangedSubview(titleLabel)
            
            $0.forEach({
                let label = UILabel()
                label.text = $0.name
                label.sizeToFit()
                stack.addArrangedSubview(label)
            })
            
            mainScrollView?.addSubview(stack)
            stack.snp.makeConstraints({
                guard let after = descriptionStack else { return }
                $0.top.equalTo(after.snp.bottomMargin).offset(20)
                $0.centerX.equalTo(view.snp.centerX)
                $0.width.equalTo(after.snp.width)
            })
            stack.layoutIfNeeded()
            mainScrollView?.contentSize.height += (stack.frame.height * 1.1)
        })
    }
    
    func config(with info: Info) {
        
        func dateStr(_ date: String?) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ssZZZ"
            guard let stringDate = date else { return "Not indicated" }
            let date = dateFormatter.date(from: stringDate)
            dateFormatter.dateFormat = "dd.MM.yyyy"
            guard let myDate = date else { fatalError() }
            return dateFormatter.string(from: myDate)
        }
        
        scrollViewSetup()
        imageViewSetup()
        
        self.title = info.name ?? info.company?.name ?? ""
        
        imageSetup(i: info.id!)
        
        addLabelStack(l: "Name:", t: title, s: &nameStack, after: imagesScrollView)
        addLabelStack(l: "Introduced date:", t: dateStr(info.introduced), s: &introducedStack, after: nameStack)
        addLabelStack(l: "Discontinued date:", t: dateStr(info.discounted), s: &discountedStack, after: introducedStack)
        addLabelStack(l: "Description:", t: info.description, s: &descriptionStack, after: discountedStack)
        loadSimilars(id: info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.sizeToFit()
    }
}
