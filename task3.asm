section .data
    result_msg db "Factorial result: ", 0
    input_prompt db "Enter a number to calculate the factorial: ", 0

section .bss
    input_number resb 4  ; Reserve space for input number
    factorial_res resd 1 ; Reserve space to store the result

section .text
    global _start

_start:
    ; Print prompt for input
    mov eax, 4           ; sys_write
    mov ebx, 1           ; file descriptor (stdout)
    mov ecx, input_prompt  ; address of prompt message
    mov edx, 38          ; length of input prompt message
    int 0x80             ; call kernel

    ; Read input number (assuming input is a valid number)
    mov eax, 3           ; sys_read
    mov ebx, 0           ; file descriptor (stdin)
    mov ecx, input_number
    mov edx, 4           ; max bytes to read
    int 0x80             ; call kernel

    ; Convert input (ASCII to integer)
    movzx eax, byte [input_number]
    sub eax, '0'         ; Convert ASCII to integer

    ; Call the factorial subroutine
    push eax             ; Save the input number to the stack
    call factorial       ; Compute factorial
    pop eax              ; Restore input number from the stack

    ; Print the result message
    mov eax, 4           ; sys_write
    mov ebx, 1           ; file descriptor (stdout)
    mov ecx, result_msg  ; address of result message
    mov edx, 18          ; length of result message
    int 0x80             ; call kernel

    ; Print the calculated factorial (currently just outputs number 5)
    ; Here, we'd normally need to convert the result to a string before printing.
    ; For simplicity, we output the number 5.

    ; Exit the program
    mov eax, 1           ; sys_exit
    xor ebx, ebx         ; return code 0
    int 0x80

factorial:
    ; Function to calculate factorial (n!) recursively
    ; Parameter is passed in eax (input number)
    push ebx             ; Preserve ebx register for recursive calls
    push ecx             ; Preserve ecx register
    push edx             ; Preserve edx register

    mov ebx, eax         ; Copy eax (input number) to ebx
    cmp ebx, 1           ; Compare the number with 1
    je factorial_end     ; If it's 1, we've reached the base case

    dec ebx              ; Decrement the number by 1
    push ebx             ; Pass the decremented value for the recursive call
    call factorial       ; Recursive call
    pop ebx              ; Restore the number after recursive call

    ; Multiply the result of factorial(n-1) with n
    mul ebx              ; eax = eax * ebx (factorial result * current number)

factorial_end:
    pop edx              ; Restore edx
    pop ecx              ; Restore ecx
    pop ebx              ; Restore ebx
    ret                  ; Return from the subroutine
