import SwiftUI

func createAlertTile(type: Int) -> Text {
    let alertTitle1: Text = Text("Well Done")
    let alertTitle2: Text = Text("Congratulations")
    let alertTitle3: Text = Text("Try Again")
    switch type {
    case 1:
        return alertTitle1
    case 2:
        return alertTitle2
    case 3:
        return alertTitle3
    default:
        return Text("Error")
    }
}


func createAlertBody(type: Int, CDRecord: Int64, currentRecord: Int) -> Text {
    let alertBody1: Text =
        Text("You have completed a New Exercise.\nYour record is ") +
        Text("\(currentRecord)").fontWeight(.bold).foregroundColor(.lime)
    let alertBody2: Text =
        Text("You have beaten your previous record of ") +
        Text("\(CDRecord)").fontWeight(.bold).foregroundColor(.yellow2) +
        Text("\nYour new record is ") +
        Text("\(currentRecord)").fontWeight(.bold).foregroundColor(.lime)
    let alertBody3: Text =
        Text("You didn't beat your previous record of ") +
        Text("\(CDRecord)").fontWeight(.bold).foregroundColor(.yellow2) +
        Text("\nYour current score is ") +
        Text("\(currentRecord)").fontWeight(.bold).foregroundColor(.lime)
    
    switch type {
    case 1:
        return alertBody1
    case 2:
        return alertBody2
    case 3:
        return alertBody3
    default:
        return Text("Something went wrong")
    }
}

func createCustomAlert(alertType: Int, CDRecordSum: Int64, currentRecordSum: Int, dismissfunction: @escaping () -> Void) -> Alert {
    return Alert(
        title: createAlertTile(type: alertType),
        message: createAlertBody(
            type: alertType,
            CDRecord: CDRecordSum,
            currentRecord: currentRecordSum
        ),
        dismissButton: .default(Text("Ok"), action: dismissfunction)
    )
}

