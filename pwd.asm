section .data
	back db "..", 0
	curr db ".", 0
	slash db "/", 0
	format db "%d", 0

section .text
	global pwd
	extern strcat
	extern strcmp
	extern printf

;;	void pwd(char **directories, int n, char *output)
;	Adauga in parametrul output path-ul rezultat din
;	parcurgerea celor n foldere din directories

	;; DO NOT MODIFY

pwd:

	enter 0, 0

    mov esi, [ebp + 8]	; vectorul de stringuri
    mov eax, [ebp + 12]	; numarul de inputuri indexate de la 0
    mov edi, [ebp + 16] ; vectorul meu final de stringuri de la final

    ;; DO NOT MODIFY

	xor ecx, ecx ; il folosesc pentru a contoriza pozitia stringului de input
	xor edx, edx ; il folosesc pentru parcurge sirul de stringuri din output

loop:

	cmp ecx, eax ; daca sunt egale inseamnca ca s a ajuns la final
	je final_pwd


	pusha

	xor edx, edx
	mov edx, [esi + 4 * ecx]
	push curr
	push edx
	call strcmp
	add esp, 8
	cmp eax, 0 ; daca sunt egale inseamna ca nu fac nimic
	je punct

	popa

	pusha
	xor edx, edx
	mov edx, [esi + 4 * ecx]
	push back
	push edx
	call strcmp
	add esp, 8
	cmp eax, 0 ; daca sunt egale inseamna ca trebuie sa dau remove la ultimul string
	je remove

	popa

	jmp adaugare

punct:
	popa

terminare_operatie:

	inc ecx
	jmp loop

adaugare:

	; adaug slashul inainte cuvantului meu
	pusha
	push slash
	push edi
	call strcat
	add esp, 8
	popa

	pusha
	xor edx, edx
	mov edx, [esi + 4 * ecx]
	push edx ; pun stringul pe care vreau sa l adaug
	push edi ; pun stringul la care vreau sa l adaug
	call strcat
	add esp, 8 ; actualizez stiva ca am 2 pointeri
	popa

	add edx, 1 ; inseamna ca am mai adaugat un cuvant

 	jmp terminare_operatie

remove:
	popa

	cmp edx, 0
	je terminare_operatie

	push ebx
	push eax
	xor eax, eax ; il folosesc ca si contor pentru cuvinte
 	xor ebx, ebx
 	sub edx, 1
 	jmp refacere_string

gata_refacere:

	mov byte [edi + ebx], 0 ; pun NULL pe pozitia slash-ului pentru a sterge tot de dupa el
	pop eax
	pop ebx
  	jmp terminare_operatie

refacere_string:

	cmp eax, edx
	je gata_refacere

	add eax, 1
	add ebx, 1
parcurgere:

	cmp byte [edi + ebx], 47 ; daca este slash (/)
	je refacere_string

	add ebx, 1
	jmp parcurgere

final_pwd:
	pusha
	push slash
	push edi
	call strcat
	add esp, 8
	popa

	leave
	ret