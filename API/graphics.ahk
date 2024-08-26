
class GraphAPI {
    __New() {
        this.CreateMesures(60)
        MsgBox("Loading Graphics","GraphicsAPI","T1")
        this.CreateWindow()
        this.images := ImageManager()
        this.HUD := HUD()
        MsgBox("Loading Completed","GraphicsAPI","T1")
        ;this.ImageManagerTest()
    }
    Control() {
        control := this.gui.AddPicture("BackgroundTrans")
        return control
    }
    CreateMesures(tileSize) {
        global
        TILE_SIZE := 60
        WINDOWS_SIZE := (10 * TILE_SIZE)
    }
    CreateWindow() {
        this.gui := Gui("-Border -Caption")
        this.gui.Show("w600 h600 Center")
    }
    DestroyWindow() {
        this.gui.Destroy()
        this.gui := ""
    }
    Sprite(mainSet,subSet,frame := 1) {
        image := "HBITMAP:*" this.images.structure[mainSet][subSet][frame]
        return image
    }
    Text() {
        control :=  this.gui.AddText("w60 h60 Center Uppercase BackgroundTrans",)
        control.SetFont("cWhite s40 w750","Helvetica")
        return control
    }
    ImageManagerTest() {
        test1 := this.gui.AddPicture()
        test1.Move(,,600,600)
        for spriteSet,subSet in this.images.structure {
            for subSet in subSet {
                loop this.images.structure[spriteSet][subSet].Length {
                    test1.Value := "HBITMAP:*" this.images.structure[spriteSet][subSet][A_Index]
                    Sleep(15)
                }
            }
        }
        test1.Value := ""
        test1 := ""
        MsgBox(A_ThisFunc " successfully completed.",,"T3")
    }
    Update() {
        
    }
}

class HUD {
    
}

class ImageManager {
    __New() {
        this.structure := this.CreateStructure()
        this.LoadImages()
    }
    CreateStructure() {
        result := Map()
        loop files "img\*","D" {
            result[A_LoopFileName] := Map()
        }
        for spriteSets in result {
            loop files "img\" spriteSets "\*01.*" {
                result[spriteSets][SubStr(A_LoopFileName,1,-6)] := Array()
            }
        }
        return result
    }
    LoadImages() {
        for spriteSets,subSets in this.structure {
            v1 := spriteSets
            for subSets in subSets {
                v2 := subSets
                loop files "img\" v1 "\" v2 "*.*" {
                    this.structure[v1][v2].Push(LoadPicture(A_LoopFileFullPath))
                }
            }
        }
    }

}