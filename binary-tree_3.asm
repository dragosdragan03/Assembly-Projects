section .text
    global inorder_fixing

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

;;  inorder_fixing(struct node *node, struct node *parent)
;       functia va parcurge in inordine arborele binar de cautare, modificand
;       valorile nodurilor care nu respecta proprietatea de arbore binar
;       de cautare: |node->value > node->left->value, daca node->left exista
;                   |node->value < node->right->value, daca node->right exista.
;
;       Unde este nevoie de modificari se va aplica algoritmul:
;           - daca nodul actual este fiul stang, va primi valoare tatalui - 1,
;                altfel spus: node->value = parent->value - 1;
;           - daca nodul actual este fiul drept, va primi valoare tatalui + 1,
;                altfel spus: node->value = parent->value + 1;

;    @params:
;        node   -> nodul actual din arborele de cautare;
;        parent -> tatal/parintele nodului actual din arborele de cautare;

; ATENTIE: DOAR in frunze pot aparea valori gresite!
;          Cititi SI fisierul README.md din cadrul directorului pentru exemple,
;          explicatii mai detaliate!

inorder_fixing:
    enter 0, 0
    pusha
    mov eax, [ebp + 8] ;nodul curent

    cmp eax, dword 0 ; Verific dacă este NULL
    je end_inorder_fixing

    ; Parcurg stânga
    mov eax, [ebp + 8] ; nodul curent
    mov edx, [ebp + 12] ; nodul parinte
    mov edx, eax ; eax devine noul parinte
    mov eax, [eax + node.left] ; nodul din stanga
    push edx
    push eax
    call inorder_fixing
    add esp, 8

    mov eax, [ebp + 8] ; nodul curent
    mov edx, [ebp + 12] ; nodul parinte

    cmp edx, 0
    je jump

    mov esi, [edx + node.right] ; nodul din dreapta al parintelui
    mov edi, [edx + node.left] ; nodul din stanga parintelui

    cmp eax, edi ; daca nodul curent este nodul din stanga al parintelui
    je mai_mic

    cmp eax, esi ; daca nodul curent este nodul din dreapta al parintelui
    je mai_mare

    jmp jump

mai_mic:
    mov esi, [eax + node.value] ; valoarea nodului
    mov edi, [edx + node.value] ; valoarea parintelui

    cmp esi, edi
    jl jump

    xor esi, esi
    mov esi, edi
    sub esi, 1
    mov [eax + node.value], esi

    jmp jump

mai_mare:

    mov esi, [eax + node.value] ; valoarea nodului
    mov edi, [edx + node.value] ; valoarea parintelui

    cmp esi, edi
    jg jump

    xor esi, esi
    mov esi, edi
    add esi, 1
    mov [eax + node.value], esi

jump:

    ; Parcurg dreapta
    mov eax, [ebp + 8]
    mov edx, [ebp + 12]
    mov edx, eax ; eax devine noul parinte
    mov eax, [eax + node.right] ; nodul din dreapta
    push edx
    push eax
    call inorder_fixing
    add esp, 8

end_inorder_fixing:

    popa
    leave
    ret
