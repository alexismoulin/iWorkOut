import SwiftUI

func createAlertTitle(type: Int) -> Text {
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

func createAlertBody(type: Int, CDRecord: Int, currentRecord: Int) -> Text {
    let alertBody1: Text =
        Text("You have completed a New Exercise.\nYour record is **\(currentRecord)**")
    let alertBody2: Text =
        Text("You have beaten your previous record of **\(CDRecord)**\nYour new record is **\(currentRecord)**")
    let alertBody3: Text =
        Text("You didn't beat your previous record of **\(CDRecord)**\nYour current score is **\(currentRecord)**")

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

func createCustomAlert(
    alertType: Int,
    CDRecordSum: Int,
    currentRecordSum: Int,
    dismissfunction: @escaping () -> Void
) -> Alert {
    return Alert(
        title: createAlertTitle(type: alertType),
        message: createAlertBody(
            type: alertType,
            CDRecord: CDRecordSum,
            currentRecord: currentRecordSum
        ),
        dismissButton: .default(Text("Ok"), action: dismissfunction)
    )
}
