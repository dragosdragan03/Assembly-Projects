global get_words

compare_func:

    push ebp
    mov ebp, esp

    push esi
    push edi
    push ebx

    xor esi, esi
    xor edi, edi

    mov esi, [ebp + 8] ; primul cuvant
    mov edi, [ebp + 12] ; al dolea cuvant

    mov esi, [esi]
    mov edi, [edi]

    push esi ; ca sa nu pierd valorile
    push edi

    xor eax, eax
    push esi
    call strlen
    add esp, 4

    pop edi
    pop esi

    xor ebx, ebx
    mov ebx, eax ; am retinut rezultatul in ebx
    xor eax, eax

    push esi
    push edi
    push ebx ; ca sa retin valoarea lui ebx

    push edi
    call strlen
    add esp, 4

    pop ebx
    pop edi
    pop esi

    cmp eax, ebx
    je comparare_lexicografic

    cmp eax, ebx
    jl mai_mic

    xor eax, eax
    sub eax, 1 ; eax = -1

return:

    pop ebx
    pop edi
    pop esi
    leave
    ret

mai_mic:

    xor eax, eax
    add eax, 1 ; eax = 1
    jmp return

comparare_lexicografic:

    xor eax, eax
    push edi
    push esi
    call strcmp
    add esp, 8

    pop ebx
    pop edi
    pop esi
    leave
    ret

global sort

section .data
    delim db ' ,.', 0
    format db "%s ", 0

section .text
    extern strtok
    extern printf
    extern strcpy
    extern strcmp
    extern strlen
    extern qsort

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor
;  dupa lungime si apoi lexicografix
sort:

    enter 0, 0

    mov esi, [ebp + 8] ; vectorul de cuvinte
    mov eax, [ebp + 12] ; numarul de cuvinte
    mov ecx, [ebp + 16] ; size

    push compare_func
    push ecx
    push eax
    push esi
    call qsort
    add esp, 16

    leave
    ret

; get_words(char *s, char **words, int number_of_words)
; separa stringul s in cuvinte si salveaza cuvintele in words
; number_of_words reprezinta numarul de cuvinte
get_words:

    enter 0, 0
    pusha
    mov esi, [ebp + 8] ; vectorul de cuvinte
    mov edi, [ebp + 12] ; vectorul de cuvinte separate
    mov eax, [ebp + 16] ; numarul de cuvinte

    xor ebx, ebx ; contorul pentru stringul meu de cuvinte

    push esi
    push eax
    push edi
    push ebx

    xor eax, eax ; stochez in eax rezultatul
    push delim
    push esi
    call strtok
    add esp, 8

    pop ebx
    pop edi

    push ebx
    push edi

    xor edx, edx ; mut in edx destinatia unde vreau sa copiez
    mov edx, [edi + 4 * ebx]
    push eax
    push edx
    call strcpy
    add esp, 8

    pop edi
    pop ebx
    pop eax
   pop esi

    inc ebx

loop:

    cmp ebx, eax
    je end_loop

    push esi
    push eax
    push edi
    push ebx

    xor eax, eax ; stochez in eax rezultatul
    push delim
    push 0
    call strtok
    add esp, 8

    pop ebx
    pop edi

    push ebx
    push edi

    xor edx, edx ; mut in edx destinatia unde vreau sa copiez
    mov edx, [edi + 4 * ebx]
    push eax
    push edx
    call strcpy
    add esp, 8

    pop edi
    pop ebx
    pop eax
    pop esi

    inc ebx
    jmp loop

end_loop:
    popa
    leave
    ret
