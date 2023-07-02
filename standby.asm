;standby via APMv1.0 interface.
;nasm -f bin -o standby.com standby.asm
BITS 16
ORG 100h

section .data
msgAPMError db "Undefined APM error or APM not available", "$",0

;Interface & General Errors
msgAPMError01 db "Power Management functionality disabled", "$",0
msgAPMError02 db "Real Mode interface connection already established", "$",0
msgAPMError03 db "Interface not connected", "$",0
msgAPMError04 db "Real-mode interface not connected", "$",0
msgAPMError05 db "16-bit protected mode interface already established", "$",0
msgAPMError06 db "16-bit protected-mode interface not supported", "$",0
msgAPMError07 db "32-bit protected-mode interface already connected", "$",0
msgAPMError08 db "32-bit protected-mode interface not supported", "$",0
msgAPMError09 db "Unrecognized Device ID", "$",0
msgAPMError0A db "Parameter value out of range", "$",0
msgAPMError0B db "(APM v1.1) Interface not engaged", "$",0
msgAPMError0C db "(APM v1.2) Function not supported ", "$",0
msgAPMError0D db "(APM v1.2) Resume Timer disabled", "$",0

;System Errors
msgAPMError60 db "Unable to enter requested state", "$",0

;Power Management Event Errors
msgAPMError80 db "No power management events pending", "$",0
msgAPMError86 db "APM not present", "$",0


SECTION .text
        global _start
	   
_start:  
        cli         ; Disable interrupts before making APM calls
        ;check  if APM is ok
        mov ax, 5300h 
        xor bx, bx 
        int 15h 
        jc APM_error

        ;connect to APM API
        mov     ax, 5301h
        xor     bx, bx
        int     15h

        ;turn off the system
        mov     ax, 5307h
        mov     bx, 0001h
        mov     cx, 0001h
        int     15h
		jc APM_error
		
		; If successful, terminate the program
		jmp terminate
        hlt

APM_error: cmp  ah, 1
		   mov  dx, msgAPMError01
		   je printErr
		   cmp  ah, 2
		   mov  dx, msgAPMError02
		   je printErr
		   cmp  ah, 3
		   mov  dx, msgAPMError03
		   je printErr
		   cmp  ah, 4
		   mov  dx, msgAPMError04
		   je printErr
		   cmp  ah, 5
		   mov  dx, msgAPMError05
		   je printErr
		   cmp  ah, 6
		   mov  dx, msgAPMError06
		   je printErr
		   cmp  ah, 7
		   mov  dx, msgAPMError07
		   je printErr
		   cmp  ah, 8
		   mov  dx, msgAPMError08
		   je printErr
		   cmp  ah, 9
		   mov  dx, msgAPMError09
		   je printErr
		   cmp  ah, 0Ah
		   mov  dx, msgAPMError0A
		   je printErr
		   cmp  ah, 0Bh
		   mov  dx, msgAPMError0B
		   je printErr
		   cmp  ah, 0Ch
		   mov  dx, msgAPMError0C
		   je printErr
		   cmp  ah, 0Dh
		   mov  dx, msgAPMError0D
		   je printErr
		   cmp  ah, 60h
		   mov  dx, msgAPMError60
		   je printErr
		   cmp  ah, 80h
		   mov  dx, msgAPMError80
		   je printErr
		   cmp  ah, 86h
		   mov  dx, msgAPMError86
		   je printErr

           ; If the error code doesn't match any specific case, display a generic error message
           mov  dx, msgAPMError
printErr:  mov  ah, 9
           int  21h

exitError: mov  ax, 4CFFh
           int  21h
		   
terminate:
           mov  ah, 0
           int 20h 
		   

TIMES 510-($-$$) DB 0
DW 0xAA55
.end