;Output: none
;ret:	 dh-string,dl-row
CURSOR_READ proc
  push AX
  push BX
  push CX
  mov AH,3
  xor BH,BH
  int 10h
  pop CX
  pop BX
  pop AX
  ret
CURSOR_READ endp 

;-[CURSOR_SET, V1]---------------------------------------
;Output: DH - str, DL - row
;На выходе: none
;Ints: INT 10h, AH=02h
;--------------------------------------------------------
CURSOR_SET proc
  push AX
  push BX
  push CX
  mov AH,2
  xor BH,BH
  int 10h
  pop CX
  pop BX
  pop AX
  ret
CURSOR_SET endp

;-[CURSOR_RIGHT, V1]-------------------------------------
;
;Out: none
;ret: none
;Proc: CURSOR_READ, CURSOR_SET
;--------------------------------------------------------
CURSOR_RIGHT proc
  push DX
  call CURSOR_READ
  inc DL
  call CURSOR_SET
  pop DX
  ret
CURSOR_RIGHT endp

;-[WRITE_CHAR, V1]---------------------------------------
;Out: DL - code of symbol.
;Ret: none
;Ints: INT 10h, AH=09h
;Proc: CURSOR_RIGHT
;--------------------------------------------------------
WRITE_CHAR proc
  push AX
  push BX
  push CX
  mov AH,9
  xor BH,BH
  mov BL,00000111b
  mov CX,1
  mov AL,DL
  int 10h
  call CURSOR_RIGHT
  pop CX
  pop BX
  pop AX
  ret
WRITE_CHAR endp

;-[CLS, V1]-----------------------------------------
;Clear of Screen
;Out: none
;Ret: none
;Ints: INT 10h, AH=06h
;--------------------------------------------------------
CLS proc
  push AX
  push BX
  push CX
  push DX
  mov AH,6
  xor AL,AL
  mov BH,00000111b
  xor CX,CX
  mov DH,24d
  mov DL,79d
  int 10h
  pop DX
  pop CX
  pop BX
  pop AX
  ret
CLS endp

;-[WRITE_HEX_DIGIT, V1]----------------------------------
;Out: DL - digit
;Ret: none
;Int: none
;Proc: WRITE_CHAR
;--------------------------------------------------------
WRITE_HEX_DIGIT proc
  push DX   
  cmp  DL,0Ah       
  jae  HEX_LETTER
  add  DL,30h
  JMP  WRITE_DIGIT
 HEX_LETTER:
  add  DL,37h
 WRITE_DIGIT:
  call WRITE_CHAR
  pop  DX   
  ret
WRITE_HEX_DIGIT endp

;Out: ax-digit
WRITE_INT_DIGIT proc
	push ax;mod
	push cx
;; если число знаковое, то необходимо расскоментировать следующие строки
;; Проверяем число на знак.
;   test    ax, ax
;   jns     oi1
;
;; Если оно отрицательное, выведем минус и оставим его модуль.
;   mov  cx, ax
;   mov     ah, 02h
;   mov     dl, '-'
;   int     21h
;   mov  ax, cx
;   neg     ax
;; Количество цифр будем держать в CX.
;oi1:  
    xor     cx, cx
    mov     bx, 10 ; основание сс. 10 для десятеричной и т.п.
oi2:
    xor     dx,dx
    div     bx
; Делим число на основание сс. В остатке получается последняя цифра.
; Сразу выводить её нельзя, поэтому сохраним её в стэке.
    push    dx
    inc     cx
; А с частным повторяем то же самое, отделяя от него очередную
; цифру справа, пока не останется ноль, что значит, что дальше
; слева только нули.
    test    ax, ax
    jnz     oi2
; Теперь приступим к выводу.
    mov     ah, 02h
oi3:
    pop     dx
; Извлекаем очередную цифру, переводим её в символ и выводим.
;; раскоментировать если основание сс > 10, т.е. для вывода требуются буквы
;   cmp     dl,9
;   jbe     oi4
;   add     dl,7
;oi4:
    add     dl, '0'
    int     21h
; Повторим ровно столько раз, сколько цифр насчитали.
    loop    oi3
    pop cx
    pop ax;mod
    ret
 
WRITE_INT_DIGIT endp 

;dx-offset string
WRITE_TEXT proc
push ax
mov ah,9h
int 21h
pop ax
ret
WRITE_TEXT endp

;-[write_string, v1]-------------------------------------
;Print string
; '$'
;Out: ds:dx - offset str
;Ret: none
;Int: none
;Proc: write_char
;--------------------------------------------------------
WRITE_STRING proc
  push ax
  push dx
  push si
  pushf              ;(1)
  cld                ;(2)
  mov  si,dx         ;(3)
 string_loop:
  lodsb              ;(4)
  cmp  al,'$'        ;(5)
  jz   end_of_string ;(6)
  mov  dl,al         ;(7)
  call write_char    ;(8)
  jmp  string_loop   ;(9)
 end_of_string:
  popf               ;(10)
  pop  si
  pop  dx
  pop  ax
  ret
WRITE_STRING endp

;WRITE_CHARS_ARRAY_EX - writes the character string on the screen, starting from the specified position.
; Input parameters:  
;       AL - code format (0-3):  
;                AL = 0, the format string {char., Char., ..., Char.} And the cursor does not move,  
;				 AL = 1, the format string {char., Char., ..., Char.} And the cursor moves,
;				 AL = 2, the format string {char., APR., ..., Char., APR.} And the cursor does not move,  
;                AL = 3, the format string {char., APR., ..., Char., APR.} And the cursor is moved;  
;       BH - page display;  
;		BL - attribute (modes AL = 0, AL = 1);  
;		CX - the length of the line;  
;		DX - the cursor position to record the string;  
;		ES: BP - pointer to the string.
; Output parameters: are not available.
; Samples:  ABC db 'H',0Ah,'e',0Bh,'l',0Dh,'l',0Ch
WRITE_CHARS_ARRAY_EX proc
  push ax
  mov  ah,13h
  int  10h
  pop  ax
  ret
WRITE_CHARS_ARRAY_EX endp

;dx-offset string
READ_TEXT proc
  push ax
  push dx
  mov  ah,0ah
  int  21h
  pop  dx
  pop  ax
  ret
READ_TEXT endp

;bp-addr str
;Sample: <$><атрибут1>,<текст1>,<$><атрибут2>,<текст2>,0
DRAW_COLOR_TEXT proc
color_string:
 mov ax,0300h ; получить адрес курсора
 mov bx,0
 int 10h
set_att:
 cmp byte ptr [bp],24h ; анализируем первый знак
 je yes_color ; если это признак цвета, то следующий - атрибут
 jmp no_color

yes_color:
 inc bp ; получаем атрибут
 jmp nbw ; далее обращаемся как с атрибутом 
anal_att:
 cmp byte ptr [bp],20h 
 jl nbw ; если первый знак - не атрибут
no_color:
 mov bl,07h ; писать белым на черном
 jmp clr_txt
nbw:
 mov bl,[bp] ; выделяем атрибут из строки
 inc bp
clr_txt:
 mov cx,1 ; вывести один символ
 mov ax,1301h ; функция
 cmp byte ptr [bp],0 ; ищем признак конца строки
 je endoftxt
 cmp byte ptr [bp],24h ; ищем след.признак цвета в строке
 je yes_color
 cmp byte ptr [bp],13
 jne no_ret_cur
 xor dl,dl

no_ret_cur:
 int 10h ; пишем текст
 inc bp ; получам адрес след.символа
 cmp byte ptr [bp-1],13
 je no_move_cur
 cmp byte ptr [bp-2],13
 je no_move_cur
 inc dx ; перемещаем курсор
no_move_cur: 
 jmp clr_txt
endoftxt:
 ret
DRAW_COLOR_TEXT endp

;ret: ah-maxsize of symbols
;     al-code of mode
;     bh-number of page
GetVideoMode proc
  mov   ah,0Fh
  int   10h
  ret
GetVideoMode endp
