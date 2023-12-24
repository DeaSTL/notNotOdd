section .data
    msg_even db "even", 0xA, 0
    len_even equ $ - msg_even

    msg_odd db "odd", 0xA, 0
    len_odd equ $ - msg_odd

section .bss
    number resb 10

section .text
    global _start

_start:
    ; Copy the first argument into 'number'
    mov edx, [esp+8]   ; pointer to the first argument
    mov [number], edx

    ; Convert string to integer
    mov esi, number
    xor eax, eax       ; clear eax for use

convert_loop:
    movzx ecx, byte [esi] ; load the next byte of the number string
    test  ecx, ecx        ; test if it's the end of the string (null character)
    jz    check_odd_even  ; if it's the end, jump to check
    sub   ecx, '0'        ; convert from ASCII to integer
    imul  eax, eax, 10    ; multiply current result by 10 (shift left by one decimal place)
    add   eax, ecx        ; add the new digit to the result
    inc   esi             ; move to the next character in the string
    jmp   convert_loop

check_odd_even:
    test eax, 1       ; Test if the least significant bit is set (odd if set)
    jnz  is_odd
    ; if even
    mov edx, len_even
    mov ecx, msg_even
    jmp print_message

is_odd:
    ; if odd
    mov edx, len_odd
    mov ecx, msg_odd

print_message:
    mov ebx, 1        ; file descriptor (stdout)
    mov eax, 4        ; syscall number for sys_write
    int 0x80          ; call kernel

    ; Exit the program
    mov eax, 1        ; syscall number for sys_exit
    xor ebx, ebx      ; return 0 status
    int 0x80          ; call kernel


