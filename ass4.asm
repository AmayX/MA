section .data
nline        db     10,10
nline_len    equ    $-nline

ano          db     10,"                        Assignment no  :4",
            db     10,"--------------------------------------------------------------------------------------",
            db     10,"            Assignment name: Conversion from HEX to BCD and BCD TO HEX",10
ano_len      equ    $-ano

menu         db     10,"1.Hex to BCD.",
    db     10,"2.BCD to HEX",
    db     10,"3.Exit."      
    db     10,"Enter your choice:"
menu_len     equ    $-menu

hmsg     db     10,"Enter 4 digit hex number:"
hmsg_len     equ    $-hmsg      

bmsg     db     10,"Enter 4 digit bcd number:"
bmsg_len     equ    $-bmsg

ebmsg        db     10,"The equivalent BCD number is:"
ebmsg_len    equ    $-ebmsg

ehmsg        db     10,"The equivalent HEX number is:"
ehmsg_len        equ    $-ehmsg


emsg         db     10,"INVALID NUMBER INPUT",10
emsg_len     equ    $-emsg


section .bss
buf          resb    6
char_ans     resb    4
ans          resw    1



%macro  print   2
MOV     RAX,1
MOV RDI,1
MOV RSI,%1
MOV     RDX,%2
     syscall
%endmacro


%macro   read   2
        MOV     RAX,0
        MOV     RDI,0
        MOV     RSI,%1
        MOV     RDX,%2
      syscall
%endmacro


%macro   exit   0
print  nline,nline_len
MOV    rax,60
MOV    RDI,0
      syscall
%endmacro        


section  .text
     global _start
_start:
        print ano,ano_len
       
MENU:
print    menu,menu_len
read     buf,2

MOV     al,[buf]

c1:     cmp      al,'1'
jne      c2
 call     HEX_BCD
jmp      MENU

c2:     cmp      al,'2'
jne c3
call     BCD_HEX
jmp      MENU

c3:     cmp      al,'3'
jne      invalid
exit

invalid:
print    emsg,emsg_len
jmp     MENU


BCD_HEX:
print    bmsg,bmsg_len
read     buf,6

MOV      rsi,buf
xor      ax,ax
MOV     rbp,5
MOV     rbx,10

next:   
xor      cx,cx 
mul      bx
MOV      cl,[rsi]
sub      cl,30h
add      ax,cx


inc      rsi
dec      rbp
jnz      next

mov      [ans],ax
print    ehmsg,ehmsg_len

MOV      ax,[ans]
call     disp_16

ret

HEX_BCD:
print hmsg,hmsg_len
call Accept_16 
mov ax,bx 

mov bx,10 
xor bp,bp 

back: xor dx,dx 
div bx 
push dx 
inc bp 

cmp ax,0 
jne back 

print ebmsg,ebmsg_len

back1: pop dx 
add dl,30h 
mov [char_ans],dl 
print char_ans,1

dec bp    
jnz back1 

ret

Accept_16: 
read buf,5    

MOV RCX,4     
MOV RSI,buf   
XOR BX,BX     

next_byte:
SHL BX,4      
MOV AL,[RSI]  

CMP AL,'0'    
JB error     
CMP AL,'9'    
JBE sub30     

CMP AL,'A'    
JB error
CMP AL,'F'
JBE sub37     

CMP AL,'a'    
JB error
CMP AL,'f'
JBE sub57     

error:
print emsg,emsg_len
exit

sub57: SUB AL,20H    
sub37: SUB AL,07H
sub30: SUB AL,30H

ADD BX,AX     

INC RSI       
DEC RCX       
JNZ next_byte 

RET

disp_16:

MOV      RSI,char_ans+3
MOV      RCX,4
MOV      RBX,16

next_digit:
xor      rdx,rdx
div      rbx

cmp      dl,9
jbe      add30
ADD      dl,07H  

add30:
ADD      dl,30h
MOV      [rsi],dl


dec      rsi
dec      rcx
jnz      next_digit



print    char_ans,4
ret  
