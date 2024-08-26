#Requires AutoHotkey v2.0
#SingleInstance Force
janela := Gui("AlwaysOnTop -Border -Caption")
texto := janela.AddText("Center w60 h60")
janela.Show("AutoSize Center")
AtualizarJanela("Iniciando Filtro")
;FiltroDicioCincoLetras()
;FiltroVerbosCincoLetras()
;FiltroConjugacoesCincoLetras()
;FiltroFinal()

FiltroDicioCincoLetras() {
    loop read "dicio","dicioCinco.txt" {
        if StrLen(A_LoopReadLine) == 5 {
            AtualizarJanela(A_LoopReadLine)
            Sleep(5)
            FileAppend(A_LoopReadLine . "`r","dicioCinco.txt","UTF-8")
        }
    }
}

FiltroVerbosCincoLetras() {
    loop read "verbos","verbosCinco.txt" {
        if StrLen(A_LoopReadLine) == 5 {
            AtualizarJanela(A_LoopReadLine)
            Sleep(5)
            FileAppend(A_LoopReadLine . "`r","verbosCinco.txt","UTF-8")
        }
    }
}

FiltroConjugacoesCincoLetras() {
    loop read "conjugacoes","conjugacoesCinco.txt" {
        if StrLen(A_LoopReadLine) == 5 {
            AtualizarJanela(A_LoopReadLine)
            Sleep(5)
            FileAppend(A_LoopReadLine . "`r","conjugacoesCinco.txt","UTF-8")
        }
    }
}

FiltroFinal() {
    loop read "dicioCinco.txt","bdTermo.txt" {
        palavraParaValidar := A_LoopReadLine
        invalida := validacao(palavraParaValidar)
        if invalida = false {
            AtualizarJanela(palavraParaValidar)
            Sleep(1)
            FileAppend(palavraParaValidar . "`r","bdTermo.txt","UTF-8")
        }
    }
}

validacao(palavraParaValidar) {
    resposta := ""
    palavra := palavraParaValidar
    loop read "conjugacoesCinco.txt" {
        if InStr(A_LoopReadLine,palavra) = 1 {
            resposta := true
        } else resposta := false
    }
    return resposta
}

AtualizarJanela(palavraAtual) {
    texto.Value := palavraAtual

}

janela.Destroy()
MsgBox("Filtros Aplicados")
ExitApp()