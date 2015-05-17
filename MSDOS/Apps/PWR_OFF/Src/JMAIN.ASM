MAINSG	segment
assume	cs:MAINSG
org	100h
MAIN	proc
	lea	dx,str_title
	call	write_text
	lea	dx,str_question
	call	write_text
	lea	dx,str_buff
	call	read_text			;keyboard read
	call	write_text			;write	on scrn
	lea	di,byte ptr[str_buff+2]		;pointer start str(offset 2)
	lea	si,str_yes
	call	strcmp
	cmp	ax,0
	jne	main_exit

	mov	ax,05301h
	mov	bx,0000h
	int	15h
	mov	ax,0530Eh
	mov	bx,0000h
	mov	cx,0102h
	int	15h
	mov	ax,05307h
	mov	bx,0001h
	mov	cx,0003h
	int	15h
	
	main_exit:
		mov 	ah,4Ch
		int	20h
	ret
MAIN	endp


include graphics.inc
include	strutils.asm
str_buff	db 255 dup('$')

str_title	db 'Web: http://java-virys.narod.ru',0Dh,0Ah,'$'
str_question	db 'Shutdown this PC?',0Dh,0Ah,'(yes/no):$'
str_yes		db 'yes',0dh,'$'
str_t		db 'hello$'
MAINSG	ends
end	MAIN