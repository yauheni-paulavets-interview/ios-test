import Foundation

class CollectionViewCell: UICollectionViewCell {
    static let reuseID = "CollectionViewCell"
    
    func setView(isSideBar: Bool, locationData: LocationFlatModel) {
        // Is it necessary????
        contentView.subviews.forEach({ $0.removeFromSuperview() })
        let margin = contentView.layoutMarginsGuide
        if isSideBar {
            buildSidebarCell(margin: margin, locationData: locationData)
        } else {
            buildContentCell(margin: margin, locationData: locationData)
        }
    }
    
    func buildSidebarCell(margin: UILayoutGuide, locationData: LocationFlatModel) {
        contentView.backgroundColor = UIColor(hex: 0xE0004D)
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 3.0
        let label = buildLabel(locationData.addressValue)
        label.textColor = .white
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
    }
    
     func buildContentCell(margin: UILayoutGuide, locationData: LocationFlatModel) {
        contentView.backgroundColor = UIColor.white
        contentView.layer.borderColor = UIColor(hex: 0xdee2e6).cgColor
        contentView.layer.borderWidth = 3.0
        
        let firstNameLabel = buildLabel(locationData.firstName)
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let lastNameLabel = buildLabel(locationData.lastName)
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        let dateLabel = buildLabel(locationData.dateStr)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(lastNameLabel)
        contentView.addSubview(dateLabel)
        
        firstNameLabel.topAnchor.constraint(equalTo: margin.topAnchor).isActive = true
        firstNameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        firstNameLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        
        lastNameLabel.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor).isActive = true
        lastNameLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        lastNameLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: margin.trailingAnchor).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: margin.leadingAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: margin.bottomAnchor).isActive = true
    }
    
    func buildLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping;
        label.numberOfLines = 0
        
        return label
    }
}
