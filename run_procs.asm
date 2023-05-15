%include "../include/io.mac"

    ;;
struc avg
	.quo: resw 1
	.remain: resw 1
endstruc
    ;;

struc proc
    .pid: resw 1
    .prio: resb 1
    .time: resw 1
endstruc

    ;; Hint: you can use these global arrays
section .data
    prio_result dd 0, 0, 0, 0, 0
    time_result dd 0, 0, 0, 0, 0

section .text
    global run_procs
    extern printf
run_procs:
    ;; DO NOT MODIFY

    push ebp
    mov ebp, esp
    pusha

    xor ecx, ecx

clean_results:
    mov dword [time_result + 4 * ecx], dword 0
    mov dword [prio_result + 4 * ecx],  0

    inc ecx
    cmp ecx, 5
    jne clean_results

    mov ecx, [ebp + 8]      ; processes
    mov ebx, [ebp + 12]     ; length
    mov eax, [ebp + 16]     ; proc_avg

    ;; DO NOT MODIFY
    ;; Your code starts here

    xor edi, edi ; pentru a parcurge toate procesele
    xor esi, esi ; pentru indexii vectorului
for_loop:

    push edi
    imul edi, edi, 5 ; indexul pentru urmatoarele pid uri

    movzx edx, byte [ecx + edi + proc.prio] ; stochez prio ul in edx

    push edx ; ii dau push la prio
    xor edx, edx
    mov dx, [ecx + edi + proc.time] ; adaug timpul

    mov [time_result + 4 * esi], dx ; adaug in vectorul meu de sume prima valoare
    mov [prio_result + 4 * esi], dword 1 ;

    pop edx ; revin la prio ul primul
    pop edi

sum_loop:

    add edi, 1 ; pt urm procese

    cmp edi, ebx ; daca s a terminal loopul de procese
	je done

    push esi ; il bag ca sa stochez in el dupa prio ul urmatorul proces

    push edi
    imul edi, edi, 5
    xor esi, esi
    movzx esi, byte [ecx + edi + proc.prio] ; retin in esi urmatorul prio
    pop edi

    add edx, 1 ; daca prio ul celui din stanga e cu 2 mai mic
    cmp edx, esi
    jl adaug_zero
    sub edx, 1

    cmp edx, esi ; daca sunt egale face suma
    je sum

    pop esi

gata_zero:

    add esi, 1

    cmp esi, 5 ; daca trece inseamna ca inca nu mi s a terminat vectorul
    je done

    jmp for_loop

sum:
    pop esi ; pentru a lua pozitia vectorului

    push edx

    push edi
    imul edi, edi, 5


    mov dx, [time_result + 4 * esi]; suma pana la momentul actual
    add dx, [ecx + edi + proc.time]; fac suma dintre dh si ce este pana acm in vector
    mov [time_result + 4 * esi], dx

    mov edx, [prio_result + 4 * esi]; suma pana la momentul actual
    add edx, 1
    mov [prio_result + 4 * esi], edx

    pop edi
    pop edx
    jmp sum_loop

adaug_zero:

    pop esi
    add esi, 1; vreau sa pun pe pozitia urm 0
    mov [time_result + 4 * esi], dword 0 ; adaug in vectorul meu de sume prima valoare
    mov [prio_result + 4 * esi], dword 0 ;
    sub edx, 1
    jmp gata_zero

done:

    xor edi, edi
    xor ecx, ecx
    mov ebx, eax ; retin in ebx vectorul structura noua
for_struct:

    mov edx, dword [time_result + 4 * edi] ;pun in edx timpul
    mov esi, dword [prio_result + 4 * edi] ;pun in esi numarul de prio

    cmp esi, ecx ; daca esi este 0
    je jump

    mov eax, edx
    cdq
    idiv esi ; Se împarte conținutul EDX:EAX la valoarea din ESI
    mov [ebx + 4 * edi + avg.quo], ax ; Se stochează catul în câmpul .quo al variabilei de tip struct
    mov [ebx + 4 * edi + avg.remain], dx ;

next_step:

    add edi, 1
    cmp edi, 5
    jl for_struct
    jmp final

jump:

    mov [ebx + 4 * edi + avg.quo], cx
    mov [ebx + 4 * edi + avg.remain], cx
    jmp next_step

final:

    ;; Your code ends here

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY