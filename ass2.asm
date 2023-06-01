section .data
msg db 10,10,"Enter the string : "
msg_len equ $-msg
smsg db 10,10,"The length of string is: "
smsg_len equ $-smsg
section .bss
string resb 50
stringl equ $-string
count resb 1
char_ans resb 2
%macro Print 2
mov rax,1
mov rdi,1
mov rsi,%1
mov rdx,%2
syscall
%endmacro
%macro Read 2
mov rax,0
mov rdi,0
mov rsi,%1
mov rdx,%2
syscall
%endmacro
%macro Exit 0
mov rax,60
mov rdi,0
syscall;
%endmacro
section .text
global _start
_start:
Print msg,msg_len
Read string,stringl
mov [count], rax
Print smsg, smsg_len
mov rax, [count]
dec rax ;to decrease size
call Display
Exit
Display:
mov rbx,16
mov rcx,2
mov rsi,char_ans+1
back:
mov rdx,0
div rbx ;rax/rbx
cmp dl,09h
jbe add30
add dl,07h
add30:
add dl,30h
mov [rsi],dl
dec rsi
dec rcx
jnz back
Print char_ans,2
ret