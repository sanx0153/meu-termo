class TitleScene extends AbstractScene {
    __New() {
        super.__New("title","play")
        this.objects := Map()
        this.objects["titleText"] := TitleBoard()
    }
    Update() {
        if this.player.IsIdle = false {
            this.EndScene()
        }
        super.Update()
    }
}
class TitlePlayer extends AbstractPlayer {
    __New() {
        super.__New()
        this.IsIdle := true
    }
    Update() {
        super.Update()
        if this.space = true {
            this.IsIdle := false
        }
    }
}

class PlayScene extends AbstractScene {
    __New() {
        super.__New("play","final")
        this.TurnCount := 1
        this.newGameBoard()
        this.menuBoard := PlayMenuBoard(300,0,300,400)
        this.keyBoard := PlayKeyBoard(0,400,600,200)
        this.inputField := API.graphics.gui.AddEdit("Limit5 Uppercase Center","     ")
        this.inputField.SetFont("s30 w1000")
        this.inputField.Move(300,330,300,TILE_SIZE)
        this.inputField.Visible := false
        this.inputField.Focus()
        this.CreateWordbook()
        this.NewGame()
    }
    ClearInput() {
        Send("`b`b`b`b`b")
;        this.inputField.Value := ""
    }
    CreateWordbook() {
        this.wordbook := WordBook()
    }
    Error(which) {
        switch which,0 {
            case "WrongLength":
                MsgBox("Jogamos Termo com palavras de cinco letras apenas.")                
            case "WrongWord":
                MsgBox("Esta palavra não consta no meu dicionário.")
            default: 
                MsgBox("There was an error getting this error.")
        }
    }
    NextTurn() {
        this.TurnCount += 1
        if this.TurnCount = 6 {
            return this.PlayerLoses()
        }
        this.gameBoard.ShowLine(this.TurnCount)
        Send("`b`b`b`b`b")
    }
    NewGame() {
        this.TurnCount := 1
        this.SortWord()
        Send("`b`b`b`b`b")
    }
    NewGameBoard() {
        this.gameBoard := PlayGameBoard(0,0,300,400)
    }
    PlayerLoses() {
        MsgBox("Você perdeu... Reiniciando!")
        this.EndScene()
    }
    PlayerSendsTry() {
        targetWord := this.inputField.Value
        if StrSplit(targetWord).Length < 5 {
            this.Error("WrongLength")
            this.ClearInput()
            return
        }
        if this.wordbook.ValidateWord(targetWord) = 0 {
            this.Error("WrongWord")
            this.ClearInput()
            return
        }
        this.PaintLetters(targetWord)
        if targetWord = this.answer {
            return this.PlayerWinsRound()
        }
        this.NextTurn()
    }
    PaintLetters(targetWord) {
        answerArray := StrSplit(this.answer)
        targetWordArray := StrSplit(targetWord)
        loop 5 {
            column := A_Index
            targetLetter := answerArray[column]
            targetAnswerLetter := targetWordArray[column]
            if (targetLetter = targetAnswerLetter) {
                this.gameBoard.PaintLetter(column,"green")
                this.keyBoard.PaintLetter(targetAnswerLetter,"green")
            } else if (InStr(this.answer, targetAnswerLetter)) {
                this.gameBoard.PaintLetter(column,"yellow")
                this.keyBoard.PaintLetter(targetAnswerLetter,"yellow")
            } else {
                this.gameBoard.PaintLetter(column,"red")
                this.keyBoard.PaintLetter(targetAnswerLetter,"red")
            }
        }
    }
    PlayerWinsRound() {
        MsgBox("Acertô miserávi!")
        this.endThisScene := true
        this.EndScene()
    }
    SortWord() {
        this.answer := this.wordbook.SortWord()
        MsgBox(this.answer)
    }
    Update() {
        super.Update()
        this.gameBoard.Update()
        if API.game.currentScene.title = this.title AND InStr(this.inputField.Value,A_Space) {
            Send("`b")
        }
    }
}

class AbstractBoard {
    x := 0
    y := 0
    w := 0
    h := 0
    blocks := []
    __New(x,y,w,h,commaSeparatedWordList) {
        this.x := x
        this.y := y
        this.w := w
        this.h := h
        this.blocks := this.CreateBlocks(commaSeparatedWordList)
    }
    CreateBlocks(commaSeparatedWordList) {
        list := StrSplit(commaSeparatedWordList,",")
        lines := list.Length
        vMargin := Floor((this.h - (lines * TILE_SIZE)) / (lines + 1))
        blockSet := []
        loop lines {
            line := A_Index
            list[line] := StrSplit(list[line])
            lineLength := list[line].Length
            lineSet := []
            loop lineLength {
                column := A_Index
                hMargin := Floor((this.w - (lineLength * TILE_SIZE)) / (lineLength + 1))
                blockX := (this.x + (hMargin * column) + ((column - 1) * TILE_SIZE)) 
                blockY := (this.y + (vMargin * line) + ((line - 1) * TILE_SIZE))
                lineSet.Push(TextAvatar("blue",list[line][column]))
                lineSet[column].Move(blockX,blockY)
            }
            blockSet.Push(lineSet)
        }
        return blockSet
    }
    Update() {
        
    }
}

class PlayGameBoard extends AbstractBoard {
    __New(x,y,w,h) {
        super.__New(x,y,w,h,"?????,     ,     ,     ,     ")
        this.currentPanel := "     "
        this.EndThisScene := false
        this.HideAll()
        this.ShowLine(1)
    }
    HideAll() {
        loop this.blocks.Length {
            line := A_Index
            this.HideLine(line)
        }
    }
    HideLine(lineNumber) {
        loop this.blocks[lineNumber].Length {
            column := A_Index
            this.blocks[lineNumber][column].Hide()
        }
    }
    PaintLetter(column,color,line := API.game.currentScene.TurnCount) {
        this.blocks[line][column].SetColor(color)
    }
    ShowLine(lineNumber) {
        loop this.blocks[lineNumber].Length {
            column := A_Index
            this.blocks[lineNumber][column].Show()
        }
    }
    Update() {
        if API.game.currentScene.title != "play" {
                API.game.currentScene.endThisScene := true
            }
            if API.game.currentScene.title = "play" {
                TurnCount := API.game.currentScene.TurnCount
                currentTry := API.game.currentScene.inputField.Value
                if this.currentPanel = currentTry {
                    return
                } else {
                    this.currentPanel := currentTry
                    currentTry := StrSplit(currentTry)
                    if currentTry.Length < 5 {
                        loop (5 - currentTry.Length) {
                            currentTry.Push(" ")
                        }
                    }
                }
                loop currentTry.Length {
                    column := A_Index
                    this.blocks[TurnCount][column].SetText(currentTry[column])
                }
            }
            super.Update()
        }
    }
    
class PlayMenuBoard extends AbstractBoard {
    __New(x,y,w,h) {
        super.__New(x,y,w,h,"novo,sair")
    }
    Update() {
        super.Update()
        
    }
}

class PlayKeyBoard extends AbstractBoard {
    __New(x,y,w,h) {
        super.__New(x,y,w,h,"qwertyuiop,asdfghjkl>,zxcvbnm<")
        this.CreateStateTable()
    }
    CreateStateTable() {
        this.keyMap := Map()
        alphabet := StrSplit(StrUpper("abcdefghijklmnopqrstuvwxyz"))
        keyboard := StrUpper("qwertyuiopasdfghjklzxcvbnm")
        loop alphabet.Length {
            this.keyMap[alphabet[A_Index]] := Array()
        }
        loop 10 {
            this.keyMap[SubStr(keyboard,A_Index,1)].Push(1,A_Index)
        }
        loop 9 {
            this.keyMap[SubStr(keyboard,A_Index + 10,1)].Push(2,(A_Index))            
        }
        loop 7 {
            this.keyMap[SubStr(keyboard,A_Index + 19,1)].Push(3,(A_Index))
        }
    }
    PaintLetter(letter,color) {
        line := this.keyMap[letter][1]
        column := this.keyMap[letter][2]
        currentColor := this.blocks[line][column].GetColor()
        if currentColor = color {
            return
        }
        if color = "green" {
            this.blocks[line][column].SetColor("green")
            return
        }
        if color = "yellow" {
            if currentColor = "blue" {
                this.blocks[line][column].SetColor("yellow")
                return
            }
        }
        if color = "red" {
            if currentColor = "blue" {
                this.blocks[line][column].SetColor("red")
            }
        }
    }
    Update() {
        super.Update()
    }
}

class TitleBoard extends AbstractBoard {
    __New() {
        super.__New(0,0,600,600,"termo,by sanx")
    }
    Update() {
        super.Update()
    }
}


class PlayPlayer extends AbstractPlayer {
    __New() {
        super.__New()
        
    }
    SendsTry() {
        API.game.currentScene.PlayerSendsTry()
    }
    Update() {
        super.Update()
        if this.space = true {
            this.SendsTry()
        }
    }
}

class StateTable {
    alphabet := StrSplit(StrUpper("abcdefghijklmnopqrstuvwxyz"))
    state := Map()
    __New() {
        loop this.alphabet.Length {
            currentLetter := this.alphabet[A_Index]
            this.state[currentLetter] := 0
        }
    }
}

class WordBook {
    __New() {
        this.file := FileRead("data\bdtermo.txt","UTF-8")
        this.wordArray := StrSplit(this.file,"`r")
        this.file := ""
        MsgBox("Grimório tem: " this.wordArray.Length " palavras.",,"T1")
    }
    SortWord() {
        return sortedWord := this.wordArray[Random(1,this.wordArray.Length)]
    }
    ValidateWord(word) {
        result := 0
        loop this.wordArray.Length {
            if InStr(this.wordArray[A_Index],word) > 0 {
                result := 1
                return 
            }
        }
        return result
    }
}

class FinalScene extends AbstractScene {
    __New() {
        super.__New("final","title")
        MsgBox("Sequencia Final",,"T1")
    }
}

class FinalPlayer extends AbstractPlayer {
    __New() {
        super.__New()
    }
}