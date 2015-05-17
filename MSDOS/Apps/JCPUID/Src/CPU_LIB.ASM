
;Out:	none
;ret:	if(ax==0) fail
;	if(ax==1) success
is386machine proc
	pushf
	pushf
	pop ax
	xor ah,11110000b
	push ax
	popf
	pushf
	pop bx
	popf
	xor ah,bh
	jne is386machine_error
		mov ax,1
		jmp is386machine_result
	is386machine_error:
		mov ax,0
	is386machine_result:
	ret
is386machine endp

.586
;ret:	eax(al): 0 - not support
;		 1 - support
fcpuid_support proc
	pushfd
	pop eax
	mov ebx,eax
	xor eax,00200000h
	push eax
	popfd
	pushfd
	pop eax
	;cmp eax,ebx
	xor eax,ebx
	je CPS_NO_CPUID
	mov eax,1
	jmp CPS_FINISH_CPUID
	CPS_NO_CPUID:
		mov eax,0
	CPS_FINISH_CPUID:	
		ret
fcpuid_support endp

;
;ret: ebx+edx+ecx-string vendor name
.586
fget_cpuid_vendor proc
	mov eax,0
	cpuid
	ret
fget_cpuid_vendor endp

;ret:	eax[3:0]-stepping
;	eax[7:4]-model
;	eax[11:8]-family
;	eax[13:12]-Type
fget_cpuid_signatures_of_cpu proc
	mov eax,1
	cpuid
	ret
fget_cpuid_signatures_of_cpu endp