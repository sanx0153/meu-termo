class App {
    __New(whichGame) {
        this.hub := APIHub(whichGame)
        ;depois arrumar essa gambiarra abaixo e fazer como o resto
        ;API.game := Termo()
    }
    Start() {
        CallMainLoop := ObjBindMethod(this,"MainLoop")
        SetTimer(CallMainLoop,15)
    }
    MainLoop() {
        API.input.Update()
        API.game.Update()
        API.graphics.Update()
    }
}

class APIHub {
    __New(whichGame) {
        ;avoids duplication
        if IsSet(API) {
            MsgBox("Ja existe API")
            return API
        }else this.SetRef()
        ;creates API's
        this.graphics := GraphAPI()
        this.input := InputAPI()
        this.game := %whichGame%()
    }
    SetRef() {
        global API := this.GetRef(&this)
    }
    GetRef(objeto) {
        if IsSetRef(objeto)
        {
            MsgBox("API Reference Successffully Created",,"T1")
            return %objeto%
        }
    }
}

class Game {
        currentScene := ""
        nextSceneTitle := ""
    __New(firstSceneTitle := "Title") {
        this.SetNextScene(firstSceneTitle)
        this.StartScene()
    }
    StartScene() {
        API.graphics.CreateWindow()
        this.currentScene := %this.nextSceneTitle%Scene()
        this.SetNextScene(this.currentScene.GetNextScene())
    }
    EndScene() {
        this.currentScene := ""
        API.graphics.DestroyWindow()
        return this.StartScene()
    }
    SetNextScene(name) {
        this.nextSceneTitle := name
    }
    Update() {
        this.currentScene.Update()
    }
}

class AbstractScene {
    title := ""
    background := ""
    bricks := []
    endThisScene := false
    player := ""
    queue := Queue()
    __New(title,nextSceneTitle) {
        this.title          := title
        this.nextSceneTitle := nextSceneTitle
        this.background     := this.CreateBackgroundControl()
        this.player         := %title%Player()
        this.SetBackground()
        this.endThisScene := false
    }
    CreateBackgroundControl() {
        control := API.graphics.Control()
        control.Move(0,0,600,600)
        return control
    }
    CreateText(varName,color,text,y) {
        text               := StrSplit(text)
        color              := color
        xFirst             := Round((600 / 2) - (TILE_SIZE * (text.Length / 2)))
        y                  := y
        this.%varName%Text := []
        loop text.Length {
            this.%varName%Text.Push(TextAvatar(color,text[A_Index]))
            this.%varName%Text[A_Index].Update((xFirst + ((A_Index - 1) * TILE_SIZE)),y)   
        }
    }
    CreateTextLeft(varName,color,text,y) {
        text               := StrSplit(text)
        color              := color
        xFirst             := Round((10 + (600 / 4) - (TILE_SIZE * (text.Length / 2))))
        y                  := y
        this.%varName%Text := []
        loop text.Length {
            this.%varName%Text.Push(TextAvatar(color,text[A_Index]))
            this.%varName%Text[A_Index].Update((xFirst + ((A_Index - 1) * TILE_SIZE)),y)   
        }
    }
    CreateTextRight(varName,color,text,y) {
        text               := StrSplit(text)
        color              := color
        xFirst             := Round(((600 / 4) * 3) - (TILE_SIZE * (text.Length / 2)))
        y                  := y
        this.%varName%Text := []
        loop text.Length {
            this.%varName%Text.Push(TextAvatar(color,text[A_Index]))
            this.%varName%Text[A_Index].Update((xFirst + ((A_Index - 1) * TILE_SIZE)),y)   
        }
    }
    EndScene() {
        API.game.EndScene()
    }
    GetNextScene() {
        return this.nextSceneTitle
    }
    SetBackground(SubSet := this.title,Frame := 1) {
        this.background.Value := API.graphics.Sprite("bg",SubSet,Frame)
    }
    Update() {
        this.player.Update()
        if this.EndThisScene = true {
            return this.EndScene()
        }
    }
}