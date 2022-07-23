INCLUDE irvine32.inc
INCLUDE     GraphWin.inc
INCLUDE    virtualkeys.inc
INCLUDELIB  User32.lib
GetConsoleWindow            PROTO
GetCurrentConsoleFont       PROTO : DWORD, : DWORD, : DWORD
GetConsoleFontSize          PROTO : DWORD, : DWORD
GetClientRect               PROTO : DWORD, : DWORD
ClientToScreen              PROTO : DWORD, : DWORD
GetCursorPos                PROTO : DWORD
PtInRect                    PROTO : DWORD, : POINT


;_________________________________________________

IFNDEF CONSOLE_FONT_INFO
CONSOLE_FONT_INFO STRUCT
nFont             DWORD ?
dwFontSize        COORD <>
;       X                 WORD ?
;       Y                 WORD ?
CONSOLE_FONT_INFO ENDS
ENDIF

GetKeyState PROTO, nVirtKey : DWORD
;_________________________________________________
.data

coordPrevious   COORD <-1, -1>


hwndConsole     DWORD ?
hStdOut         DWORD ?
dwNumberOfBytes DWORD ?
gotoxy_handle dword ?
coordConsole    COORD <>
cursor_position COORD <>

bPrevious       BYTE ?
str_ byte "Start", 0
;***********************************************************************************************


arr BYTE 500 DUP(0)
file BYTE "alarm clock.txt",0
Bytes_Written DWORD ?
handle DWORD ?




;*********************************************************************************
A_hrs BYTE ?
A_mins BYTE ?



msg1 byte "---", 0
msg2 byte "|   |", 0
msg3 byte "*", 0
msg4 byte "|", 0
dot byte ".", 0

hh_t byte 17;location of hours to display
hh_u byte 23
s byte  29
mm_t byte 34
mm_u byte 39
s1 byte 45
ss_t byte 50
ss_u byte 57

x byte 10

min byte 0
hrs byte 0
secs byte 0


Alarm_msg BYTE "SET ALARM ( HH:MM): ", 0
time byte "SET TIME ( HH:MM:SS ): ", 0
proj byte "ALARM CLOCK", 0
undr Byte "-------------", 0
grp Byte "Group Members :", 0
name1 Byte "Hamza Hussain    ( P15-6141 )", 0
name2 Byte "Ali Amjad        ( P15-6121 )", 0
name3 Byte "Moazaam Mushtaq  ( P15-6060 )", 0
MSG Byte "Press 1 : ( TO visit Clock )  ", 0
MSG12 Byte "Press 2: ( To EXIT ) ", 0
MSG33 Byte "Enter Option : ", 0

BUT BYTE "----------------", 0
BUT1 BYTE "* To Set Time  *", 0
BUT2 BYTE "---------------", 0

BUT_ BYTE "----------------", 0
BUT1_ BYTE "* To Exit  *", 0
BUT2_ BYTE "---------------", 0

;BUT3 BYTE "( TO SET TIME )", 0
;BUT4 BYTE "( TO EXIT)", 0





.code
main PROC


		mov eax, YELLOW
		call SetTextColor
		
		mov edx,offset file
		call open_file_Read_mode
		mov handle,eax
		mov edx,offset arr
		mov ecx,lengthof arr
		mov eax,handle
		call Read_from_file
		mov edx, OFFSET arr
		call writestring
		call crlf
		call crlf
		
		mov eax, 2000
		call delay
		call clrscr
				

INVOKE  GetConsoleWindow
mov     hwndConsole, eax
INVOKE  GetStdHandle, STD_OUTPUT_HANDLE
mov     hStdOut, eax


	;______________________________________________________________
	pushad



	;mov dh, 2
	;mov dl, 30
	;call gotoxy

	;mov edx, offset proj
	;call writestring

	;mov dh, 3
	;mov dl, 30
	;call gotoxy

	;mov edx, offset undr
	;call writestring

	mov dh, 4
		mov dl, 1
		call gotoxy
	
		mov edx, offset grp
		call writestring
	
		mov dh, 8
		mov dl, 15
		call gotoxy
	
		mov edx, offset name1
		call writestring
	
		mov dh, 10
		mov dl, 15
		call gotoxy
	
		mov edx, offset name2
		call writestring
	
		mov dh, 12
		mov dl, 15
		call gotoxy
	
		mov edx, offset name3
		call writestring
	


	; BUTTONS


	xor eax, eax
	La :
	mov eax, RED
	call SetTextColor
	
	mov dh, 15
	mov dl, 25
	call gotoxy
	
	mov edx, offset BUT
	call writestring



	mov dh, 16
	mov dl, 25
	call gotoxy


	mov edx, offset BUT1
	call writestring

	mov dh, 16
	mov dl, 50
	call gotoxy

	;mov edx, offset BUT3
	;call writestring

	mov dh, 17
	mov dl, 25
	call gotoxy


	mov edx, offset BUT2
	call writestring


	mov dh, 19
	mov dl, 25
	call gotoxy

	mov edx, offset BUT_
	call writestring



	mov dh, 20
	mov dl, 25
	call gotoxy


	mov edx, offset BUT1_
	call writestring

	mov dh, 20
	mov dl, 50
	call gotoxy

	;mov edx, offset BUT2_
	;call writestring

	mov dh, 21
	mov dl, 25
	call gotoxy


	mov edx, offset BUT2_
	call writestring

		INVOKE  GetKeyState, VK_LBUTTON;check if key is pressed
		test ax, 8080h;AX bit 15 = 1 if right - click
		jnz L2a; if left button is click the zero flag is clear
		jmp La

		L2a :
	call updatemouseposition
		.if edx==16||edx==17
		jmp start
		.endif
		.if edx==20
		call clrscr
		exit
		.endif
		jmp La
	;--------------------------------------


	start :
	call clrscr
mov edx, offset time
call writestring
call crlf

call readint
call crlf
mov hrs, al

call readint
call crlf
mov min, al

call readint
call crlf
mov secs, al
call clrscr

XOR edx, edx
mov edx, offset Alarm_msg
call writestring

call crlf
call readint
call crlf
mov A_hrs, al

call crlf
call readint
call crlf
mov A_mins, al

mov ecx, 100

l1:

pushad
call hours
call mints
call seconds
call check
popad

Loop L1



e :

popad
exit
main ENDP

;_________________________________________
hours proc

.if hrs>23

pushad
xor ax, ax
mov al, hrs
mov hrs, 24
div hrs
mov hrs, ah
popad
.endif
pushad
xor eax, eax
mov al, hrs
div x
mov bl, al

;------------------------------------------ -
.if bl == 1
pushad
mov al, hh_t
call one
popad


.endif
;------------------------------------------ -
.if bl == 0
pushad
mov al, hh_t
call zero
popad
.endif
;---------------------------------------- -
.if bl == 2
pushad
mov al, hh_t
call two
popad
.endif
;-------------------------------------------- -
mov bl, ah
;-------- -
.if bl == 0
pushad
mov al, hh_u
call zero
popad
.endif
;-------- -
.if bl == 1
pushad
mov al, hh_u
call one
popad
.endif
;-------- -
.if bl == 2
pushad
mov al, hh_u
call two
popad
.endif
;-------- -
.if bl == 3
pushad
mov al, hh_u
call three
popad
.endif
;-------- -
.if bl == 4
pushad
mov al, hh_u
call four
popad
.endif
;-------- -
.if bl == 5
pushad
mov al, hh_u
call five
popad
.endif
;-------- -
.if bl == 6
pushad
mov al, hh_u
call six
popad
.endif
;-------- -
.if bl == 7
pushad
mov al, hh_u
call seven
popad
.endif
;-------- -
.if bl == 8
pushad
mov al, hh_u
call eight
popad
.endif
;-------- -
.if bl == 9
pushad
mov al, hh_u
call nine
popad
.endif
;-------- -
mov al, s
call sec
;-------- -
popad
ret
hours endp
;________________________________________
mints proc

.if min>59
pushad
xor ax, ax
mov al, min
mov min, 60
div min
mov min, ah
movzx cx, al
l1 :
inc hrs
loop l1
popad
.endif
pushad
xor ax, ax
mov al, min
div x
mov bl, ah
;-------- -
.if bl == 0
pushad
mov al, mm_u
call zero
popad
.endif
;-------- -
.if bl == 1
pushad
mov al, mm_u
call one
popad
.endif
;-------- -
.if bl == 2
pushad
mov al, mm_u
call two
popad
.endif
;-------- -
.if bl == 3
pushad
mov al, mm_u
call three
popad
.endif
;-------- -
.if bl == 4
pushad
mov al, mm_u
call four
popad
.endif
;-------- -
.if bl == 5
pushad
mov al, mm_u
call five
popad
.endif
;-------- -
.if bl == 6
pushad
mov al, mm_u
call six
popad
.endif
;-------- -
.if bl == 7
pushad
mov al, mm_u
call seven
popad
.endif
;-------- -
.if bl == 8
pushad
mov al, mm_u
call eight
popad
.endif
;-------- -
.if bl == 9
pushad
mov al, mm_u
call nine
popad
.endif
;-------- -
mov bl, al
;-------- -
.if bl == 1
pushad
mov al, mm_t
call one
popad
.endif
;-------- -
.if bl == 0
pushad
mov al, mm_t
call zero
popad
.endif
;--------
.if bl == 2
pushad
mov al, mm_t
call two
popad
.endif
;-------- -
.if bl == 3
pushad
mov al, mm_t
call three
popad
.endif
;-------- -
.if bl == 4
pushad
mov al, mm_t
call four
popad
.endif
;-------- -
.if bl == 5
pushad
mov al, mm_t
call five
popad
.endif
;-------- -
mov al, s1
call sec
;call last_print
popad
ret
mints endp
;__________________________________
seconds proc
pushad
.if secs>59
pushad
xor ax, ax
mov al, secs
mov secs, 60
div secs
mov secs, ah
movzx cx, al
l1 :
inc min
loop l1
popad
.endif
xor ax, ax
mov al, secs
div x
;--------
mov bl, al
;--------
.if bl == 0
pushad
mov al, ss_t
call zero
popad
.endif
;--------
.if bl == 1
pushad
mov al, ss_t
call one
popad
.endif
;--------
.if bl == 2
pushad
mov al, ss_t
call two
popad
.endif
;--------
.if bl == 3
pushad
mov al, ss_t
call three
popad
.endif
;--------
.if bl == 4
pushad
mov al, ss_t
call four
popad
.endif
;--------
.if bl == 5
pushad
mov al, ss_t
call five
popad
.endif
;--------
mov bl, ah
;--------
.if bl == 0
pushad
mov al, ss_u
call zero
popad
.endif
;--------
.if bl == 1
pushad
mov al, ss_u
call one
popad
.endif
;--------
.if bl == 2
pushad
mov al, ss_u
call two
popad
.endif
;--------
.if bl == 3
pushad
mov al, ss_u
call three
popad
.endif
;--------
.if bl == 4
pushad
mov al, ss_u
call four
popad
.endif
;--------
.if bl == 5
pushad
mov al, ss_u
call five
popad
.endif
;--------
.if bl == 6
pushad
mov al, ss_u
call six
popad
.endif
;--------
.if bl == 7
pushad
mov al, ss_u
call seven
popad
.endif
;--------
.if bl == 8
pushad
mov al, ss_u
call eight
popad
.endif
;--------
.if bl == 9
pushad
mov al, ss_u
call nine
popad
.endif
;--------

.if secs<60
	inc secs
	mov eax, 1000
	call delay
	call clrscr
	.endif

	.if secs>59
	mov secs, 0
	inc min
	.endif

	.if min>59
	mov min, 0
	inc hrs
	.if hrs>23
	mov hrs, 0
	.endif

	.endif



	popad
	ret
	seconds endp
	;________________________________________
	zero proc

	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring
	

	sub al, 1
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg2
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg2
	call writestring

	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg2
	call writestring

	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg2
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg2
	call writestring

	add al, 1
	mov dl, al
	mov dh, 9
	call gotoxy

	mov edx, offset msg1
	call writestring
	ret
	zero endp
	;___________________________________
	one proc
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring
	ret
	one endp
	;___________________________________
	two proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	sub al, 1
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	inc al
	mov dl, al
	mov dh, 9
	call gotoxy

	mov edx, offset msg1
	call writestring
	ret
	two endp
	;___________________________________
	three proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 9
	call gotoxy

	mov edx, offset msg1
	call writestring
	ret
	three endp
	;___________________________________
	four proc
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	inc al
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring
	ret
	four endp
	;___________________________________
	five proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	dec al
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	inc al
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 9
	call gotoxy

	mov edx, offset msg1
	call writestring
	ret
	five endp
	;___________________________________
	six proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	dec al
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg4
	call writestring

	inc al
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	dec al
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	add al, 4
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 9
	call gotoxy

	mov edx, offset msg1
	call writestring

	ret
	six endp
	;__________________________________
	seven proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	ret
	seven endp
	;___________________________________
	eight proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	dec al
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	add al, 4
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	dec al
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	add al, 4
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	sub al, 3
	mov dl, al
	mov dh, 9
	call gotoxy

	mov edx, offset msg1
	call writestring

	ret
	eight endp
	;___________________________________
	nine proc
	mov dl, al
	mov dh, 3
	call gotoxy

	mov edx, offset msg1
	call writestring

	dec al
	mov dl, al
	mov dh, 4
	call gotoxy

	mov edx, offset msg2
	call writestring
	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg2
	call writestring

	inc al
	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg1
	call writestring

	add al, 3
	mov dl, al
	mov dh, 7
	call gotoxy

	mov edx, offset msg4
	call writestring

	mov dl, al
	mov dh, 8
	call gotoxy

	mov edx, offset msg4
	call writestring

	ret
	nine endp
	;___________________________________
	sec proc
	mov dl, al
	mov dh, 5
	call gotoxy

	mov edx, offset msg3
	call writestring

	mov dl, al
	mov dh, 6
	call gotoxy

	mov edx, offset msg3
	call writestring
	ret
	sec endp
	;___________________________________

	;_______________________________________


	;________________________________________

	CHECK PROC
	pushad

	mov al, A_hrs
	cmp al, hrs
	JE A
	JMP next
	A :
mov bl, A_mins
cmp bl, min
JE BEEP
JMP next

BEEP :

mov ecx, 10

L1 :
	mov al, 7h     ;for beep
	call writechar

	Loop L1

	next :
popad
ret
CHECK ENDP

;________________________________________
UpdateMousePosition PROC

;if the mouse cursor is inside the console window client area :
;updates the coordConsole structure with the current character position of mouse cursor
;returns coordConsole.X in ECX
;returns coordConsole.Y in EDX
;returns TRUE(1) in EAX
;
;if the mouse cursor is outside the console window client area :
;leaves the coordConsole structure members unmodified
;returns FALSE(0) in EAX
;
;hwndConsole and hStdOut must be initialized prior to call

;---------------------------------- -

LOCAL   _rcClient : RECT
LOCAL   _ptCursor : POINT
LOCAL   _cfi : CONSOLE_FONT_INFO
LOCAL   _csbi : CONSOLE_SCREEN_BUFFER_INFO

;---------------------------------- -

INVOKE  GetClientRect, hwndConsole, addr _rcClient
INVOKE  ClientToScreen, hwndConsole, addr _rcClient.left
mov     ecx, _rcClient.left
mov     edx, _rcClient.top
add     _rcClient.right, ecx
add     _rcClient.bottom, edx
INVOKE  GetCursorPos, addr _ptCursor
INVOKE  PtInRect, addr _rcClient, _ptCursor
or eax, eax
jz      UPexit
;########################################
INVOKE  GetConsoleScreenBufferInfo, hStdOut, addr _csbi
INVOKE  GetCurrentConsoleFont, hStdOut, 0, addr _cfi
INVOKE  GetConsoleFontSize, hStdOut, _cfi.nFont
xchg    eax, ecx
xor     edx, edx
mov dword ptr _cfi.dwFontSize, ecx
mov     eax, _ptCursor.x
and     ecx, 0FFFFh
sub     eax, _rcClient.left
div     ecx
push    eax
movzx   ecx, word ptr _cfi.dwFontSize.Y
mov     eax, _ptCursor.y
xor     edx, edx
sub     eax, _rcClient.top
div     ecx
pop     ecx
xchg    eax, edx
add     cx, _csbi.srWindow.Left
add     dx, _csbi.srWindow.Top
mov     eax, TRUE
mov     coordConsole.X, cx
mov     coordConsole.Y, dx

UPexit : ret

	UpdateMousePosition ENDP
	
	
	
	
	
	
open_file_Read_mode proc


	INVOKE CREATEFILE, edx, GENERIC_read, NULL, NULL, open_existing, FILE_ATTRIBUTE_NORMAL, 0

	ret

open_file_Read_mode endp



Read_from_file proc

	INVOKE READFILE,eax,edx,ecx,Addr Bytes_Written,0


	ret

Read_from_file endp
		
	END main
