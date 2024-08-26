class Queue {
    __New() {
        this.line := []
    }
    /*
    Add(targetObject,targetMethod,*) {
        callBack := ObjBindMethod(targetObject,targetMethod,*)
        this.line.Push(callBack)
    }*/
    Run() {
        if this.line.Length = 0 {
            return
        }
        while this.line.Length > 0 {
            callback := this.line[1]
            this.line.RemoveAt(1)
            callback.Call()
            callback := ""
        }
        this.line := []
    }
}
class Pile {
    __New() {
        this.line := []
    } 
    /*
    Add(targetObject,targetMethod,*) {
        callBack := ObjBindMethod(targetObject,targetMethod,*)
        this.line.Push(callBack)
    } */
    Run() {
        if this.line.Length = 0 {
            return
        }
        while this.line.Length > 0 {
            callback := this.line.Pop()
            callback.Call()
            callback := ""
        }
        this.line := []
    }
}