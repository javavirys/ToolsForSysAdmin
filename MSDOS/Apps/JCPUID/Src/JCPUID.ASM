CODESG segment
 assume cs:CODESG
 org 100h
 
 MAIN proc
.8086

	lea     dx,title_app
	call    write_text
					
.586
	call    fcpuid_support

	cmp	eax,1
	jne	MAIN_NO_CPUID_FOUND

	lea	dx,str_cpuid_support
	call	WRITE_TEXT
	
	call	fget_cpuid_vendor
	mov	dword ptr str_var_cpuid_vendor_name,ebx
	mov	dword ptr str_var_cpuid_vendor_name[+4],edx
	mov	dword ptr str_var_cpuid_vendor_name[+8],ecx
	mov	byte ptr str_var_cpuid_vendor_name[+12],'$'
	lea	dx, str_cpuid_vendor_name
	call	write_text
	lea	dx,str_var_cpuid_vendor_name
	call	write_text

	call	fget_cpuid_signatures_of_cpu
	
	;--------------Type--------------;
	push 	eax
	call	fsplit_text
	lea	dx,str_cpuid_type
	call	write_text
	and	eax,3000h
	shr	eax,12d
	call	write_int_digit
	call	fsplit_text
	pop	eax
	;-----------Get Family-----------;
	push	eax
	lea	dx,str_cpuid_family
	call	write_text
	and	eax,0F00h
	shr	eax,8
	call	WRITE_INT_DIGIT
	pop	eax
	;-------------Model--------------;
	push eax
	call	fsplit_text
	lea	dx, str_cpuid_model
	call	write_text
	and	eax,0F0h
	shr	eax,4
	call	WRITE_INT_DIGIT
	pop eax
	;----------Get Stepping----------;
	push	eax
	call	fsplit_text
	lea	dx,str_cpuid_stepping
	call	write_text
	and	eax,0Fh
	call	WRITE_INT_DIGIT
	pop	eax

	jmp	MAIN_EXIT

	MAIN_NO_CPUID_FOUND:
		lea dx,str_cpuid_not_support
		call WRITE_TEXT
		
.8086
	;---------Quit----------;
	MAIN_EXIT:
		mov    ah,4Ch
		int    20h
		ret
 MAIN endp

 

 fsplit_text proc
	push dx
	lea dx,str_split_text
	call WRITE_TEXT
	pop dx
	ret
 fsplit_text endp

 include cpu_lib.asm
 include strutils.inc
 include graphics.inc
 include jconst.inc

 title_app			db 'JCPUID:',0Dh,0Ah,'$'
 str_is386_machine		db 'is i386 machine',0Dh,0Ah,'$'
 str_isNO386_machine		db 'is machine not support x86 instructions',0dh,0ah,'$'
 str_cpuid_support		db 'CPUID is supported',0Dh,0Ah,'$'
 str_cpuid_not_support		db 'CPUID is not support',0Dh,0Ah,'$'
 str_cpuid_vendor_name		db 'Vendor name: ','$'
 str_var_cpuid_vendor_name	db 13 dup (?)
 str_cpuid_type			db 'Type: $'
 str_cpuid_family		db 'Family: ','$'
 str_cpuid_model		db 'Model: ','$'
 str_cpuid_stepping		db 'Stepping: ','$'
 str_split_text			db '   ',0Dh,0Ah,'$'
 str_test			db 'next',0Dh,0Ah,'$'
 int_test			db 123
	str_bx			db 'bx: $'
	str_ax			db 'ax: $'
	str_cx			db 'cx: $'

 
 buff		db 255,?,254 dup(?)
CODESG ends

end MAIN