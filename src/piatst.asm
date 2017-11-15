format MZ

entry main:start
stack 320h

segment main
start:
mov ax,ddat
mov ds,ax

CALL summon:output_game

xor ax,ax
xor bx,bx
xor cx,cx
xor dx,dx
nxt:
push dx


CALL summon:light
push dx
CALL summon:checking
CALL summon:scan_key

pop dx

cmp	ah, 32
jz  right


cmp	ah, 30
jz  left


cmp	ah, 17
jz  up



cmp	ah, 31
jz  down

cmp	ah, 57
jz  select


cmp	ah, 1
jz  exit

ex:
pop dx
jmp nxt

right:
cmp dl,36
jnl ex
pop dx
push dx
CALL summon:unlight
pop dx
add dl,12
push dx
CALL summon:light
pop dx
jmp nxt


down:
cmp dh,24
jnl ex
pop dx
push dx
CALL summon:unlight
pop dx
add dh,6
push dx
CALL summon:light
pop dx
jmp nxt

left:
cmp dl,0
jng ex
pop dx
push dx
CALL summon:unlight
pop dx
sub dl,12
push dx
CALL summon:light
pop dx
jmp nxt

up:
cmp dh,7
jng ex
pop dx
push dx
CALL summon:unlight
pop dx
sub dh,6
push dx
CALL summon:light
pop dx
jmp nxt

select:
inc [counter]
cmp [counter],128
jge loser
pop dx

push dx
CALL summon:look_for_border
pop dx

push dx
cmp [direction],4
je right

cmp [direction],3
je left


cmp [direction],2
je up


cmp [direction],1
je down

pop cx
jmp nxt

loser:

mov dl,50
mov dh,9
CALL summon:curs_to
mov dx,msg_esc
mov ah,09h
int 21h

mov dl,50
mov dh,15
CALL summon:curs_to
mov dx,msg_los
mov ah,09h
int 21h

lmn:
CALL summon:scan_key
cmp ah,1
jnz lmn
CALL summon:clear_scr
mov ax,4C00h
int 21h

exit:
CALL summon:clear_scr
mov ax,4C00h
int 21h


segment ddat

upper_line db 201
db 11 dup 205
db 203
db 11 dup 205
db 203
db 11 dup 205
db 203
db 11 dup 205
db 187
db 10,13
db '$'

middle_line db 186
db 11 dup 32
db 186
db 11 dup 32
db 186
db 11 dup 32
db 186
db 11 dup 32
db 186
db 10,13
db '$'

cross_line db 204
db 11 dup 205
db 206
db 11 dup 205
db 206
db 11 dup 205
db 206
db 11 dup 205
db 185
db 10,13
db '$'

lower_line db 200
db 11 dup 205
db 202
db 11 dup 205
db 202
db 11 dup 205
db 202
db 11 dup 205
db 188
db '$'

smb db ?
direction db 0

soll db '1','2','3','4','5','6','7','8','9','A','B','C','D','E','F','#'

msg_win db 'YOU WIN, HURRAY =)$'
msg_los db 'LOOSER :P$'
msg_esc db 'Press Esc to exit$'
msg_was db ' steps were made$'
counter dw 0


segment summon

output_game:
mov dx,upper_line
mov ah,09h
int 21h
mov cx,5
mid1:
mov dx,middle_line
mov ah,09h
int 21h
loop mid1
mov dx,cross_line
mov ah,09h
int 21h
mov cx,5
mid2:
mov dx,middle_line
mov ah,09h
int 21h
loop mid2
mov dx,cross_line
mov ah,09h
int 21h
mov cx,5
mid3:
mov dx,middle_line
mov ah,09h
int 21h
loop mid3
mov dx,cross_line
mov ah,09h
int 21h
mov cx,5
mid4:
mov dx,middle_line
mov ah,09h
int 21h
loop mid4
mov dx,lower_line
mov ah,09h
int 21h
mov dh,3
mov dl,6
CALL summon:curs_to
mov al,'A'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'9'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'3'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'D'
CALL summon:sym_unattrib


mov dh,9
mov dl,6
CALL summon:curs_to
mov al,'2'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'6'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'B'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'4'
CALL summon:sym_unattrib


mov dh,15
mov dl,6
CALL summon:curs_to
mov al,'7'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'5'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'C'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'8'
CALL summon:sym_unattrib


mov dh,21
mov dl,6
CALL summon:curs_to
mov al,'1'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'E'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'#'
CALL summon:sym_unattrib
add dl,12
CALL summon:curs_to
mov al,'F'
CALL summon:sym_unattrib
retf

clear_scr: ;
	mov ax, 0600h
	mov bh, 07h
	mov cx, 0000h
	mov dx, 184fh
	int 10h
	retf

curs_to:
mov ah,02h
int 10h
retf

read_sym:
mov ah,08h
int 10h
retf

scan_key:
xor ah, ah
int	16h
retf

sym_attrib:
mov ah,09h
mov bl,188
mov cx,1
int 10h
retf

sym_unattrib:
mov ah,09h
mov bl,7
mov cx,1
int 10h
retf

light:
mov cx,7
lins:
push cx
push dx
CALL summon:curs_to
CALL summon:read_sym
CALL summon:sym_attrib
mov cx,12
lin:
push cx
add dl,1
push dx
CALL summon:curs_to
CALL summon:read_sym
CALL summon:sym_attrib
pop dx
pop cx
loop lin
pop dx
add dh,1
pop cx
loop lins
retf

unlight:
mov cx,7
linso:
push cx
push dx
CALL summon:curs_to
CALL summon:read_sym
CALL summon:sym_unattrib
mov cx,12
lino:
push cx
add dl,1
push dx
CALL summon:curs_to
CALL summon:read_sym
CALL summon:sym_unattrib
pop dx
pop cx
loop lino
pop dx
add dh,1
pop cx
loop linso
retf

look_for_border:
push dx
add dl,6
add dh,3
push dx
CALL summon:curs_to
CALL summon:read_sym
mov [smb],al
pop dx
push dx

add dl,12
CALL summon:curs_to
CALL summon:read_sym
cmp al,'#'
jne nm_1
mov [direction],4
mov al,[smb]
CALL summon:curs_to
CALL summon:sym_unattrib
pop dx

CALL summon:curs_to
mov al,'#'
CALL summon:sym_unattrib
pop dx
retf

nm_1:
pop dx
push dx
sub dl,12
CALL summon:curs_to
CALL summon:read_sym
cmp al,'#'
jne nm_2
mov [direction],3
mov al,[smb]
CALL summon:curs_to
CALL summon:sym_unattrib
pop dx

CALL summon:curs_to
mov al,'#'
CALL summon:sym_unattrib
pop dx
retf

nm_2:
pop dx
push dx
sub dh,6
CALL summon:curs_to
CALL summon:read_sym
cmp al,'#'
jne nm_3
mov [direction],2
mov al,[smb]
CALL summon:curs_to
CALL summon:sym_unattrib
pop dx

CALL summon:curs_to
mov al,'#'
CALL summon:sym_unattrib
pop dx
retf

nm_3:
pop dx
push dx
add dh,6
CALL summon:curs_to
CALL summon:read_sym
cmp al,'#'
jne nm_4
mov [direction],1
mov al,[smb]
CALL summon:curs_to
CALL summon:sym_unattrib
pop dx

CALL summon:curs_to
mov al,'#'
CALL summon:sym_unattrib
pop dx
retf

nm_4:
mov [direction],0
pop dx

pop dx
retf

checking:
push dx
xor bx,bx
mov dl,6
mov dh,3

mov cx,4

v1:
push cx
mov cx,4

v2:
push cx
push bx
xor bx,bx
CALL summon:curs_to
CALL summon:read_sym
pop bx
cmp al,[soll+bx]
jne f_ck_of
inc bx
add dl,12
pop cx
loop v2

mov dl,6
add dh,6
pop cx
loop v1

mov dl,50
mov dh,3
CALL summon:curs_to
mov dx,msg_win
mov ah,09h
int 21h

mov dl,50
mov dh,9
CALL summon:curs_to
mov dx,msg_esc
mov ah,09h
int 21h

mov dl,50
mov dh,15
CALL summon:curs_to
mov ax,[counter]
CALL summon:deconvert
mov dx,msg_was
mov ah,09h
int 21h
lmnz:
CALL summon:scan_key
cmp ah,1
jnz lmnz
CALL summon:clear_scr
mov ax,4C00h
int 21h

retf


f_ck_of:
pop cx
pop cx
xor cx,cx
xor bx,bx
pop dx
retf

deconvert:
push ax
push bx
push cx
push dx
or al, al
jns pl
push ax
mov ah, 2
mov dl, '-'
int 21h
pop ax 
neg al 
pl:
xor cx, cx
mov bl, 10
next:
xor ah, ah
div bl
push ax
inc cx
or al, al
jnz next

nextviv:
pop ax
xchg ah, al 
add al, '0' 
int 29h
LOOP nextviv

pop dx
pop cx
pop bx
pop ax 
retf
