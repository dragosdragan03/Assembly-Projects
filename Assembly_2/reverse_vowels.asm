section .text
	global reverse_vowels
	extern printf

;;	void reverse_vowels(char *string)
;	Cauta toate vocalele din string-ul `string` si afiseaza-le
;	in ordine inversa. Consoanele raman nemodificate.
;	Modificare se va face in-place
reverse_vowels:

	push ebp
    push esp
    pop ebp

	push dword [ebp + 8]
	pop ecx ; retin stringul in aceasta variabila

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	xor esi, esi

loop_start:
	cmp byte [ecx + esi], 0 ; daca este null caracterul
	je loop_end

	cmp byte [ecx + esi], byte 97 ; compar cu a si pun pe stiva daca sunt egale
	je punere_stiva

	cmp byte [ecx + esi], byte 101 ; compar cu e
	je punere_stiva

	cmp byte [ecx + esi], byte 105 ; compar cu i
	je punere_stiva

	cmp byte [ecx + esi], byte 111 ; compar cu o
	je punere_stiva

	cmp byte[ecx + esi], byte 117 ; compar cu u
	je punere_stiva

continuare:

	add esi, 1

    jmp loop_start ; Continuă la următorul caracter din șir

punere_stiva:

	xor eax, eax
	or al, byte [ecx + esi]
	push eax

	jmp continuare

loop_end:
    ; schimb vocalele
	xor esi, esi

loop_start_replace:
	cmp byte [ecx + esi], 0 ; daca este null caracterul
	je loop_end_function

	cmp byte [ecx + esi], byte 97 ; compar cu a si scot de pe stiva daca sunt egale
	je scoatere_stiva

	cmp byte [ecx + esi], byte 101 ; compar cu e
	je scoatere_stiva

	cmp byte [ecx + esi], byte 105 ; compar cu i
	je scoatere_stiva

	cmp byte [ecx + esi], byte 111 ; compar cu o
	je scoatere_stiva

	cmp byte[ecx + esi], byte 117 ; compar cu u
	je scoatere_stiva

continuare_replace:

	add esi, 1

    jmp loop_start_replace ; Continuă la următorul caracter din șir

scoatere_stiva:

	xor eax, eax
	pop eax ; scot litera de pe stiva
	and byte [ecx + esi], 0
	or byte [ecx + esi], al

	jmp continuare_replace

loop_end_function:

	pop ebp
	ret