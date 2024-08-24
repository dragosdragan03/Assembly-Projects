%include "../include/io.mac"

struc proc
	.pid: resw 1
	.prio: resb 1
	.time: resw 1
endstruc

section .text
	global sort_procs
	extern printf

sort_procs:
	;; DO NOT MODIFY
	enter 0,0
	pusha

	mov edx, [ebp + 8]      ; processes
	mov eax, [ebp + 12]     ; length
	;; DO NOT MODIFY
	;; Your code starts here

	mov edi, eax
	xor eax, eax
	xor ebx, ebx ; pentru a parcurge for ul pana la finalul vectorului

for_loop:

	push ebx
	add ebx, 1
	cmp ebx, edi
	je done

	pop ebx
	mov esi, ebx

next_loop:

	add esi, 1 ; j++

	cmp esi, edi
	je gata_interschimbarea

	push ebx
	push esi

	imul ebx, ebx, 5
	imul esi, esi, 5

	mov cl, [edx + ebx + proc.prio]  ;retin in ecx valoarea prioritatii din structura proc
	mov al, [edx + esi + proc.prio]

	pop esi
	pop ebx

	cmp al, cl ; daca ala de dupa este mai mare decat
	jl interschimbare_prio ; dac trece de aceasta conditie inseamnna ca proprietatile sunt egale

	cmp al, cl
	je cuanta_de_timp ;inseamna ca sunt egale si trebuie verificata cuanta de timp

gata_interschimbarea:

	cmp esi, edi
	jl next_loop

	add ebx, 1
	cmp ebx, edi ; daca s a terminal loopul
	jl for_loop

	jmp done

interschimbare_prio: ;interschimb prio si toate de dupa

    push ecx
    push eax
    pop ecx
    pop eax

    push ebx
    push esi

    imul ebx, ebx, 5
    imul esi, esi, 5

    mov [edx + ebx + proc.prio], cl
    mov [edx + esi + proc.prio], al

    mov cx, [edx + ebx + proc.time]
    mov ax, [edx + esi + proc.time]

    push ecx
    push eax
    pop ecx
    pop eax

    mov [edx + ebx + proc.time], cx
    mov [edx + esi + proc.time], ax

    mov cx, [edx + ebx + proc.pid]
    mov ax, [edx + esi + proc.pid]

    push ecx ; am interschimbat valorile
    push eax
    pop ecx
    pop eax

    mov [edx + ebx + proc.pid], cx
    mov [edx + esi + proc.pid], ax

    pop esi
    pop ebx

    jmp gata_interschimbarea

interschimbare_timp: ;interschimb timpul si toate de dupa

    push ecx
    push eax
    pop ecx
    pop eax

    push ebx
    push esi

    imul ebx, ebx, 5
    imul esi, esi, 5

    mov [edx + ebx + proc.time], cx
    mov [edx + esi + proc.time], ax

    mov cx, [edx + ebx + proc.pid]
    mov ax, [edx + esi + proc.pid]

    push ecx ; am interschimbat valorile
    push eax
    pop ecx
    pop eax

    mov [edx + ebx + proc.pid], cx
    mov [edx + esi + proc.pid], ax

    pop esi
    pop ebx

   jmp gata_interschimbarea
cuanta_de_timp:

    push ebx
    push esi

    imul ebx, ebx, 5
    imul esi, esi, 5

    mov cx, [edx + ebx + proc.time]  ;retin in ecx valoarea prioritatii din structura proc
    mov ax, [edx + esi + proc.time]

    pop esi
    pop ebx

    cmp ax, cx ;daca ala din dreapta este mai mic decat cel din stanga trebuie interschimbate
    jl interschimbare_timp

    cmp ax, cx
    je numar_id

    jmp gata_interschimbarea
interschimbare_id:

    push ecx ; am interschimbat valorile
    push eax
    pop ecx
    pop eax

    push ebx
    push esi

    imul ebx, ebx, 5
    imul esi, esi, 5

    mov [edx + ebx + proc.pid], cx
    mov [edx + esi + proc.pid], ax

    pop esi
    pop ebx

    jmp gata_interschimbarea

numar_id:

    push ebx
    push esi

    imul ebx, ebx, 5
    imul esi, esi, 5

    mov cx, [edx + ebx + proc.pid]  ; retin in ecx valoarea prioritatii din structura proc
    mov ax, [edx + esi + proc.pid]

    pop esi
    pop ebx

    cmp ax, cx ; daca ala din dreapta este mai mic decat cel din stanga trebuie interschimbate
    jl interschimbare_id

    jmp gata_interschimbarea

done:
	pop ebx
	;; Your code ends here

	;; DO NOT MODIFY
	popa
	leave
	ret
	;; DO NOT MODIFY