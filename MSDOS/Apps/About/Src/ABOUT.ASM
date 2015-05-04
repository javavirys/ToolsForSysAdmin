CODESG segment
 assume cs:CODESG
 org 100h
 
 MAIN proc

  lea     dx,title_app			;
  mov     bl,1				;Center of X
  call    SetCursorCenter			;
  mov     bp,offset title_app		;
  call    DRAW_COLOR_TEXT		;draw color text

  lea     dx,vendor
  mov     bl,1				;Center of X
  call    SetCursorCenter
  mov     bp,offset vendor		;
  call    DRAW_COLOR_TEXT		;
  lea     dx, web_page
  mov     bl,1
  call    SetCursorCenter
  call    WRITE_TEXT
  ;---------Sleep---------;
  
  ;---------Quit----------;
  mov    ah,4Ch
  int    20h
  ret
 MAIN endp

;dx-offset text
;bl-X center
;bh-Y center(not realize)
;
 SetCursorCenter proc
  push ax
  push dx
  call GetVideoMode		;ah-
  shr ax,8			;ax=ah

  push cx
  push ax
  mov cx,0
  call strlen_ex		;remember dx-offset text
				;func: ax strlen_ex(dx,cl);
  
  mov cx,ax			;cx=ax
  pop ax			;
  sub ax,cx			;ax=ax-cx
  pop cx			;
  mov dl,2			;dl=2
  div dl			;ax=ax/dl
  xor ah,ah			;ah=0
  call cursor_read		;
  cmp bl,1
  jne no_xcenter
  mov dl,al			;dl=al
  no_xcenter:
  cmp bh,1
  jne no_ycenter
  
  no_ycenter:
  call cursor_set		;sursor_set(dl,dh)
  pop dx
  pop ax
  ret
 SetCursorCenter endp

 include strutils.inc
 include graphics.inc
 title_app	db '$',0ah,'----===MSDOS===----','$',07h,0Dh,0Ah,0

 vendor		db '$',04h,'Vendor pack:   javavirys','$',07h,0Dh,0Ah,0
 web_page	db 'WEB: http://java-virys.narod.ru',0Dh,0Ah,0,'$'
 split		db 0Dh,0Ah,'$'
 buff		db 255,?,254 dup(?)
CODESG ends

end MAIN