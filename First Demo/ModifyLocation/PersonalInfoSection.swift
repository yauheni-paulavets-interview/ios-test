import UIKit

class PersoanlInfoSection: CustomSection {
    
    let stackLayout = UIStackView()
    let firstName = BottomBorderTextField()
    let lastName = BottomBorderTextField()
    let datePicker = UIDatePicker()
    let datePickerTextView = UITextField()
    var section: PersonalSectionModel

    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, section: SectionModel) {
        self.section = section as! PersonalSectionModel
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        let stackView = UIStackView()
        stackView.axis = UILayoutConstraintAxis.vertical
        stackView.distribution  = UIStackViewDistribution.equalSpacing
        stackView.alignment = UIStackViewAlignment.center
        stackView.spacing = 16.0
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        contentView.addSubview(stackView)
        
        stackView.addSubview(firstName)
        stackView.addSubview(lastName)
        stackView.addSubview(datePickerTextView)
        
        firstName.text = self.section.firstName
        firstName.placeholder = "First Name"
        firstName.translatesAutoresizingMaskIntoConstraints = false
        firstName.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
        firstName.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        firstName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        
        lastName.text = self.section.lastName
        lastName.placeholder = "Last Name"
        lastName.translatesAutoresizingMaskIntoConstraints = false
        lastName.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        lastName.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 10.0).isActive = true
        
        let dateString = self.section.dateStr
        if (dateString.count > 0) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
            let date = dateFormatter.date(from: dateString)
            datePicker.setDate(date!, animated: false)
            datePickerTextView.text = dateString
        }
        
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:  #selector(dismissPicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([ spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        datePickerTextView.inputAccessoryView = toolBar
        datePickerTextView.inputView = datePicker
        datePickerTextView.placeholder = "Birthdate"
        datePickerTextView.translatesAutoresizingMaskIntoConstraints = false
        datePickerTextView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        datePickerTextView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        datePickerTextView.topAnchor.constraint(equalTo: lastName.bottomAnchor, constant: 10.0).isActive = true
        datePickerTextView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -10.0).isActive = true
        
        firstName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        lastName.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissPicker() {
        //view.endEditing(true)
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let selectedDate: String = dateFormatter.string(from: datePicker.date)
        section.dateStr = selectedDate
        datePickerTextView.text = selectedDate
        datePickerTextView.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        switch textField {
        case firstName:
            section.firstName = textField.text!
        default:
            section.lastName = textField.text!
        }
    }
}
