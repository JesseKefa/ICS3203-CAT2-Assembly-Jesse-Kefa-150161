section .data
    msg db "Enter a number to calculate the fact3", 0
    newline db 10

section .bss
    num resb 4           ; Reserve 4 bytes for the user input

section .text
    global _start

_start:
    ; Print the message asking for input
    mov eax, 4          ; sys_write
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, msg        ; message address
    mov edx, 31         ; message length
    int 0x80            ; call kernel

    ; Read the input from the user
    mov eax, 3          ; sys_read
    mov ebx, 0          ; file descriptor (stdin)
    mov ecx, num        ; buffer for input
    mov edx, 4          ; max bytes to read
    int 0x80            ; call kernel

    ; Convert input to integer (assume input is a small number for simplicity)
    ; You should implement a proper atoi here
    mov eax, [num]      ; load input as string, assuming it's small
    sub eax, '0'        ; convert ASCII to integer

    ; Call the factorial subroutine
    push eax            ; push number onto stack
    call factorial
    pop ebx             ; clean up the stack after call

    ; Print the result (you need to convert the result back to a string for printing)
    ; Print the result (just a placeholder for now)
    mov eax, 4          ; sys_write
    mov ebx, 1          ; file descriptor (stdout)
    mov ecx, num        ; assuming num contains the result (incorrect)
    mov edx, 4          ; length of the result
    int 0x80            ; call kernel

    ; Exit the program
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; status 0
    int 0x80            ; call kernel

factorial:
    ; Base case: if input is 1 or 0, return 1
    cmp eax, 1
    je .base_case
    cmp eax, 0
    je .base_case

    ; Recursive case: factorial(n) = n * factorial(n-1)
    push eax
    dec eax
    call factorial
    pop ebx             ; restore the previous value of n
    imul eax, ebx       ; multiply result by n
    ret

.base_case:
    mov eax, 1          ; return 1 for factorial of 0 or 1
    ret
