#Requires AutoHotkey v2.0
#SingleInstance Force

var1 := 0
while var1 < 10 {
    MaisUm(&var1)
}
MaisUm(var) {
    MsgBox("IsRef:" IsSetRef(var),,"T1")
    %var%++
    MsgBox("Value:" %var%,,"T1")
    if var1 = 10 {
        Reset(var)
    }
}
Reset(var) {
    MsgBox("IsRef:" IsSetRef(var),,"T1")
    %var% := 0
    MsgBox("Value:" %var%,,"T1")
}