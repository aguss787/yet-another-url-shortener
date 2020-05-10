port module LocalStorage exposing (removeToken, storeToken)


tokenKeyword : String
tokenKeyword =
    "token"


storeToken : String -> Cmd msg
storeToken value =
    store
        { key = tokenKeyword
        , value = value
        }


removeToken : Cmd msg
removeToken =
    remove tokenKeyword


type alias StoreParam =
    { key : String
    , value : String
    }


port store : StoreParam -> Cmd msg


port remove : String -> Cmd msg
