section .data
    prompt db "Enter a number to calculate the factorial: ", 0
    result_msg db "Factorial is: ", 0
    newline db 0xA, 0  ; Newline character

section .bss
    num resb 1         ; Reserve 1 byte for the number input

section .text
    global _start

_start:
    ; Print prompt message
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, prompt    ; address of prompt message
    mov edx, 36        ; length of prompt message
    int 0x80           ; call kernel

    ; Read user input (single digit for simplicity)
    mov eax, 3         ; sys_read
    mov ebx, 0         ; file descriptor (stdin)
    mov ecx, num       ; address of input buffer
    mov edx, 1         ; maximum number of bytes to read
    int 0x80           ; call kernel

    ; Convert input from ASCII to integer
    mov al, [num]      ; Load input value
    sub al, '0'        ; Convert from ASCII to integer

    ; Save the number in a register to pass it to the subroutine
    mov bl, al         ; Store input number in bl for the subroutine

    ; Call factorial subroutine
    call factorial

    ; Print result message
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, result_msg ; address of result message
    mov edx, 15        ; length of result message
    int 0x80           ; call kernel

    ; Convert factorial result in eax to ASCII and print it
    add al, '0'        ; Convert result to ASCII
    mov [num], al      ; Store the result in buffer

    ; Print the result (factorial value)
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, num       ; address of result (single digit)
    mov edx, 1         ; length of result (1 digit)
    int 0x80           ; call kernel

    ; Print newline
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, newline   ; address of newline
    mov edx, 1         ; length of newline
    int 0x80           ; call kernel

    ; Exit the program
    mov eax, 1         ; sys_exit
    xor ebx, ebx       ; return code 0
    int 0x80

; Subroutine for calculating factorial
factorial:
    ; Save registers to the stack to preserve state
    push eax           ; Save the current value of eax (used to store result)
    push ebx           ; Save the current value of ebx (input number)

    ; Check if the input number (bl) is 0 or 1
    cmp bl, 1
    jbe factorial_done ; If bl <= 1, factorial is 1

    ; Otherwise, calculate factorial recursively
    dec bl             ; Decrement the input number (n-1)
    call factorial     ; Recursive call with (n-1)
    
    ; After recursion, multiply eax by the current number (n)
    pop ebx            ; Restore the previous value of ebx (the input number)
    mul bl             ; Multiply eax (current result) by bl (current number)
    
factorial_done:
    ; Restore registers from the stack
    pop ebx            ; Restore the original value of ebx
    pop eax            ; Restore the original value of eax

    ret                ; Return to the caller (main program)
