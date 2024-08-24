extern array_idx_2      ;; int array_idx_2

section .text
    global inorder_intruders

;   struct node {
;       int value;
;       struct node *left;
;       struct node *right;
;   } __attribute__((packed));

struc node
    .value: resd 1        ; int value
    .left: resd 1         ; struct node* left
    .right: resd 1         ; struct node* right
endstruc

;;  inorder_intruders(struct node *node, struct node *parent, int *array)
;       functia va parcurge in inordine arborele binar de cautare, salvand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista
;
;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;
;        array  -> adresa vectorului unde se vor salva valorile din noduri;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          vectorul array este INDEXAT DE LA 0!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

; HINT: folositi variabila importata array_idx_2 pentru a retine pozitia
;       urmatorului element ce va fi salvat in vectorul array.
;       Este garantat ca aceasta variabila va fi setata pe 0 la fiecare
;       test al functiei inorder_intruders.

inorder_intruders:
    enter 0, 0
    pusha
    mov eax, [ebp + 8] ;nodul curent

    cmp eax, dword 0 ; Verific dacă este NULL
    je end_inorder_intruders

    ; Parcurg stânga
    mov eax, [ebp + 8] ; nodul curent
    mov edx, [ebp + 12] ; nodul parinte
    mov edx, eax ; eax devine noul parinte
    mov eax, [eax + node.left] ; nodul din stanga
    push dword [ebp + 16]
    push edx
    push eax
    call inorder_intruders
    add esp, 12

    ; mut valoarea in vector daca este gresita
    mov eax, [ebp + 8] ; nodul curent
    mov edx, [ebp + 12] ; nodul parinte

    cmp edx, 0
    je jump

    mov esi, [edx + node.right] ; nodul din dreapta al parintelui
    mov edi, [edx + node.left] ; nodul din stanga parintelui

    mov ebx, [ebp + 16] ; adresa de inceput a vectorului meu
    mov ecx, dword [array_idx_2]

    cmp eax, edi ; daca nodul curent este nodul din stanga al parintelui
    je mai_mic

    cmp eax, esi ; daca nodul curent este nodul din dreapta al parintelui
    je mai_mare

    jmp jump

mai_mic:
    mov eax, [eax + node.value] ; valoarea nodului
    mov edx, [edx + node.value] ; valoarea parintelui

    cmp eax, edx
    jl jump

    mov [ebx + 4 * ecx], eax ; inseamna ca e valoarea gresita
    inc dword [array_idx_2] ; incrementez indexul

    jmp jump

mai_mare:
    mov eax, [eax + node.value] ; valoarea nodului
    mov edx, [edx + node.value] ; valoarea parintelui

    cmp eax, edx
    jg jump

    mov [ebx + 4 * ecx], eax ; inseamna ca e valoarea gresita
    inc dword [array_idx_2] ; incrementez indexul

jump:

    ; Parcurg dreapta
    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    mov edx, eax ; eax devine noul parinte
    mov eax, [eax + node.right] ; nodul din dreapta
    push dword [ebp + 16]
    push edx
    push eax
    call inorder_intruders
    add esp, 12

end_inorder_intruders:

    popa
    leave
    ret
