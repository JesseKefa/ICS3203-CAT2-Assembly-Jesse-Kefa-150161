section .data
    prompt db "Enter 5 integers: ", 0
    newline db 0xA, 0

section .bss
    arr resd 5               ; reserve space for 5 integers

section .text
    global _start

_start:
    ; Prompt for input
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, prompt         ; address of the prompt message
    mov edx, 23             ; length of the prompt
    int 0x80                ; call kernel

    ; Read 5 integers into the array
    mov eax, 3              ; sys_read
    mov ebx, 0              ; file descriptor (stdin)
    mov ecx, arr            ; address of array
    mov edx, 20             ; max bytes to read
    int 0x80                ; call kernel

    ; Reverse the array using a loop
    mov ecx, 0              ; loop index (start)
    mov edx, 4              ; size of each integer (4 bytes)
    mov ebx, 4              ; loop counter (5 elements, so 4 swaps needed)

reverse_loop:
    ; Swap arr[ecx] and arr[ebx]
    mov eax, [arr + ecx*4]  ; load arr[ecx]
    mov esi, [arr + ebx*4]  ; load arr[ebx]
    mov [arr + ecx*4], esi  ; store arr[ebx] in arr[ecx]
    mov [arr + ebx*4], eax  ; store arr[ecx] in arr[ebx]

    ; Update indices for next swap
    inc ecx
    dec ebx
    cmp ecx, ebx
    jl reverse_loop         ; continue loop if ecx < ebx

    ; Output reversed array
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, arr            ; address of the array
    mov edx, 20             ; max bytes to print (up to 5 integers)
    int 0x80                ; call kernel

    ; Exit program
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; return code 0
    int 0x80                ; call kernel
