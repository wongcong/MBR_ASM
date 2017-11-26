org 7c00h
mov ax,cs
mov ds,ax
mov es,ax
;清屏
mov ax,0003h
int 10h
call FirstScr

Main:
    call GETCHAR
    call GETCURSOR
    call CRLF
    ;判断选择的功能
    mov al,[CHAR]
    cmp al,31h
    jz SHOWTIME
    cmp al,32h
    jz SETTIME
    cmp al,33h
    jz RESTART

    jmp Main

;子程序
;初始界面
FirstScr:
    mov ax,Mes
    mov bp,ax
    mov cx,37
    mov ax,1301H
    mov bx,000CH
    mov dl,0
    int 10H
    ret

;换行,并更改当前指针位置
CRLF:
    call SETCURSOR
    mov ax,CRLF_STR
    mov bp,ax
    mov cx,3
    mov ax,1301h
    mov bx,000ch
    int 10h
    call GETCURSOR
    ret

;获取指针位置并将行列存至[CURSOR]
GETCURSOR:
    push dx
    mov ah,03h
    int 10h
    mov [CURSOR],dx
    pop dx
    ret

;设置指针位置为[CURSOR]值,DX也设为相同的值
SETCURSOR:
    mov dx,[CURSOR]
    mov ah,02h
    int 10h
    ret

;从键盘获取一个字符存至[CHAR],并将其显示在屏幕上,同时光标右移一位
GETCHAR:
    push ax
    push cx
    push dx

    mov ah,00h
    int 16h
    mov [CHAR],al

    call PUTCHAR

    pop dx
    pop cx
    pop ax
    ret

;将[CHAR]输出至屏幕,同时光标右移一位
PUTCHAR:
    push ax
    push cx

    mov ah,0ah
    mov al,[CHAR]
    mov cx,1
    int 10h
    inc dx
    call GETCURSOR
    mov ax,[CURSOR]
    inc ax
    mov [CURSOR],ax
    call SETCURSOR

    pop cx
    pop ax
    ret

;显示时间
SHOWTIME:
    push ax

    ;call SETCURSOR
    ;mov ax,CurTime
    ;mov bp,ax
    ;mov cx,16
    ;mov ax,1301h
    ;mov bx,000ch
    ;int 10h
    ;call GETCURSOR
    ;读取时间
    mov ah,02h
    int 1ah
    mov [TIME],cx

    ;显示小时的十位
    mov al,ch
    mov cl,4
    shr al,cl
    add al,30H
    mov [CHAR],al
    call PUTCHAR
    ;显示小时的个位
    mov cx,[TIME]
    mov ax,0f00h
    and ax,cx
    add ah,30h
    mov [CHAR],ah
    call PUTCHAR
    ;显示冒号
    mov al,3ah
    mov [CHAR],al
    call PUTCHAR
    ;显示分钟的十位
    mov cx,[TIME]
    mov al,cl
    mov cl,4
    shr al,cl
    add al,30H
    mov [CHAR],al
    call PUTCHAR
    ;显示分钟的个位
    mov cx,[TIME]
    mov ax,0000fh
    and ax,cx
    add al,30h
    mov [CHAR],al
    call PUTCHAR
    
    call CRLF

    pop ax
    jmp Main

;设置时间
SETTIME:
    push ax

    ;call SETCURSOR
    ;mov ax,GetTime
    ;mov bp,ax
    ;mov cx,19
    ;mov ax,1301h
    ;mov bx,000ch
    ;int 10h
    ;call CRLF
    ;call GETCURSOR

    ;接受第一个字符
    call GETCHAR
    mov al,[CHAR]
    sub al,30h
    mov bl,16
    mul bl
    ;放在时钟十位上
    mov ch,al

    ;接受第二个字符
    call GETCHAR
    mov al,[CHAR]
    sub al,30h
    ;放在时钟个位上
    add ch,al

    ;接受分号
    call GETCHAR
    mov al,[CHAR]
    cmp al,3ah
    jnz ERROR

    ;接受第五个字符
    call GETCHAR
    mov al,[CHAR]
    sub al,30h
    mov bl,16
    mul bl
    ;放在分钟十位上
    mov cl,al
    
    ;接受第六个字符
    call GETCHAR
    mov al,[CHAR]
    sub al,30h
    ;放在分钟个位上
    add cl,al

    mov ah,03h
    int 1ah
    call CRLF

    pop ax
    jmp Main
ERROR:
    call CRLF
    call SETCURSOR
    mov ax,ERROR_INFO
    mov bp,ax
    mov cx,3
    mov ax,1301h
    mov bx,000ch
    int 10h
    call CRLF
    call GETCURSOR
    jmp SETTIME

;重启
RESTART:
    mov ax,0FFFFH
    push ax
    mov ax,0000H
    push ax
    retf

;数据段

;指针位置
CURSOR DW 0
;键盘获取的字符备份
CHAR DB 0
;获取的时间备份
TIME DW 0

CRLF_STR DB 0DH,0AH,3EH
Mes DB "1.SHOW TIME",0DH,0AH,"2.SET TIME",0DH,0AH,"3.RESTART",0DH,0AH,3EH
;CurTime DB "Current TIME is "
;GetTime DB "Please input a time"
;ERROR_INFO DB "Please input correct data!"
ERROR_INFO DB "!!!"
TIMes 510 - ($-$$) DB 0
DW 0XAA55