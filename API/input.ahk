class InputAPI {
    __New() {
        this.down  := false
        this.left  := false
        this.right := false
        this.space := false
        this.up    := false
    }
    Update() {
        this.down  := GetKeyState("Down","P") ? true : false
        this.left  := GetKeyState("Left","P")  ? true : false
        this.right := GetKeyState("Right","P") ? true : false
        this.space := GetKeyState("Space","P") ? true : false
        this.up    := GetKeyState("Up","P") ? true : false
    }
}

class AbstractPlayer {
    down  := false
    left  := false
    right := false
    space := false
    up    := false
    __New() {
        this.down  := (API.input.down)
        this.left  := API.input.left
        this.right := API.input.right
        this.space := API.input.space
        this.up    := API.input.up
    }
    Update() {
        this.down  := API.input.down
        this.left  := API.input.left
        this.right := API.input.right
        this.space := API.input.space
        this.up    := API.input.up
    }
}