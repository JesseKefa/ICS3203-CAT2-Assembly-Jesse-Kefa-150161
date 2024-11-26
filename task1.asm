section .data
    prompt db "Enter a number: ", 0
    pos_msg db "POSITIVE", 0
    neg_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0

section .bss
    user_input resb 10

section .text
    global _start

_start:
    ; Prompt user for input
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, prompt         ; address of the prompt message
    mov edx, 16             ; length of the prompt
    int 0x80                ; call kernel

    ; Read user input
    mov eax, 3              ; sys_read
    mov ebx, 0              ; file descriptor (stdin)
    mov ecx, user_input     ; buffer to store input
    mov edx, 10             ; max bytes to read
    int 0x80                ; call kernel

    ; Convert ASCII to integer
    mov eax, 0              ; clear eax (will store number here)
    mov ecx, user_input     ; pointer to the input buffer
    call ascii_to_int       ; convert input to integer

    ; Check if positive, negative, or zero
    cmp eax, 0              ; compare number with 0
    jg positive             ; if greater than 0, jump to positive
    jl negative             ; if less than 0, jump to negative
    jmp zero                ; if equal to 0, jump to zero

positive:
    ; Print "POSITIVE"
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, pos_msg        ; address of positive message
    mov edx, 8              ; length of positive message
    int 0x80                ; call kernel
    jmp _exit

negative:
    ; Print "NEGATIVE"
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, neg_msg        ; address of negative message
    mov edx, 8              ; length of negative message
    int 0x80                ; call kernel
    jmp _exit

zero:
    ; Print "ZERO"
    mov eax, 4              ; sys_write
    mov ebx, 1              ; file descriptor (stdout)
    mov ecx, zero_msg       ; address of zero message
    mov edx, 4              ; length of zero message
    int 0x80                ; call kernel

_exit:
    ; Exit program
    mov eax, 1              ; sys_exit
    xor ebx, ebx            ; return code 0
    int 0x80                ; call kernel

ascii_to_int:
    ; Convert ASCII to integer
    xor eax, eax            ; clear eax
    xor ebx, ebx            ; clear ebx (will hold the result)
.next_digit:
    movzx edx, byte [ecx]   ; load byte from input buffer
    cmp dl, 10              ; check for newline (end of input)
    je .done
    sub dl, '0'             ; convert ASCII to integer
    imul ebx, ebx, 10       ; multiply previous result by 10
    add ebx, edx            ; add current digit to result
    inc ecx                 ; move to next character
    jmp .next_digit
.done:
    mov eax, ebx            ; store result in eax
    ret
