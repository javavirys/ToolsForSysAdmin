;------------------------------==STRUTILS==--------------------------------;
;-=v0.2=-

;Output:	dx-offset str
;Ret:   	ax-number of symbols in string
;$Vendor:	Sychov Vitaliy
strlen proc
	push dx				;save dx
	push bx				;save bx
	push si
	xor ax,ax			;ax=0
	xor bx,bx			;bx=0
	mov si,dx			;si=offset str
	start_search:			;
		cld			; Left->Right
		jmp compare		;cmp first symbol
	next_search:
		lodsb			;load next symbol in 'al',
					; and load position in 'si'
	compare:
		cmp al,'$'		;if(str[i]!='$')
		;jne next_search	;continue search
		je	finish

		inc	bx
		jmp	next_search
	finish:
	xor ax,ax			;ax=0
	mov ax,bx			;ax=bx(count of symbols)
	pop si
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

;OUT:	di-str1,si-str2
;ret:	ax=-1 	str1>str2
;	ax==0	str1==str2
;	ax==1	str1<str2
strcmp	proc
	push	bx
	push	cx
	push	dx
	mov	dx,di
	call	strlen			;ax=strlen(str1)
	mov	bx,ax
	mov	dx,si
	call	strlen			;ax=strlen(str2)
	;call	write_int_digit
	cmp	bx,ax
	
	jg	strcmp_first_big	;if(bx>ax)
	jl	strcmp_two_big		;if(bx<ax)
	mov	dx,ax			;dx=strlen(str2)
	xor	ax,ax
	xor	bx,bx
	xor	cx,cx
strcmp_init_loop:
	jmp	strcmp_cmp_loop
strcmp_next_loop:
	inc	di
	inc	si
	inc	cx			;loop count++
strcmp_cmp_loop:
	mov	al,[di]			;pointer on current symbol str1
	mov	bl,[si]			;pointer on current symbol str2
	cmp	cx,dx			
	je	strcmp_finishok_loop	
	cmp	al,bl			;
	je	strcmp_next_loop	;if(str1[i]==str2[i])
strcmp_finishfall:
	mov	ax,5			;
	jmp	strcmp_exit
strcmp_finishok_loop:
	mov	ax,0
	jmp	strcmp_exit
strcmp_first_big:
	mov	ax,-1
	jmp	strcmp_exit
strcmp_two_big:
	mov	ax,1
strcmp_exit:
	pop	dx
	pop	cx
	pop	bx
	ret
strcmp	endp

;not realize
;Out:	di-address of buffer
;	si-address of string to copy
;Ret:	di-value is pointer to the buffer
strcpy	proc
	push	ax
	push	cx
	push	dx
strcpy_init_cpy:
	xor	ax,ax
	xor	cx,cx
	mov	dx,si;
	call	strlen			;ax=strlen(str2)
	cmp	ax,0
	je	strcpy_exit
	jmp	strcpy_cmp_cpy
strcpy_next_cpy:
	
	inc	di
	inc	si
	inc	cx
strcpy_cmp_cpy:
	mov	bl,[si]			;str1[i]=str2[i]
	mov	[di],bl			;
	inc	di
	inc	si
	inc	cx
	cmp	cx,ax
	jne	strcpy_next_cpy
strcpy_exit:
	pop	dx
	pop	cx
	pop	ax
	ret
strcpy	endp
