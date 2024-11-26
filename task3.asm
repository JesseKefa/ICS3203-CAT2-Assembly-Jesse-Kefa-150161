section .data
    prompt db "Enter a number to calculate the factorial: ", 0
    result_msg db "Factorial is: ", 0
    newline db 0xA, 0 ; newline character
    buffer db 10, 0    ; buffer to store the user input

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

    ; Read the user input
    mov eax, 3         ; sys_read
    mov ebx, 0         ; file descriptor (stdin)
    mov ecx, buffer    ; address of input buffer
    mov edx, 10        ; maximum number of bytes to read
    int 0x80           ; call kernel

    ; Output what user entered (debug)
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, buffer    ; address of input buffer
    mov edx, 10        ; maximum length of input buffer
    int 0x80           ; call kernel

    ; Convert ASCII to integer (assuming single digit input for simplicity)
    mov al, [buffer]   ; Load first byte (user input)
    sub al, '0'        ; Convert from ASCII to integer

    ; Store the input number in num
    mov [num], al

    ; Calculate factorial (n!)
    mov cl, [num]      ; Load the input number
    mov ax, 1          ; Set ax to 1 (factorial result)

factorial_loop:
    cmp cl, 1          ; Compare current number with 1
    jbe done           ; If cl <= 1, exit loop
    mul cl             ; Multiply ax by cl (ax = ax * cl)
    dec cl             ; Decrease cl by 1
    jmp factorial_loop ; Repeat the loop

done:
    ; Print result message
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, result_msg ; address of result message
    mov edx, 15        ; length of result message
    int 0x80           ; call kernel

    ; Print the factorial result (converted to ASCII)
    ; We will now convert the result (in ax) to ASCII

    ; Convert ax to ASCII
    add ax, '0'        ; Convert result to ASCII
    mov [buffer], al   ; Store the result (only first byte)

    ; Print the result
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, buffer    ; address of result buffer
    mov edx, 1         ; length of result buffer
    int 0x80           ; call kernel

    ; Print newline
    mov eax, 4         ; sys_write
    mov ebx, 1         ; file descriptor (stdout)
    mov ecx, newline   ; address of newline
    mov edx, 1         ; length of newline
    int 0x80           ; call kernel

    ; Exit program
    mov eax, 1         ; sys_exit
    xor ebx, ebx       ; return code 0
    int 0x80
