;Diretivas
#Requires AutoHotkey v2.0
#SingleInstance Force ;Impede múltipla instância

;Inclusão de API's
#Include API\app.ahk
#Include API\avatar.ahk 
#Include API\graphics.ahk
#Include API\input.ahk
#Include API\queue.ahk

;Inclusão de LIB's
#Include lib\game.ahk
#Include lib\scenery.ahk

;Declarações
Application := App("Termo")

;Inicio
Application.Start()

/*
# **URGENTE**
    [ ] Refatorar update para escapar direito pra proxima cena.
# AVISO
    ## NEM VI ISSO AINDA
        Quando criar um objeto dentro do game ele avisa/reporta sua existência para aa API gráfica e ela passa a observá-lo. Assim mantenho as coisas conectadas mas ao mesmo isoladas.
        Consertar fila e pilha.
    ## VER COMO CONSERTA ACENTUAÇÃO
        Ele está diferenciando acentuadas e sem acento e é pra ignorar acentuação.
        
*/