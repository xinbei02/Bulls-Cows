INCLUDE Irvine32.inc

; 502
print PROTO, pAttribute:PTR WORD, pBuffer:PTR BYTE, nLength:DWORD, xyCoord:COORD
wordPrint PROTO, ATTR:PTR WORD, wordH:DWORD, wordW:DWORD, XY:COORD, wordAr:PTR BYTE
cmpNum PROTO, num:BYTE, ansORplay:BYTE, XY:COORD
getA PROTO,	num:BYTE, pos:BYTE
minusLife PROTO, num:BYTE
playPrint PROTO, playWordAr:PTR BYTE, abAr:PTR BYTE
inputPrint PROTO
; 504
FIND PROTO, inp:PTR BYTE, num:PTR BYTE, ans111:PTR BYTE, tool:BYTE
OUTPRINT PROTO, ab:PTR BYTE

main EQU start@0

; 503
BUFFER_SIZE=5000
; 502
ans = 1
play = 0

gameB = 2
gameW = 50

lifeNum = 5
lifeH = 5
lifeW = 8
lifeOut = 1
lifeIn = 2

questionH = 11

ansW = 7
ansH = 9
ansB = 1
ansOut = 3
ansIn = 4
ansNum = 4

ansWordW = 5
ansWordH = 7

playH = 32
playOut = 2
playIn = 1

playNumWordW = 4
playNumWordH = 5
; 504
BufSize=6

.data

; 503
xyPos COORD <,>
xyInit COORD <18,27>
xyBound COORD <42,27> 

buffer byte BUFFER_SIZE dup(?)
buffer3 byte BUFFER_SIZE dup(?)
filename byte "finalNote.txt",0
filename2 byte "rule.txt",0
fileHandle HANDLE ?
fileHandle4 HANDLE ?

; 502
outputHandle DWORD ?
cellsWritten DWORD ?

gameXY COORD <5,1>
lifeXY COORD <5,1>
ansXY COORD <?,?>
playXY COORD <?,?>
inputXY COORD <0,0>

wallUD BYTE gameW DUP(' ')
wallLR BYTE gameB DUP(' ')
ansUD BYTE ansW DUP(' ')
ansLR BYTE ansB DUP(' ')
output BYTE ' '
ansWord BYTE "Guess the four numbers"
playWord BYTE "Your guess..."

life BYTE 0,1,1,0,0,1,1,0, 1,1,1,1,1,1,1,1,  0,1,1,1,1,1,1,0, 0,0,1,1,1,1,0,0, 0,0,0,1,1,0,0,0

ansM BYTE 0,1,1,1,0, 1,0,0,0,1, 0,0,0,0,1, 0,0,1,1,0, 0,0,1,0,0, 0,0,0,0,0, 0,0,1,0,0
ans0 BYTE 0,1,1,1,0, 1,0,0,0,1, 1,0,0,0,1, 1,0,0,0,1, 1,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0
ans1 BYTE 0,0,1,0,0, 0,1,1,0,0, 0,0,1,0,0, 0,0,1,0,0, 0,0,1,0,0, 0,0,1,0,0, 0,1,1,1,0
ans2 BYTE 0,1,1,1,0, 1,0,0,0,1, 0,0,0,0,1, 0,0,0,1,0, 0,0,1,0,0, 0,1,0,0,0, 1,1,1,1,1
ans3 BYTE 0,1,1,1,0, 1,0,0,0,1, 0,0,0,0,1, 0,0,1,1,0, 0,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0
ans4 BYTE 1,0,0,0,1, 1,0,0,0,1, 1,0,0,0,1, 1,1,1,1,1, 0,0,0,0,1, 0,0,0,0,1, 0,0,0,0,1
ans5 BYTE 1,1,1,1,1, 1,0,0,0,0, 1,1,1,1,0, 0,0,0,0,1, 0,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0
ans6 BYTE 0,1,1,1,0, 1,0,0,0,1, 1,0,0,0,0, 1,1,1,1,0, 1,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0
ans7 BYTE 1,1,1,1,1, 0,0,0,0,1, 0,0,0,0,1, 0,0,0,1,0, 0,0,1,0,0, 0,0,1,0,0, 0,0,1,0,0
ans8 BYTE 0,1,1,1,0, 1,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0, 1,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0
ans9 BYTE 0,1,1,1,0, 1,0,0,0,1, 1,0,0,0,1, 0,1,1,1,1, 0,0,0,0,1, 1,0,0,0,1, 0,1,1,1,0

playA BYTE 0,1,1,0, 1,0,0,1, 1,0,0,1, 1,1,1,1, 1,0,0,1
playB BYTE 1,1,1,0, 1,0,0,1, 1,1,1,0, 1,0,0,1, 1,1,1,0
play0 BYTE 1,1,1,1, 1,0,0,1, 1,0,0,1, 1,0,0,1, 1,1,1,1
play1 BYTE 0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0, 0,0,1,0
play2 BYTE 1,1,1,1, 0,0,0,1, 1,1,1,1, 1,0,0,0, 1,1,1,1
play3 BYTE 1,1,1,1, 0,0,0,1, 1,1,1,1, 0,0,0,1, 1,1,1,1
play4 BYTE 1,0,0,1, 1,0,0,1, 1,1,1,1, 0,0,0,1, 0,0,0,1
play5 BYTE 1,1,1,1, 1,0,0,0, 1,1,1,1, 0,0,0,1, 1,1,1,1
play6 BYTE 1,1,1,1, 1,0,0,0, 1,1,1,1, 1,0,0,1, 1,1,1,1
play7 BYTE 1,1,1,1, 0,0,0,1, 0,0,0,1, 0,0,0,1, 0,0,0,1
play8 BYTE 1,1,1,1, 1,0,0,1, 1,1,1,1, 1,0,0,1, 1,1,1,1
play9 BYTE 1,1,1,1, 1,0,0,1, 1,1,1,1, 0,0,0,1, 1,1,1,1

wallUD_ATTR WORD gameW DUP(0C0h)
wallLR_ATTR WORD gameB DUP(0C0h)
ansUD_ATTR WORD ansW DUP(0C0h)
ansLR_ATTR WORD ansB DUP(0C0h)
life_ATTR WORD 0C0h
ans_ATTR WORD 0B0h
null_ATTR WORD 0
play_ATTR WORD 0D0h

; 504
answer BYTE 255,255,255,255
count BYTE 2 DUP(0)
tool1 BYTE 0
runcount BYTE ?
input BYTE BufSize Dup(?),0,0
inputHandle HANDLE ?
bytesRead DWORD ?

; 501
buffer1 BYTE buffer_size DUP(?)
buffer2 BYTE buffer_size DUP(?)
buffer4 BYTE buffer_size DUP(?)
win    BYTE "win.txt"
fileHandle3  HANDLE ?
lose   BYTE "lose.txt"
fileHandle1  HANDLE ?
text	BYTE "text.txt"
fileHandle2  HANDLE ?
consoleHandle    DWORD ?
xyInit1 COORD <20,24> 
xyPos1 COORD <,> 

.code
main PROC

    INVOKE GetStdHandle,STD_OUTPUT_HANDLE
    mov outputHandle,eax
	
initial:
	mov ax,xyInit.x
	mov xyPos.x,ax
	mov ax,xyInit.y
	mov xyPos.y,ax
	
read_file_name:
	mov edx,offset filename
	call OpenInputFile
	mov fileHandle,eax
	cmp eax,INVALID_HANDLE_VALUE
	jne file_ok	
	jmp quit
	
file_ok:
	mov edx,offset buffer
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size
	jmp close_file
	
check_buffer_size:
	cmp eax,BUFFER_SIZE
	jb buf_size_ok
	jmp quit

buf_size_ok:
	call Clrscr
	mov edx,offset buffer
	mov eax,yellow;+(blue*16)
	call SetTextColor
	call WriteString

close_file:
	mov eax,fileHandle
	call CloseFile
	jmp choose
	
read_file_name2:
	mov edx,offset filename2
	call OpenInputFile
	mov fileHandle4,eax
	cmp eax,INVALID_HANDLE_VALUE
	jne file_ok2	
	jmp quit

file_ok2:
	mov edx,offset buffer3
	mov ecx,BUFFER_SIZE
	call ReadFromFile
	jnc check_buffer_size2
	jmp close_file2

check_buffer_size2:
	cmp eax,BUFFER_SIZE
	jb buf_size_ok2
	jmp quit

buf_size_ok2:
	call Clrscr
	mov edx,offset buffer3
	mov eax,yellow
	call SetTextColor
	call WriteString

close_file2:
	mov eax,fileHandle4
	call CloseFile

explain_initial:
	mov ax,xyInit.x
	mov xyPos.x,ax
	mov ax,xyInit.y
	mov xyPos.y,ax
	jmp choose2

choose:
	INVOKE SetConsoleCursorPosition, outputHandle, xyPos
	call ReadChar
	.IF ax==011Bh
		jmp quit
	.ENDIF

	.IF ax==4D00h
		add xyPos.x,12
	.ENDIF

	.IF ax==4B00h
		sub xyPos.x,12
	.ENDIF

	.IF ax==1C0Dh
		jmp judge_pos
	.ENDIF

	.IF xyPos.x == 6 
		add xyPos.x,12
	.ENDIF

	mov ax,xyBound.x 
	.IF xyPos.x == ax 
		sub xyPos.x,12
	.ENDIF

	jmp choose

judge_pos:
	.IF xyPos.x==18
		jmp GAME
	.ENDIF

	.IF xyPos.x==30
		jmp explain
	.ENDIF

choose2:
	INVOKE SetConsoleCursorPosition, consoleHandle, xyPos
	call ReadChar
	.IF ax==1C0Dh
		jmp GAME
	.ENDIF

	.IF xyPos.x == 6 
		add xyPos.x,12
	.ENDIF

	.IF xyPos.x == 30 
		sub xyPos.x,12
	.ENDIF

	jmp choose2

explain:
	call Clrscr
	jmp read_file_name2

quit:
	exit

; GAME
GAME:
	call Clrscr
	
; LIFE
	push gameXY
	push gameXY
	add gameXY.X, lifeOut
	mov ecx, lifeNum
life_Num:
	push ecx
	push gameXY
	mov esi,0
	mov ecx, lifeH
life_Out:
	push ecx
	push gameXY.X
	mov ecx, lifeW
life_In:
	push ecx
	cmp [life+esi], 0
	je lifeNO
	push esi
	INVOKE print, ADDR life_ATTR, ADDR output, 1, gameXY
	pop esi
lifeNO:
	inc esi
	pop ecx
	inc gameXY.X
	loop life_In
	inc gameXY.Y
	pop gameXY.X
	pop ecx
	loop life_Out
	pop gameXY
	add gameXY.X, (lifeW+lifeIn)
	pop ecx
	loop life_Num
	pop gameXY
	add gameXY.Y, (lifeH+1)

; QUESTION
	; top
	INVOKE print, ADDR wallUD_ATTR, ADDR wallUD, gameW, gameXY
	add gameXY, 14
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR ansWord, lengthof ansWord, gameXY, ADDR cellsWritten
	sub gameXY, 14
	inc gameXY.Y
	; body
	push gameXY ; for ans
	mov ecx, questionH
L1:
	push ecx
	INVOKE print, ADDR wallLR_ATTR, ADDR wallLR, gameB, gameXY
	add gameXY.X, gameW-gameB
	INVOKE print, ADDR wallLR_ATTR, ADDR wallLR, gameB, gameXY
	sub gameXY.X, gameW-gameB
	inc gameXY.Y
	pop ecx
	loop L1
	; Ans
	pop gameXY
	inc gameXY.Y
	; ans-top
	push gameXY.X
	add gameXY.X, (gameB+ansOut)
	; ans position
	mov bx, gameXY.X
	mov ansXY.X, bx
	mov bx, gameXY.Y
	mov ansXY.Y, bx
	; ------------
	mov ecx, ansNum
ansTop:
	push ecx
	INVOKE print, ADDR ansUD_ATTR, ADDR ansUD, ansW, gameXY
	add gameXY.X, (ansW+ansIn)
	pop ecx
	loop ansTop
	inc gameXY.Y
	pop gameXY.X
	; ans-body
	mov esi, 0
	mov ecx, (ansH-2)
ansBodyOut:
	push ecx
	push gameXY.X	
	add gameXY.X, (gameB+ansOut)
	mov ecx, ansNum
ansBodyIn:
	push ecx
	INVOKE print, ADDR ansLR_ATTR, ADDR ansLR, ansB, gameXY
	add gameXY.X, (ansW-ansB)
	INVOKE print, ADDR ansLR_ATTR, ADDR ansLR, ansB, gameXY
	add gameXY.X, (ansIn+ansB)
	pop ecx
	loop ansBodyIn
	inc gameXY.Y
	pop gameXY.X
	pop ecx
	loop ansBodyOut
	; ans-bottom
	push gameXY.X
	add gameXY.X, (gameB+ansOut)
	mov ecx, ansNum
ansBottom:
	push ecx
	INVOKE print, ADDR ansUD_ATTR, ADDR ansUD, ansW, gameXY
	add gameXY.X, (ansW+ansIn)
	pop ecx
	loop ansBottom
	add gameXY.Y, 2
	pop gameXY.X
	; bottom
	INVOKE print, ADDR wallUD_ATTR, ADDR wallUD, gameW, gameXY
	inc gameXY.Y
	
; PLAY
	; top
	; play position
	mov bx, gameXY.Y
	mov playXY.Y, bx
	mov inputXY.Y, bx ; Cursor Position
	mov bx, gameXY.X
	mov playXY.X, bx
	; ------------
	add gameXY.X, gameB
	mov bx, gameXY.X
	add bx, (lengthof playWord+1)
	mov inputXY.X, bx  ; Cursor Position
	INVOKE WriteConsoleOutputCharacter, outputHandle, ADDR playWord, lengthof playWord, gameXY, ADDR cellsWritten
	sub gameXY.X, gameB
	; body
	mov ecx, playH
L2: 
	push ecx
	INVOKE print, ADDR wallLR_ATTR, ADDR wallLR, gameB, gameXY
	add gameXY.X, (gameW-gameB)
	INVOKE print, ADDR wallLR_ATTR, ADDR wallLR, gameB, gameXY
	sub gameXY.X, (gameW-gameB)
	inc gameXY.Y
	pop ecx
	loop L2
	; bottom
	INVOKE print, ADDR wallUD_ATTR, ADDR wallUD, gameW, gameXY
	pop gameXY
	
; ANS
	push ansXY
	inc ansXY.X
	inc ansXY.Y
	mov ecx, ansNum
ansM_Num:
	push ecx
	push ansXY ; 起始位置
	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, ansXY, ADDR ansM
	pop ansXY
	add ansXY.X, (ansWordW+ansB+ansB+ansIn)
	pop ecx
	loop ansM_Num
	pop ansXY
	
; START
	INVOKE GetStdHandle, STD_INPUT_HANDLE
	mov inputHandle,eax
	call Randomize
	mov ecx,4
random1:
	mov runcount,cl
	mov eax,10
	call RandomRange
	mov ecx,4
random2:
	cmp answer[ecx-1],al
	jz notok
	loop random2
	movsx ecx,runcount
	call WriteDec
	mov ecx,4
	sub cl,runcount
	mov answer[ecx],al
	jmp ok
notok:
	add runcount,1
ok:	
	movsx ecx,runcount
	loop random1
	mov ecx,4
	mov ecx,5
run:
	mov runcount,cl
	INVOKE SetConsoleCursorPosition, outputHandle, inputXY ; 設定游標位置
	INVOKE ReadConsole, inputHandle, ADDR input, BufSize, ADDR bytesRead, 0
	INVOKE FIND, OFFSET input, OFFSET count, OFFSET answer, tool1
	INVOKE playPrint, ADDR input, ADDR count
	INVOKE minusLife, runcount
	add playXY.Y, (playNumWordH+1-2)
	cmp count[0],4
	jnz cl1
	jmp showwin
cl1:	
	movsx ecx,runcount
	loop run
	jmp showlose

; END 	
showwin:
	call Clrscr
	mov	edx,OFFSET win
	mov	ecx,SIZEOF win
	call	OpenInputFile
	mov	fileHandle3,eax					
	mov	edx,OFFSET buffer4
	mov	ecx,buffer_size
	call	ReadFromFile	
	mov	edx,OFFSET buffer4
	mov	eax,white
	call    settextcolor
	call	WriteString
	mov eax,fileHandle3
	call CloseFile
	call	Crlf
	
	mov	edx,OFFSET text
	mov	ecx,SIZEOF text
	call	OpenInputFile
	mov	fileHandle2,eax					
	mov	edx,OFFSET buffer2
	mov	ecx,buffer_size
	call	ReadFromFile	
	mov	edx,OFFSET buffer2
	mov	eax,yellow
	call    settextcolor	
	call	WriteString
	mov eax,fileHandle2
	call CloseFile
	jmp 	key
showlose:
	call Clrscr
	mov	edx,OFFSET lose
	mov	ecx,SIZEOF lose
	call	OpenInputFile
	mov	fileHandle1,eax					
	mov	edx,OFFSET buffer1
	mov	ecx,buffer_size
	call	ReadFromFile	
	mov	edx,OFFSET buffer1
	mov	eax,white
	call    settextcolor		
	call	WriteString
	mov eax,fileHandle1
	call CloseFile
	call	Crlf
	
	mov	edx,OFFSET text
	mov	ecx,SIZEOF text
	call	OpenInputFile
	mov	fileHandle2,eax					
	mov	edx,OFFSET buffer2
	mov	ecx,buffer_size
	call	ReadFromFile	
	mov	edx,OFFSET buffer2
	mov	eax,yellow
	call    settextcolor
	call	WriteString
	mov eax,fileHandle2
	call CloseFile
	jmp key
key:
	mov ax,xyInit1.x
	mov xyPos1.x,ax
	mov ax,xyInit1.y
	mov xyPos1.y,ax
STARTkey:
	INVOKE SetConsoleCursorPosition, outputHandle, xyPos1
	call ReadChar
	.IF ax == 4800h ;UP
		sub xyPos1.y,1
		sub xyPos1.x,2
	.ENDIF
	.IF ax == 5000h ;DOWN
		add xyPos1.y,1
		add xyPos1.x,2
	.ENDIF

	.IF ax == 1C0Dh  ;enter
		.IF xyPos1.y == 24 
			jmp initial
		.ENDIF
		.IF xyPos1.y == 25 
			jmp GAME
		.ENDIF
		.IF xyPos1.y == 26 
			jmp quit 
		.ENDIF
	.ENDIF
	.IF xyPos1.y == 23 ;y lowerbound
		add xyPos1.y,1
		add xyPos1.x,2
		jmp STARTkey 
	.ENDIF
	.IF xyPos1.y == 27 ;y upperbound
		sub xyPos1.y,1
		sub xyPos1.x,2
		jmp STARTkey
	.ENDIF
	jmp STARTkey
main ENDP

; 502
; 輸出
print PROC uses eax ebx ecx edx edi esi, pAttribute:PTR WORD, pBuffer:PTR BYTE, nLength:DWORD, xyCoord:COORD

	INVOKE WriteConsoleOutputAttribute, outputHandle, pAttribute, nLength, xyCoord, ADDR cellsWritten
    INVOKE WriteConsoleOutputCharacter, outputHandle, pBuffer, nLength, xyCoord, ADDR cellsWritten
	ret
print ENDP
; 文字輸出
wordPrint PROC uses eax ebx ecx edx edi esi, ATTR:PTR WORD, wordH:DWORD, wordW:DWORD, XY:COORD, wordAr:PTR BYTE
	
	mov edi, wordAr
	mov ebx, 0
	mov ecx, wordH
wordOut:
	push ecx
	push XY.X
	mov ecx, wordW
wordIn:
	push ecx
	push edi
	push ebx
	INVOKE print, ADDR null_ATTR, ADDR output, 1, XY
	cmp [edi], bl
	je wordN
	INVOKE print, ATTR, ADDR output, 1, XY
wordN:
	pop ebx
	pop edi
	inc edi
	pop ecx
	inc XY.X
	loop wordIn
	inc XY.Y
	pop XY.X
	pop ecx
	loop wordOut
	ret
wordPrint ENDP
; 判斷文字並輸出
cmpNum PROC uses eax ebx ecx edx edi esi, num:BYTE, ansORplay:BYTE, XY:COORD

	cmp ansORplay, 0
	je playCmp
	cmp num, 0
	je a0
	cmp num, 1
	je a1
	cmp num, 2
	je a2
	cmp num, 3
	je a3
	cmp num, 4
	je a4
	cmp num, 5
	je a5
	cmp num, 6
	je a6
	cmp num, 7
	je a7
	cmp num, 8
	je a8
	cmp num, 9
	je a9
a0:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans0
	ret
a1:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans1
	ret
a2:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans2
	ret
a3:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans3
	ret
a4:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans4
	ret
a5:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans5
	ret
a6:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans6
	ret
a7:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans7
	ret
a8:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans8
	ret
a9:	INVOKE wordPrint, ADDR ans_ATTR, ansWordH, ansWordW, XY, ADDR ans9
	ret
playCmp:
	cmp num, 0
	je p0
	cmp num, 1
	je p1
	cmp num, 2
	je p2
	cmp num, 3
	je p3
	cmp num, 4
	je p4
	cmp num, 5
	je p5
	cmp num, 6
	je p6
	cmp num, 7
	je p7
	cmp num, 8
	je p8
	cmp num, 9
	je p9
	cmp num, 10
	je p10
	cmp num, 11
	je p11
p0:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play0
	ret
p1:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play1
	ret
p2:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play2
	ret
p3:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play3
	ret
p4:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play4
	ret
p5:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play5
	ret
p6:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play6
	ret
p7:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play7
	ret
p8:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play8
	ret
p9:	INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR play9
	ret
p10:INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR playA
	ret
p11:INVOKE wordPrint, ADDR play_ATTR, playNumWordH, playNumWordW, XY, ADDR playB
	ret
cmpNum ENDP
; A輸出
getA PROC uses eax ebx ecx edx edi esi, num:BYTE, pos:BYTE
	
	dec pos
	push ansXY
	inc ansXY.X
	inc ansXY.Y
	cmp pos, 0
	je first
	movzx ecx, pos
posL:
	add ansXY.X, (ansWordW+ansB+ansIn+ansB)
	loop posL
first:
	INVOKE cmpNum, num, ans, ansXY
	pop ansXY
	ret
getA ENDP
; 減命
minusLife PROC uses eax ebx ecx edx edi esi, num:BYTE
	
	dec num
	push lifeXY
	add lifeXY.X, lifeOut
	cmp num, 0
	je lifeL1
	movzx ecx, num
lifeL:
	add lifeXY.X, (lifeW+lifeIn)
	loop lifeL
lifeL1:
	mov esi,0
	mov ecx, lifeH
life_O:
	push ecx
	push lifeXY.X
	mov ecx, lifeW
life_I:
	push ecx
	INVOKE print, ADDR null_ATTR, ADDR output, 1, lifeXY
	pop ecx
	inc lifeXY.X
	loop life_I
	inc lifeXY.Y
	pop lifeXY.X
	pop ecx
	loop life_O
	pop lifeXY
	ret
minusLife ENDP
; input & AB
playPrint PROC uses eax ebx ecx edx edi esi, playWordAr:PTR BYTE, abAr:PTR BYTE
	
	push inputXY
	mov ecx, 32
inputL1:
	push ecx
	INVOKE print, ADDR null_ATTR, ADDR output, 1, inputXY
	pop ecx
	inc inputXY.X
	loop inputL1
	pop inputXY
	
; INPUT
	mov edi, playWordAr
	push playXY.X
	add playXY.X, (gameB+playOut)
	add playXY.Y, 2
	mov ecx, ansNum
Num:
	push ecx
	push playXY.X
	push edi
	push bx
	mov bl, [edi]
	INVOKE cmpNum, bl, play, playXY
	pop bx
	pop edi
	inc edi
	pop playXY.X
	add playXY.X, (playNumWordW+playIn)
	pop ecx
	loop Num
; AB
	mov edi, abAr
	add playXY.X, (playOut+playOut-playIn)
	mov bl, [edi]
	push bx
	push edi
	INVOKE cmpNum, bl, play, playXY
	pop edi
	pop bx
	add playXY.X, (playNumWordW+playIn)
	INVOKE cmpNum, 10, play, playXY
	add playXY.X, (playNumWordW+playIn)
	inc edi
	mov bl, [edi]
	push bx
	push edi
	INVOKE cmpNum, bl, play, playXY
	pop edi
	pop bx
	add playXY.X, (playNumWordW+playIn)
	INVOKE cmpNum, 11, play, playXY
	pop playXY.X
	ret
playPrint ENDP

; 504
FIND PROC uses eax ebx ecx edx edi esi,
	inp:PTR BYTE,
	num:PTR BYTE,
	ans111:PTR BYTE,
	tool:BYTE
	cld 
	mov eax,num
	mov BYTE PTR[eax],0
	mov BYTE PTR[eax+1],0
	mov edi,ans111
	mov esi,inp
	mov ecx,4

hex:
	sub BYTE PTR[esi+ecx-1],48
	loop hex
	mov ecx,4
fa:
	mov tool,cl
	mov bl,[esi+ecx-1];
	mov ecx,4
fb:
	mov edi,ans111
	mov bh,[edi+ecx-1];ans111
	cmp bh,bl
	jz addcount
	jmp next
addcount:
	cmp cl,tool
	jz adda
	jmp addb
adda:
	add BYTE PTR[eax],1	
	push [eax]
	push [eax+1]
	INVOKE getA, bl, cl
	mov eax,num
	pop [eax+1]
	pop [eax]
	jmp next
addb:
	add BYTE PTR[eax+1],1
	jmp next
next:
	loop fb
	movsx ecx,tool
	loop fa
	ret
FIND ENDP
	
END main