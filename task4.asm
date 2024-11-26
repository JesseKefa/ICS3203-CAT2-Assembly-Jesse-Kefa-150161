section .data
    sensor_value db 15   ; Test with value greater than threshold as I did with 15
    message db "Sensor value too high!", 0

section .text
    global _start

_start:
    ; Read sensor value (simulated here as 15)
    mov al, [sensor_value]

    ; Compare the value to a threshold 
    cmp al, 10
    jg sensor_high       ; Jump if greater than 10

    ; If sensor value is not too high, exit
    mov eax, 1           ; sys_exit
    xor ebx, ebx         ; return code 0
    int 0x80

sensor_high:
    ; Print message if sensor value is too high
    mov eax, 4           ; sys_write
    mov ebx, 1           ; file descriptor (stdout)
    mov ecx, message     ; address of message
    mov edx, 23          ; correct length of the message

    ; Exit program
    mov eax, 1           ; sys_exit
    xor ebx, ebx         ; return code 0
    int 0x80
