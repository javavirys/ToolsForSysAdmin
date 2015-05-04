

;Output:	dx-offset str
;Ret:   	ax-number of symbols in string
;$Vendor:	Sychov Vitaliy
strlen proc
	push dx				;save dx
	push bx				;save bx
	xor ax,ax			;ax=0
	xor bx,bx			;bx=0
	mov si,dx			;si=offset str
	start_search:			;
		cld			; Left->Right
		jmp compare		;cmp first symbol
	next_search:
		lodsb			;load next symbol in 'al',
					; and load position in 'si'
		inc bl
	compare:
		cmp al,'$'		;if(str[i]!='$')
		jne next_search		;   continue search
	finish:
	xor ax,ax			;ax=0
	mov ax,bx			;ax=bx(count of symbols)
	pop bx				;restore bx
	pop dx				;restore dx
	ret
strlen endp

;dx-str
;cl-symbol of end
;ret: ax-size
strlen_ex proc
	push dx
	push bx
	push si
	xor ax,ax
	xor bx,bx
	mov si,dx
	init:
		cld
		;jmp cmpr
	next:
		lodsb
		inc bl
	cmpr:
		cmp al,cl
		jne next
	
		xor ax,ax
		mov ax,bx
		pop si
		pop bx
		pop dx
		ret
strlen_ex endp
