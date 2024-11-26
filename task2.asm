section .data
    msg_prompt db "Enter 5 integers: ", 0
    msg_original db "Original Array: ", 0
    msg_reversed db "Reversed Array: ", 0
    newline db 10
    array_length db 5  ; Length of the array

section .bss
    arr resb 5         ; Reserve space for 5 integers

section .text
    global _start

_start:
    ; Print prompt message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_prompt
    mov edx, 18
    int 0x80

    ; Input the array of integers (space-separated input)
    mov eax, 3            ; sys_read
    mov ebx, 0            ; stdin
    lea ecx, [arr]        ; address of the input buffer
    mov edx, 20           ; number of bytes (enough space for 5 integers)
    int 0x80              ; call kernel to read input

    ; Print original array
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_original
    mov edx, 16
    int 0x80

    ; Print the original array (assuming space-separated integers)
    mov eax, 4
    mov ebx, 1
    lea ecx, [arr]
    mov edx, 20           ; Adjusted length for array print
    int 0x80

    ; Reverse the array in place
    lea esi, [arr]        ; esi points to the first element
    lea edi, [arr + 4]    ; edi points to the last element

reverse_loop:
    cmp esi, edi
    jge reverse_done      ; If pointers cross, stop
    mov al, [esi]         ; Load value at esi
    mov bl, [edi]         ; Load value at edi
    mov [esi], bl         ; Store value of edi into esi
    mov [edi], al         ; Store value of esi into edi
    inc esi               ; Move esi forward
    dec edi               ; Move edi backward
    jmp reverse_loop      ; Repeat

reverse_done:
    ; Print reversed array
    mov eax, 4
    mov ebx, 1
    mov ecx, msg_reversed
    mov edx, 17
    int 0x80

    ; Print the reversed array (assuming space-separated integers)
    mov eax, 4
    mov ebx, 1
    lea ecx, [arr]
    mov edx, 20           ; Adjusted length for array print
    int 0x80

    ; Exit program
    mov eax, 1            ; sys_exit
    xor ebx, ebx          ; status 0
    int 0x80
