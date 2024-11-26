section .data
    prompt db 'Enter a number: ', 0
    prompt_len equ $ - prompt
    message db 'The factorial is: ', 0
    newline db 0x0A  ; Newline character for formatting

section .bss
    buffer resb 16  ; Buffer to store the user input
    number resb 4   ; Space for user input (assuming 4-byte integer)

section .text
    global _start

_start:
    ; Print the prompt "Enter a number: "
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [prompt]         ; load address of prompt
    mov edx, prompt_len       ; length of the prompt string
    int 0x80                  ; Make the syscall to write to stdout

    ; Read the user input (up to 4 bytes, max number size)
    mov eax, 3                ; syscall number for sys_read
    mov ebx, 0                ; file descriptor (0 = stdin)
    lea ecx, [buffer]         ; address of buffer to store input
    mov edx, 16               ; number of bytes to read
    int 0x80                  ; Make the syscall to read user input

    ; Convert the input string to a number (ASCII to integer)
    lea esi, [buffer]         ; Point to the input string
    xor eax, eax              ; Clear eax (will hold the number)
    xor ebx, ebx              ; Clear ebx (multiplier)

convert_input:
    movzx ecx, byte [esi]    ; Load the next byte (character) from the string
    test ecx, ecx            ; Check if it's the null terminator
    jz done_converting       ; If null terminator, done converting
    sub ecx, '0'             ; Convert ASCII character to number (e.g., '5' -> 5)
    imul eax, eax, 10        ; Multiply current number by 10
    add eax, ecx             ; Add the new digit to eax
    inc esi                  ; Move to the next character in the input string
    jmp convert_input        ; Repeat the loop

done_converting:
    ; Now eax contains the user input as an integer

    ; Calculate the factorial of the input number
    call factorial

    ; Convert the result (eax) to a string
    lea edi, [buffer + 15]    ; Point to the end of the buffer
    mov byte [edi], 0x0A      ; Add a newline character at the end

    ; Call the conversion logic to convert the number in eax to string
    call convert

    ; Print the message "The factorial is: "
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [message]        ; load address of message
    mov edx, 18               ; length of the message string
    int 0x80                  ; Make the syscall to write to stdout

    ; Write the result to the console
    mov eax, 4                ; syscall number for sys_write
    mov ebx, 1                ; file descriptor (1 = stdout)
    lea ecx, [edi]            ; pointer to the string to be printed
    lea edx, [buffer + 16]    ; buffer length (16 bytes)
    sub edx, ecx              ; calculate length by subtracting addresses
    int 0x80                  ; Make the syscall to write to stdout

    ; Exit the program
    mov eax, 1                ; syscall number for sys_exit
    xor ebx, ebx              ; exit status 0
    int 0x80                  ; Make the syscall to exit

; Factorial function using recursion
factorial:
    cmp eax, 1                ; Check if eax is 1 (base case)
    jz end_recursion          ; If eax == 1, jump to the end

    ; Save the current value of eax
    push eax

    ; Decrement eax and call factorial recursively
    dec eax
    call factorial

    ; Multiply the result returned in eax with the saved value of eax
    pop ebx
    imul eax, ebx             ; eax = eax * ebx

    ret

end_recursion:
    mov eax, 1                ; Return 1 when eax is 1 (base case)
    ret

; Conversion of eax to string (ASCII digits)
convert:
    dec edi                   ; Move buffer pointer backwards
    xor edx, edx              ; Clear edx for division
    mov ecx, 10               ; Base 10 for division
convert_loop:
    div ecx                   ; Divide eax by 10, result in eax, remainder in edx
    add dl, '0'               ; Convert remainder to ASCII character
    mov [edi], dl             ; Store ASCII character in buffer
    dec edi                   ; Move buffer pointer backwards
    test eax, eax             ; Check if eax is zero
    jnz convert_loop          ; If eax is not zero, continue converting
    ret
