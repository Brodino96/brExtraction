Locales["en"] = {
    ["blipName"] = "Extraction Point",

    ["menuTitle"] = "Extraction Menu",
    ["option1Title"] = "Extraction",
    ["option1description"] = "Go back to your base",
    ["option2Title"] = "Cancel",
    ["option2description"] = "Go back to your stuff",

    ["inputText"] = "Press ~INPUT_CONTEXT~ to open the Menu",
    
    ["alertHeader"] = "Are you sure?",
    ["alertContent.item"] = "This will cost you **"..Config.price.quantity.." "..Config.price.item.."**",
    ["alertContent.currency"] = "This will cost you **"..Config.price.quantity.." dollars**",
    ["alertAllow"] = "I'm sure",
    ["alertCancel"] = "Go back",

    ["notificationTitle"] = "Watch out",
    ["notificationDescription"] = "If you get more than **"..Config.maxDistanceToTeleport.." meters** away \n or get damaged, the teleport will interrupt",

    ["failureTitle"] = "Teleport interrupted",
    ["failureDescription"] = "You moved too far",

    ["successTitle"] = "Teleport was succesfull",
    ["successDescription"] = "You are back at home",

    ["notEnoughItemsTitle"] = "Payment rejected",
    ["notEnoughItemsDescription"] = "You don't have enough "..Config.price.item,

    ["invalidJobTitle"] = "Couldn't find a valid Home",
    ["invalidJobDescription"] = "We couldn't find a place to teleport you",

    ["notEnoughCurrencyTitle"] = "Payment refused",
    ["notEnoughCurrencyDescription"] = "You don't have enough money on your bank account",

    ["gotDamagedTitle"] = "Teleport interrupted",
    ["gotDamagedDescription"] = "You got damaged",

    ["timerFirstText"] = "There's still ",
    ["timerSecondText"] = " seconds until teleport"
}