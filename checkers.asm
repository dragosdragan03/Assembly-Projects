
section .data

section .text
	global checkers

checkers:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; table

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    push eax
    push ebx
    add eax, 1 ; ca sa fac verificarea pentru partea de sus
    cmp eax, 8 ; daca eax este mai mic strict  decat 8
    jl sus

gata_sus:
    pop ebx ; revin la varianata initiala a indexilor
    pop eax ;

    sub eax, 1 ; eax - 1
    cmp eax, 0
    jge jos

    jmp final
sus:

    imul eax, eax, 8 ; inmultesc cu 8*(eax+1)
    sub ebx, 1 ; scad 1 ca sa pot sa bag in matricea mea
    cmp ebx, 0
    jge sus_stanga

gata_stanga_sus:

    add ebx, 2
    cmp ebx, 8
    jl dreapta_sus

    jmp gata_sus

sus_stanga:

    add eax, ebx ; (edx + ebx)
    mov [ecx + eax], byte 1
    sub eax, ebx
    jmp gata_stanga_sus

dreapta_sus:

    add eax, ebx ; (edx + ebx)
    mov [ecx + eax], byte 1
    sub eax, ebx
    jmp gata_sus

jos:
    imul eax, eax, 8
    sub ebx, 1
    cmp ebx, 0
    jge jos_stanga

gata_jos_stanga:

    add ebx, 2
    cmp ebx, 8
    jl jos_dreapta

    jmp final

jos_stanga:

    add eax, ebx
    mov [ecx + eax], byte 1
    sub eax, ebx
    jmp gata_jos_stanga

jos_dreapta:

    add eax, ebx
    mov [ecx + eax], byte 1
    sub eax, ebx

final:


    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY