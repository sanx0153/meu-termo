class Avatar {
    control := API.graphics.control()
    __New(spriteSet,subSet,frame := 1) {
        this.control.Move(,,TILE_SIZE,TILE_SIZE)
        this.control.Value := API.graphics.Sprite(spriteSet,subSet,frame)
    }
    Hide() {
        ControlHide(this.control)
    }
    Show() {
        ControlShow(this.control)
    }
    Move(x,y) {
        this.control.Move(x,y)
    }
    Update() {
    }
}
class MovingAvatar extends Avatar {
    __New(spriteSet,subSet) {
        super.__New(spriteSet,subSet)
    }
}
class StaticAvatar extends Avatar {

    __New(spriteSet,subSet,frame := 1) {
        super.__New(spriteSet,subSet,frame)
    }
}
class TextAvatar extends Avatar {
    __New(color,text) {
        super.__New("blocks",color)
        this.color := color
        this.text := API.graphics.Text()
        this.SetText(text)
    }
    Hide() {
        super.Hide()
        ControlHide(this.text)
    }
    GetColor() {
        return this.color
    }
    SetColor(color,frame := 1) {
        this.color := color
        this.control.Value := API.graphics.Sprite("blocks",color,frame)
    }
    SetText(text) {
        this.text.Value := StrUpper(text)
        ;this.control.Redraw()
        ;this.text.Redraw()
    }
    Show() {
        super.Show()
        ControlShow(this.text)
    }
    Move(x,y) {
        super.Move(x,y)
        this.text.Move(x,y)
    }
    Update() {
        super.Update()
    }
}