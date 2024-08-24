%include "../include/io.mac"

section .data

section .text
    global bonus
    extern printf

pow:
    push ebp
    mov ebp, esp

    mov edi, [ebp + 8]
    mov eax, 1    ; incep cu valoarea 1

loop:

    shl eax, 1   ; Shiftez la stanga
    sub edi, 1
    cmp edi, 0
    jg loop

    leave
    ret

bonus:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]	; x
    mov ebx, [ebp + 12]	; y
    mov ecx, [ebp + 16] ; board

    ;; DO NOT MODIFY
    ;; FREESTYLE STARTS HERE

    xor esi, esi ; pun 0 pe esi
    push ecx
    push eax
    push ebx
    push ecx
    add eax, 1 ; ca sa fac verificarea pentru partea de sus ; eax + 1
    cmp eax, 8 ; daca eax este mai mic strict  decat 8 inseamna ca exista parte de sus
    jl sus

gata_sus:
    cmp esi, 1
    je final
    pop ecx
    pop ebx ; revin la varianta de initiala
    pop eax ; revin la varianta de initiala

    sub eax, 1 ; eax - 1
    cmp eax, 0 ; inseamnca ca pot sa pun 1 pe linia de jos
    jge jos
    jmp final

sus:

    cmp eax, 4 ; daca este in board ul de sus
    jge board_sus

    jmp board_jos ; daca nu e sus inseanma ca e in board ul de jos

    jmp gata_sus

jos:

    add esi, 1
    cmp eax, 4 ; sa vad daca se afla in boardul de sus
    jge board_sus ; ultima linie de 1 o pun in board ul de sus

    jmp board_jos ; daca nu o pun sus inseamna ca o pun in boardul de jos

    jmp final

board_sus:

    sub eax, 4 ; eax + 1 - 4 / eax - 1 - 4
    imul eax, eax, 8 ; 8*(eax + 1 - 4) / 8 * (eax - 1 - 4)
    sub ebx, 1 ; ebx - 1
    cmp ebx, 0 ; daca pot sa pun in stanga
    jge stanga

gata_stanga_sus:

    add ebx, 2 ; ebx + 1
    cmp ebx, 8
    jl dreapta

    jmp gata_sus
stanga:

    push eax
    add eax, ebx

    push eax
    call pow
    add esp, dword 4
    add [ecx], eax
    pop eax
    jmp gata_stanga_sus

dreapta:

    push eax
    add eax, ebx
    push eax
    call pow
    add esp, dword 4
    add [ecx], eax ; pun 1 pe pozitia respectiva
    pop eax
    jmp gata_sus

board_jos:

    add ecx, dword 4 ; ECX + 4 BOARD JOS
    imul eax, eax, 8 ; 8*(eax + 1) / 8 * (eax - 1)
    sub ebx, 1 ; ebx - 1
    cmp ebx, 0 ; daca pot sa pun in stanga
    jge stanga

    jmp gata_stanga_sus
final:
    pop ecx

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY