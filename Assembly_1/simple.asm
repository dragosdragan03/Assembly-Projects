%include "../include/io.mac"

section .text
    global simple
    extern printf

simple:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     ecx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; plain
    mov     edi, [ebp + 16] ; enc_string
    mov     edx, [ebp + 20] ; step

    ;; DO NOT MODIFY

    ;; Your code starts here

    mov ebx, 0

for_loop:

    movzx eax, byte [esi + ebx] ; am mutat caracterul din plain
    add eax, edx ; am adaugat la caracter stepul

    cmp eax, 90 ; daca eax e mai mic decat 90 adica daca este mai mic decat Z (90 ascii)
    jle jump ; sare peste scaderea aceea
    sub eax, 26
jump:
    mov [edi + ebx], eax ; l am mutat la loc
    add ebx, 1
    cmp ebx, ecx ; daca ebx e mai mic decat ecx continua loopul
    jl for_loop

    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret

    ;; DO NOT MODIFY
