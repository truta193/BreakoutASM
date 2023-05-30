.586
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc
extern printf: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
windowTitle DB "DXBallMegaCool",0
areaWidth EQU 750
areaHeight EQU 550
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbolWidth EQU 10
symbolHeight EQU 20
include digits.inc
include letters.inc

;Buffers
bufferdd1 dd 0
bufferdd2 dd 0
bufferdd3 dd 0
bufferdd4 dd 0
bufferdd5 dd 0
bufferdd6 dd 0
bufferdd7 dd 0
bufferdd8 dd 0
bufferdd9 dd 0
bufferdd10 dd 0
bufferdd11 dd 0
bufferdd12 dd 0
bufferfd1 real8 0.0
bufferfd2 real8 0.0
bufferfd3 real8 0.0
bufferfd4 real8 0.0
bufferfd5 real8 0.0
bufferfd6 real8 0.0
bufferfd7 real8 0.0
bufferfd8 real8 0.0
bufferfd9 real8 0.0
clampiBufferdd0 dd 0
clampiBufferdd1 dd 0
clampiBufferdd2 dd 0
clampfBufferRet real8 0.0
speedMultiplierDistance real8 1.1
angleMultiplier real8 1.2

ZEROFD real8 0.0
NINEFD real8 9.0

testPrint1 db "Yo it hit", 10, 13, 0
testPrint2 db "Yo it no hit", 10, 13, 0
ballFormat db "Ball center: %d %d", 10, 13, 0
dFormat db "%d", 10, 13, 0
lft db "left", 10, 13, 0
rigt db "right", 10, 13, 0 
top db "top", 10, 13, 0
btm db "bottom", 10, 13, 0

Target struct
	tX dd ?
	tY dd ?
	tWidth dd ?
	tHeight dd ?
	color dd ?
Target ends

;Ball data
Ball struct
	centerX dd ?
	centerY dd ?
	radius dd ?
	directionX real8 ?
	directionY real8 ?
	velocity real8 ?
Ball ends

;Player data
Player struct
	pX dd ? ;top left
	pY dd ? ;top left
	pWidth dd ?
	pHeight dd ?
	velocity real8 ?
	color dd ?
Player ends 

; Init game ball
; Have to initialize radius with 10 for now because ball is hand drawn with a 10 pixel radius
;               cx  cy  r  dx  dy  v 
GameBall Ball {100,400,10,0.0,-5.5,4.0}
GameBallS1 Ball {100,400,10,0.0,-5.5,4.0}
GameBallS2 Ball {100,400,10,0.0,-5.5,4.0}
minimumVelocity real8 4.0
maximumVelocity real8 6.0
decayVelocity real8 0.004

;				 x    y    w   h   v
Player1 Player {300, 525 , 80, 20, 15.0, 4c7ecfh}

playerBaseWidth dd 80
playerMinWidth dd 50
playerMaxWidth dd 110
playerBaseVelocity real8 15.0
playerMinVelocity real8 8.0
playerMaxVelocity real8 20.0

Row1 Target {5, 5, 70, 25, 0FF0000h}, {79, 5, 70, 25, 0FF0000h}, {153, 5, 70, 25, 0FF0000h}, {227, 5, 70, 25, 0FF0000h}, {301, 5, 70, 25, 0FF0000h}, {375, 5, 70, 25, 0FF0000h}, {449, 5, 70, 25, 0FF0000h}, {523, 5, 70, 25, 0FF0000h}, {597, 5, 70, 25, 0FF0000h}, {671, 5, 70, 25, 0FF0000h}
Mask1 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
Row2 Target {5, 35, 70, 25, 0FF7B39h}, {79, 35, 70, 25, 0FF7B39h}, {153, 35, 70, 25, 0FF7B39h}, {227, 35, 70, 25, 0FF7B39h}, {301, 35, 70, 25, 0FF7B39h}, {375, 35, 70, 25, 0FF7B39h}, {449, 35, 70, 25, 0FF7B39h}, {523, 35, 70, 25, 0FF7B39h}, {597, 35, 70, 25, 0FF7B39h}, {671, 35, 70, 25, 0FF7B39h}
Mask2 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
Row3 Target {5, 65, 70, 25, 0EEFF00h}, {79, 65, 70, 25, 0EEFF00h}, {153, 65, 70, 25, 0EEFF00h}, {227, 65, 70, 25, 0EEFF00h}, {301, 65, 70, 25, 0EEFF00h}, {375, 65, 70, 25, 0EEFF00h}, {449, 65, 70, 25, 0EEFF00h}, {523, 65, 70, 25, 0EEFF00h}, {597, 65, 70, 25, 0EEFF00h}, {671, 65, 70, 25, 0EEFF00h}
Mask3 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
Row4 Target {5, 95, 70, 25, 00F204h}, {79, 95, 70, 25, 00F204h}, {153, 95, 70, 25, 00F204h}, {227, 95, 70, 25, 00F204h}, {301, 95, 70, 25, 00F204h}, {375, 95, 70, 25, 00F204h}, {449, 95, 70, 25, 00F204h}, {523, 95, 70, 25, 00F204h}, {597, 95, 70, 25, 00F204h}, {671, 95, 70, 25, 00F204h}
Mask4 dd 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
rowTargetCount dd 10
;ff7b39
;EEFF00
;00f204


bonusBaseVelocity EQU 0.8

BonusGrow Ball {0,0,10, 0.0, 3.0, bonusBaseVelocity}
bonusGrowActive dd 0
bonusGrowVisible dd 0
BonusShrink Ball {0,0,10, 0.0, 3.0, bonusBaseVelocity}
bonusShrinkActive dd 0
bonusShrinkVisible dd 0
BonusSpeedUp Ball {0,0,10, 0.0, 3.0, bonusBaseVelocity}
bonusSpeedUpActive dd 0
bonusSpeedUpVisible dd 0
BonusSpeedDown Ball {0,0,10, 0.0, 3.0, bonusBaseVelocity}
bonusSpeedDownActive dd 0
bonusSpeedDownVisible dd 0
BonusSplitBall Ball {0,0,10, 0.0, 3.0, bonusBaseVelocity}
bonusSplitBallActive dd 0
bonusSplitBallVisible dd 0

bonusDuration dd 600 ; 10s @ 60fps
bonusCounterBuffer dd 0
bonusGrowBuffer dd 0
bonusShrinkBuffer dd 0
bonusSpeedUpBuffer dd 0
bonusSpeedDownBuffer dd 0
bonusSplitBallBuffer dd 0

bonusSplitBallAngleMultiplier real8 1.1
bonusSplitBallAngleAdd real8 0.2


isGame dword 0
isLoss dword 0
isWin dword 0
timerDuration dword 70
eventDuration dword 340
counterBuffer dword 0
targetDestroyedCounter dword 0

.code


drawTextInternal proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbolWidth
	mul ebx
	mov ebx, symbolHeight
	mul ebx
	add esi, eax
	mov ecx, symbolHeight
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbolHeight
	sub eax, ecx
	mov ebx, areaWidth
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbolWidth
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	jne simbol_pixel_alb ; Was je; Switched to flip text/background colors
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
drawTextInternal endp

; un macro ca sa apelam mai usor desenarea simbolului
drawText macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call drawTextInternal
	add esp, 16
endm


; Takes the addresses of two values, x and y (real8), the components of the vector and normalizes them
; Usage:
; push offset x
; push offset y
; call normalizeVector
; add esp, 8
;
; x - arg1
; y - arg2
normalizeVector proc
	push ebp
	mov ebp, esp
	pushad
	
	mov eax, [ebp+8] ;addr of x
	mov ebx, [ebp+12] ;addr of y
	
	finit
	
	fld real8 ptr [eax]
	fld real8 ptr [eax]
	fmul ; st(0) now has x^2
	fld real8 ptr [ebx]
	fld real8 ptr [ebx]
	fmul ; st(1) has x^2, st(0) has y^2
	fadd
	fsqrt ; Stores magnitude
	
	fst ST(1) ; Copy value, so ST(0) and ST(1) both have the magnitude
	fld real8 ptr [eax] ; Load x
	fxch ST(1)
	fdiv ; Normalized x
	fstp real8 ptr [eax] ; Update x value
	

	fld real8 ptr [ebx] ; Load y
	fxch ST(1)
	fdiv ; Normalized y
	fst real8 ptr [ebx] ; Update y value
	
	popad
	mov esp, ebp
	pop ebp
	ret
normalizeVector endp


drawLineHorizontalLength macro x, y, len, color
local lineLoop, lenElse, done
	mov eax, y	
	mov ebx, areaWidth
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	
	
	;Refuse to draw if coords are out of bounds
	;TODO
	;In case it is "above" the viewport, draw the visible part instead of cancelling the draw request
	mov ebx, x
	cmp ebx, areaWidth
	jg done
	cmp ebx, 0
	jl done
	
	mov ebx, y
	cmp ebx, areaHeight
	jg done
	cmp ebx, 0
	jl done
	
	
	;Will handle off-screen pixels by not drawing them
	mov ecx, x
	add ecx, len
	cmp ecx, areaWidth ; if (x + len > areaWidth) then ecx = areaWidth - x else ecx = len
	jbe lenElse
		mov ecx, areaWidth
		sub ecx, x
		jmp lineLoop
	lenElse:
		mov ecx, len
		
lineLoop:
	mov edx, color
	mov dword ptr[eax], edx
	add eax, 4
	loop lineLoop
done:
endm

drawLineVerticalLength macro x, y, len, color
local lineLoop, lenElse, done, continue
	mov eax, y
	mov ebx, areaWidth
	mul ebx
	add eax, x
	shl eax, 2
	add eax, area
	
	
	; Refuse to draw if coords are out of bounds
	mov ebx, x
	cmp ebx, areaWidth
	jg done
	cmp ebx, 0
	jl done
	
	mov ebx, y
	cmp ebx, areaHeight
	jg done
	;TODO
	; In case it is "above" the viewport, draw the visible part instead of cancelling the draw request
	cmp ebx, 0
	jl done	

	; Will handle off-screen pixels by not drawing them
	mov ecx, y
	add ecx, len
	cmp ecx, areaHeight ; if (y + len > areaHeight) then ecx = areaHeight - y else ecx = len
	jbe lenElse
		mov ecx, areaHeight
		sub ecx, y
		jmp lineLoop
	lenElse:
		mov ecx, len
		
lineLoop:
	mov edx, color
	mov dword ptr[eax], edx
	add eax, 4 * areaWidth
	loop lineLoop
done:
endm

; draws a 21x21 circle around the ball's center
ballDraw macro ball, color
local done
	mov eax, ball.centerX
	sub eax, 10 ; left-most point
	mov ebx, ball.centerY
	sub ebx, 10 ; top-most point
	mov bufferdd1, eax ; left-most point
	mov bufferdd2, ebx ; top-most point
	
	; Do not draw ball if a part of it is outside
	cmp eax, 0
	jl done
	cmp ebx, 0
	jl done
	
	; draw the ball line by line, increments x and y
	add bufferdd1, 7
	drawLineHorizontalLength bufferdd1, bufferdd2, 7, color
	add bufferdd2, 1
	sub bufferdd1, 2
	drawLineHorizontalLength bufferdd1, bufferdd2, 11, color
	add bufferdd2, 1
	sub bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 13, color
	add bufferdd2, 1
	sub bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 15, color
	add bufferdd2, 1
	sub bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 17, color	
	add bufferdd2, 1
	sub bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 19, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 19, color
	add bufferdd2, 1
	sub bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 21, color
	add bufferdd2, 1
	add bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 19, color
	add bufferdd2, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 19, color
	add bufferdd2, 1
	add bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 17, color
	add bufferdd2, 1
	add bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 15, color
	add bufferdd2, 1
	add bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 13, color
	add bufferdd2, 1
	add bufferdd1, 1
	drawLineHorizontalLength bufferdd1, bufferdd2, 11, color
	add bufferdd2, 1
	add bufferdd1, 2
	drawLineHorizontalLength bufferdd1, bufferdd2, 7, color
done:
endm

ballUpdate macro ball
local done, min, max, skip, cont
	finit
	fld ball.directionX
	fld ball.velocity
	fmul ; New X-axis increment
	fild ball.centerX
	fadd
	frndint ; Round to integer so it can be stored
	fistp ball.centerX
	
	fld ball.directionY
	fld ball.velocity
	fmul ; New Y-axis increment
	fild ball.centerY
	fadd
	frndint ; Round to integer so it can be stored
	fistp ball.centerY
	cmp ball.centerY, areaHeight
	jl cont
	mov ball.centerY, areaHeight-1
cont:
	
	; Limit maximum velocity
	finit
	fld ball.velocity
	fld maximumVelocity
	fxch
	fcomi ST(0), ST(1)
	jbe skip ; if ball velocity if greater than max velocity, clamp
	fxch
	fstp real8 ptr [ball.velocity]
skip:
	finit 
	fld ball.velocity
	fld minimumVelocity
	fcomi ST(0), ST(1)
	ja min
	finit
	; v / abs(v) = 1 or -1, so we get it's sign
	fld ball.velocity
	fld ball.velocity
	fabs
	fdiv ; At this point we have the sign of the velocity
	; Load the abs value of the velocity and apply decay
	fld ball.velocity
	fabs
	fld decayVelocity
	fsub
	;Reapply sign
	fmul 
	fst real8 ptr [ball.velocity]
	finit
	jmp done
min:
	; In case the decay increment goes beyond, reset the speed
	fld minimumVelocity
	fstp real8 ptr [ball.velocity]
done:
endm

ballCheckBounds macro ball
local notop, noleft, done, noloss
	;Check loss condition 
	mov eax, ball.centerY
	add eax, ball.radius
	add eax, ball.radius
	cmp eax, areaHeight
	jl noloss
	mov isLoss, 1
	mov eax, counter
	mov counterBuffer, eax
	jmp done
noloss:
	;Check top collision
	mov eax, ball.centerY
	sub eax, ball.radius
	cmp eax, 0
	jg notop	
	
	; Reposition ball so it's not outside
	mov ball.centerY, 10
	finit 
	fld ball.directionX
	fld ball.directionY
	fdiv
	mov bufferdd1, eax
	fild bufferdd1
	fabs
	fmul
	fild ball.centerX
	fadd
	frndint
	fistp dword ptr [ball.centerX]
	
	
	;flip y direction 
	finit
	fld ball.directionY
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	;frndint
	fstp real8 ptr [ball.directionY]
	;mov eax, bufferdd1
	;mov real8 ptr [ball.directionY], eax
	
notop:
	;Check left side collision
	mov eax, ball.centerX
	sub eax, ball.radius
	cmp eax, 0 ; Check left side
	jg noleft
	
	; Reposition ball so it's not outside
	mov ball.centerX, 11
	finit 
	fld ball.directionY
	fld ball.directionX
	fdiv
	mov bufferdd1, eax
	fild bufferdd1
	fabs
	fmul
	fild ball.centerY
	fadd
	frndint
	fistp dword ptr [ball.centerY]	

	;flip x direction
	finit
	fld ball.directionX
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	;frndint
	fstp real8 ptr [ball.directionX]
	;mov eax, bufferdd1
	;mov real8 ptr [ball.directionX], eax
noleft:
	;Check right side collision
	mov eax, ball.centerX
	add eax, ball.radius
	cmp eax, areaWidth
	jl done
	
	mov ebx, areaWidth
	sub ebx, 11
	mov ball.centerX, ebx
	finit 
	fld ball.directionY
	fld ball.directionX
	fdiv
	mov ebx, areaWidth
	sub ebx, ball.radius
	sub ebx, ball.centerX
	mov bufferdd1, ebx
	fild bufferdd1
	fabs
	fmul
	fild ball.centerY
	fadd
	frndint
	fistp dword ptr [ball.centerY]
	
	finit
	fld ball.directionX
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	;frndint
	fstp real8 ptr [ball.directionX]
	;mov eax, bufferdd1
	;mov real8 ptr [ball.directionX], eax
	
done:
endm

playerUpdateVelocity macro player, key
local done, check, nope
	mov eax, key
	finit 
	cmp eax, 25h ; left arrow
	jne check
	fld player.velocity
	fabs
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	fstp real8 ptr [player.velocity]
	jmp done
check:
	cmp eax, 27h ; right arrow
	jne nope
	fld player.velocity
	fabs
	fstp real8 ptr [player.velocity]
	jmp done
nope:
	;fldz
	;fstp real8 ptr [player.velocity]

done:
endm

playerUpdatePosition macro player
local movel, mover, done, movelok, moverok
	mov bufferdd5, areaWidth
	finit
	fld player.velocity
	fldz
	fcomi ST(0), ST(1) ; Compare 0 with velocity to determine if we're moving to the left or to the right
	fstp ST(0)
	jb mover
movel:
	; If we're moving to the left, clamp movement at 0 and decrement
	fild player.pX
	fadd
	fldz
	fcomi ST(0), ST(1)
	fstp ST(0)
	jb movelok
	; Negative coordinates, clamp to 0
	mov eax, 0
	mov dword ptr [player.pX], eax
	jmp done
movelok:
	frndint
	fist dword ptr [player.pX]
	jmp done
mover:
	; IF we're moving to the right, clamp movement at areaWidth
	; Here we need to check if the  next step will get us beyond the screen so that's why we add an extra areaWidth for the comparison
	fild player.pX
	fild player.pWidth
	fadd
	fadd
	fild bufferdd5
	fcomi ST(0), ST(1)
	fstp ST(0)
	ja moverok
	;Coordinates too big, clamp to areaHeight
	mov eax, areaWidth
	sub eax, player.pWidth
	mov dword ptr [player.pX], eax
	jmp done
moverok:
	;Substract the extra areaWidth from the value
	fild player.pWidth
	fsubp
	frndint
	fist dword ptr [player.pX]
	jmp done
done:
endm

playerDraw macro player
local drawLoop, done
	mov ecx, player.pHeight
	mov bufferdd8, ecx
	mov eax, player.pY
	mov bufferdd7, eax
drawLoop:
	mov ecx, bufferdd8
	cmp ecx, 0
	je done
	drawLineHorizontalLength player.pX, bufferdd7, player.pWidth, player.color
	mov ecx, bufferdd8
	dec ecx
	mov bufferdd8, ecx
	mov eax, bufferdd7
	inc eax
	mov bufferdd7, eax
	jmp drawLoop
done:
	
endm


ballPlayerCollision macro ball, player
local popMin1, popMax1, popMin2, popMax2, nocol, done, dot1
	mov eax, 40ah
	finit
	fild player.pWidth
	fld1
	fld1
	fadd ; will have 2 and width on the stack, get half the width
	fdiv
	fst real8 ptr [bufferfd1] ; player center offset on the X axis
	fchs
	fstp real8 ptr [bufferfd2] ; player center offset on the X axis negated
	
	fild player.pX
	fld bufferfd1
	fadd
	fstp real8 ptr [bufferfd3] ; player center X
	
	fild ball.centerX
	fld bufferfd3
	fsub
	fstp real8 ptr [bufferfd4] ; difference between the two centers on the X axis
	
	

	fld bufferfd4
	fld bufferfd1
	fcomi ST(0), ST(1)
	jb popMin1
	fstp ST(0)
popMin1:
	fstp ST(1)
	;At this point we have min(value, max) in ST(0)
	fld bufferfd2
	fcomi ST(0), ST(1)
	ja popMax1
	fstp ST(0)
popMax1:
	fstp ST(1)
	
	;At this point we have the clamped point offset on the stack
	fld bufferfd3
	fadd ; At this point we have the closest point's X position on the players perimeter
	fst real8 ptr [bufferfd7] ; Store X coordinate on the perimeter
	fild ball.centerX
	fsub
	fstp real8 ptr [bufferfd8] ; X COORDINATE OF DIFFERENCE VECTOR

	
	finit
	fild player.pHeight
	fld1
	fld1
	fadd ; will have 2 and height on the stack, get half the height
	fdiv
	fst real8 ptr [bufferfd1] ; player center offset on the Y axis
	fchs
	fstp real8 ptr [bufferfd2] ; player center offset on the Y axis negated
	
	fild player.pY
	fld bufferfd1
	fadd
	fstp real8 ptr [bufferfd3] ; player center Y
	
	fild ball.centerY
	fld bufferfd3
	fsub
	fstp real8 ptr [bufferfd4] ; difference between the two centers on the Y axis
	
	

	fld bufferfd4
	fld bufferfd1
	fcomi ST(0), ST(1)
	jb popMin2
	fstp ST(0)
popMin2:
	fstp ST(1)
	;At this point we have min(value, max) in ST(0)
	fld bufferfd2
	fcomi ST(0), ST(1)
	ja popMax2
	fstp ST(0)
popMax2:
	fstp ST(1)
	
	;At this point we have the clamped point offset on the stack
	fld bufferfd3
	fadd ; At this point we have the closest point's Y position on the players perimeter
	fild ball.centerY
	fsub
	fstp real8 ptr [bufferfd9] ; Y COORDINATE OF DIFFERENCE VECTOR

	fld bufferfd8
	fld bufferfd8 
	fmul
	fld bufferfd9
	fld bufferfd9
	fmul
	fadd
	fsqrt
	fild ball.radius
	fcomi ST(0), ST(1)
	jb nocol
	mov eax, 21ah
	
	finit
	;Get distance in integer form
	fild ball.radius
	fld bufferfd9
	fsub
	fabs
	frndint
	fistp dword ptr [bufferdd6]
	mov eax, bufferdd6
	sub ball.centerY, eax
	
	finit
	fld ball.directionX
	fld ball.directionY
	fdiv
	fld bufferfd8
	fabs
	fmul
	fild ball.centerX
	fadd
	frndint
	fistp dword ptr [ball.centerX]
	
	; Calculate speed boost with (pointX - player.pX) * 2 / player.pWidth ; should give value between 0 and 1 then multiply by some factor
	finit
	fld bufferfd7
	fild player.pX
	fsub
	fld1
	fld1
	fadd
	fmul
	fild player.pWidth
	fdiv ; At this point we have a scalar of how far the ball is from the left side from 0 to 2
	fld1
	fsub
	fabs ; At this point we have a proper scalar for the speed bonus
	fld speedMultiplierDistance
	fmul
	fld ball.velocity
	fmul
	fld ball.velocity
	fadd
	fstp real8 ptr [ball.velocity]
	
	; Calculate collision type
	finit
	fld bufferfd8
	fldz 
	fcomi ST(0), ST(1)
	jne dot1
	; Continue with the case of top/bottom collision (although bottom will never happen)
	fld ball.directionY
	fchs
	fstp real8 ptr [ball.directionY]
	mov eax, 2
	
	; Apply slight angle variation based on distance
	finit 
	fld bufferfd7
	fild player.pX
	fsub
	fld1
	fld1
	fadd
	fmul
	fild player.pWidth
	fdiv ; At this point we have a scalar of how far the ball is from the left side from 0 to 2
	fld1
	fsub ; Now from -1 to 1
	fld angleMultiplier
	fmul
	fld ball.directionX
	fadd 
	fstp real8 ptr [ball.directionX]
	
	;Normalize vector after altering
	push offset ball.directionX
	push offset ball.directionY
	call normalizeVector
	add esp, 8
	
	jmp done
dot1:
	;If it's not a top/bottom collision we can assume it's either a corner collision or a left/right side collision
	; and in both cases we want to flip both components of the direction vector
	finit
	fld bufferfd9
	fldz
	fcomi ST(0), ST(1)
	fld ball.directionX
	fchs
	fstp real8 ptr [ball.directionX]
	fld ball.directionY
	fchs
	fstp real8 ptr [ball.directionY]
	
	; Apply slight angle variation based on distance
	finit 
	fld bufferfd7
	fild player.pX
	fsub
	fld1
	fld1
	fadd
	fmul
	fild player.pWidth
	fdiv ; At this point we have a scalar of how far the ball is from the left side from 0 to 2
	fld1
	fsub ; Now from -1 to 1
	fld angleMultiplier
	fmul
	fld ball.directionX
	fadd 
	fstp real8 ptr [ball.directionX]
	
	; Normalize after altering
	push offset ball.directionX
	push offset ball.directionY
	call normalizeVector
	add esp, 8
	
	mov eax, 3
nocol:
	mov eax, 0
done:
endm

targetDraw macro x, y, w, h, color
local lp,done
	
	mov ecx, y
	mov edx, h
	add edx, ecx ; edx has the final line y
lp:
	cmp ecx, edx
	jg done
	;drawLineHorizontalLength macro x, y, len, color
	mov bufferdd1, ecx
	pushad
	drawLineHorizontalLength x, bufferdd1, w, color
	popad
	inc ecx
	jmp lp

done:

endm

targetsDraw macro
local lp1, done1, skip1, lp2, done2, skip2, lp3, done3, skip3, lp4, done4, skip4
; Draw row 1
	mov ecx, 0
	mov esi, offset Row1
	
lp1:
	cmp ecx, rowTargetCount
	jge done1
	
	cmp Mask1[4*ecx], 1
	jne skip1
	
	pushad
	targetDraw [esi], [esi+4], [esi+8], [esi+12], [esi+16]
	popad
	
skip1:
	add esi, 20
	inc ecx
	jmp lp1
done1:

; Draw row 2
	mov ecx, 0
	mov esi, offset Row2
	
lp2:
	cmp ecx, rowTargetCount
	jge done2
	
	cmp Mask2[4*ecx], 1
	jne skip2
	
	pushad
	targetDraw [esi], [esi+4], [esi+8], [esi+12], [esi+16]
	popad
	
skip2:
	add esi, 20
	inc ecx
	jmp lp2
done2:

; Draw row 3
	mov ecx, 0
	mov esi, offset Row3
	
lp3:
	cmp ecx, rowTargetCount
	jge done3
	
	cmp Mask3[4*ecx], 1
	jne skip3
	
	pushad
	targetDraw [esi], [esi+4], [esi+8], [esi+12], [esi+16]
	popad

skip3:
	add esi, 20
	inc ecx
	jmp lp3
done3:

; Draw row 4
	mov ecx, 0
	mov esi, offset Row4
	
lp4:
	cmp ecx, rowTargetCount
	jge done4
	
	cmp Mask4[4*ecx], 1
	jne skip4
	
	pushad
	targetDraw [esi], [esi+4], [esi+8], [esi+12], [esi+16]
	popad
	
skip4:
	add esi, 20
	inc ecx
	jmp lp4
done4:
	
endm


; Target struct
	; tX dd ?
	; tY dd ?
	; tWidth dd ?
	; tHeight dd ?
	; color dd ?
; Target ends

ballTargetCollision macro ball, x, y, w, h
local popMin1, popMax1, popMin2, popMax2, nocol, done, dot1, handle1, handle2, handle3, handle4, dot2, dot3, dot4, dot5, dot6, inter1, inter2, inter3, inter4,colhan, checkDrop, nodrop, growbonus, shrinkbonus, spdupbonus, spddownbonus, splitbonus
	mov ebx, 0
	finit
	fild w
	fld1
	fld1
	fadd ; will have 2 and width on the stack, get half the width
	fdiv
	fst real8 ptr [bufferfd1] ; player center offset on the X axis
	fchs
	fstp real8 ptr [bufferfd2] ; player center offset on the X axis negated
	
	fild x
	fld bufferfd1
	fadd
	fstp real8 ptr [bufferfd3] ; player center X
	
	fild ball.centerX
	fld bufferfd3
	fsub
	fstp real8 ptr [bufferfd4] ; difference between the two centers on the X axis
	
	
	fld bufferfd4
	fld bufferfd1
	fcomi ST(0), ST(1)
	jb popMin1
	fstp ST(0)
popMin1:
	fstp ST(1)
	;At this point we have min(value, max) in ST(0)
	fld bufferfd2
	fcomi ST(0), ST(1)
	ja popMax1
	fstp ST(0)
popMax1:
	fstp ST(1)
	
	;At this point we have the clamped point offset on the stack
	fld bufferfd3
	fadd ; At this point we have the closest point's X position on the players perimeter
	fst real8 ptr [bufferfd7] ; Store X coordinate on the perimeter
	fild ball.centerX
	fsub
	fstp real8 ptr [bufferfd8] ; X COORDINATE OF DIFFERENCE VECTOR

	
	finit
	fild h
	fld1
	fld1
	fadd ; will have 2 and height on the stack, get half the height
	fdiv
	fst real8 ptr [bufferfd1] ; player center offset on the Y axis
	fchs
	fstp real8 ptr [bufferfd2] ; player center offset on the Y axis negated
	
	fild y
	fld bufferfd1
	fadd
	fstp real8 ptr [bufferfd3] ; player center Y
	
	fild ball.centerY
	fld bufferfd3
	fsub
	fstp real8 ptr [bufferfd4] ; difference between the two centers on the Y axis
	
	

	fld bufferfd4
	fld bufferfd1
	fcomi ST(0), ST(1)
	jb popMin2
	fstp ST(0)
popMin2:
	fstp ST(1)
	;At this point we have min(value, max) in ST(0)
	fld bufferfd2
	fcomi ST(0), ST(1)
	ja popMax2
	fstp ST(0)
popMax2:
	fstp ST(1)
	
	;At this point we have the clamped point offset on the stack
	fld bufferfd3
	fadd ; At this point we have the closest point's Y position on the players perimeter
	fild ball.centerY
	fsub
	fstp real8 ptr [bufferfd9] ; Y COORDINATE OF DIFFERENCE VECTOR

	finit
	fld bufferfd8
	fld bufferfd8 
	fmul
	fld bufferfd9
	fld bufferfd9
	fmul
	fadd
	fsqrt
	fild ball.radius
	;Compare distance vector length to radius
	fcomi ST(0), ST(1)
	jb nocol
	
	inc targetDestroyedCounter
	
	;Determine if game is won
	mov eax, rowTargetCount
	shl eax, 2 ; multiply by 4 (4 rows)
	cmp targetDestroyedCounter, eax
	jb checkDrop
	;Game won, set event timer and flag
	mov isWin, 1
	mov eax, counter
	mov counterBuffer, eax

checkDrop:
	pushad
	;Determine if a bonus is to be dropped, 10% chance
	rdtsc ; into edx, eax
	xor edx, edx
	mov ebx, 10
	div ebx
	;eax has a value
	cmp edx, 3

	jg nodrop
	
	;Drop something
	rdtsc
	xor edx, edx
	mov ebx, 16
	div  ebx
	
	;0 - 3 speed up
	; 4 - 6 shrink
	; 7 - 10 grow
	; 11 - 13 speed down
	; 14 - 15 split ball
	
	cmp edx, 3
	jg shrinkbonus
	;speedup bonus here
	mov eax, w
	shr eax, 1
	add eax, x
	mov BonusSpeedUp.centerX, eax
	mov eax, y
	add eax, h
	add eax, 10
	mov BonusSpeedUp.centerY, eax
	mov bonusSpeedUpVisible, 1
	
	jmp nodrop

shrinkbonus:
	cmp edx, 6
	jg growbonus
	
	mov eax, w
	shr eax, 1
	add eax, x
	mov BonusShrink.centerX, eax
	mov eax, y
	add eax, h
	add eax, 10
	mov BonusShrink.centerY, eax
	mov bonusShrinkVisible, 1
	
	jmp nodrop

growbonus:
	cmp edx, 10
	jg spddownbonus
	
	mov eax, w
	shr eax, 1
	add eax, x
	mov BonusGrow.centerX, eax
	mov eax, y
	add eax, h
	add eax, 10
	mov BonusGrow.centerY, eax
	mov bonusGrowVisible, 1
	
	jmp nodrop

spddownbonus:
	cmp edx, 13
	jg splitbonus
	
	mov eax, w
	shr eax, 1
	add eax, x
	mov BonusSpeedDown.centerX, eax
	mov eax, y
	add eax, h
	add eax, 10
	mov BonusSpeedDown.centerY, eax
	mov bonusSpeedDownVisible, 1
	
	jmp nodrop
	
splitbonus:
	mov eax, w
	shr eax, 1
	add eax, x
	mov BonusSplitBall.centerX, eax
	mov eax, y
	add eax, h
	add eax, 10
	mov BonusSplitBall.centerY, eax
	mov bonusSplitBallVisible, 1
	jmp nodrop

nodrop:
	popad
	
colhan:
	
	finit
	;Collision handling
	mov eax, 111ah
	mov ebx, 1
	finit
	fld bufferfd9
	fld bufferfd8
	fld bufferfd9
	fchs
	fld bufferfd8
	fchs

	mov eax, 4 ;left
	fcomi ST(0), ST(1)
	ja dot1
	fstp ST(0)
	mov eax, 3 ; bottom
	jmp dot2
dot1:
	fstp ST(1) 
dot2:
	fcomi ST(0), ST(1)
	ja dot3
	fstp ST(0)
	mov eax, 2 ; right
	jmp dot4
dot3:
	fstp ST(1)
dot4:
	fcomi ST(0), ST(1)
	ja dot5
	fstp ST(0)
	mov eax, 1 ; up
	jmp dot6
dot5:
	fstp ST(1)
dot6:

	cmp eax, 4 ; left
	jne handle1
	
	fld ball.directionX
	fldz
	fcomi ST(0), ST(1)
	ja inter1
	
inter2:
	pushad
	push offset lft
	call printf
	add esp, 4
	popad
	
	finit
	fld ball.directionX
	fchs
	fstp real8 ptr [ball.directionX]
	jmp done
handle1:
	cmp eax, 3 ; bottom
	jne handle2
	
	fld ball.directionY
	fldz
	fcomi ST(0), ST(1)
	jb inter4
	
inter3:
	pushad
	push offset btm
	call printf
	add esp, 4
	popad
	

	
	fld ball.directionY
	fchs
	fstp real8 ptr [ball.directionY]
	jmp done
handle2:
	cmp eax, 2 ; right
	jne handle3
	
	fld ball.directionX
	fldz
	fcomi ST(0), ST(1)
	jb inter2
	
inter1:
	pushad
	push offset rigt
	call printf
	add esp, 4
	popad
	fld ball.directionX
	fchs
	fstp real8 ptr [ball.directionX]
	jmp done
handle3:
	;;;;;;;;;;;;;eax must be 1, top
	
	fld ball.directionY
	fldz
	fcomi ST(0), ST(1)
	ja inter3
	
inter4:
	pushad
	push offset top
	call printf
	add esp, 4
	popad
	fld ball.directionY
	fchs
	fstp real8 ptr [ball.directionY]
	jmp done	
	
nocol:
	mov ebx, 0
done:
endm


ballTargetsCollision macro  ball
local lp1, done1, skip1, lp2, done2, skip2, lp3, done3, skip3, lp4, done4, skip4, done
 
	mov esi, offset Row1
	mov ecx, 0
lp1:
	cmp ecx, rowTargetCount
	jge done1
	
	cmp Mask1[4*ecx], 1
	jne skip1
	mov eax, 70ah
	mov ebx, [esi]
	mov bufferdd9, ebx
	mov ebx, [esi+4]
	mov bufferdd10, ebx
	mov ebx, [esi+8]
	mov bufferdd11, ebx
	mov ebx, [esi+12]
	mov bufferdd12, ebx
	mov ebx, 0
	ballTargetCollision ball, bufferdd9, bufferdd10, bufferdd11, bufferdd12
	cmp ebx, 1
	jne skip1
	mov Mask1[4*ecx], 0
	jmp done
	
skip1:
	add esi, 20
	inc ecx
	jmp lp1
done1:

	mov esi, offset Row2
	mov ecx, 0
lp2:
	cmp ecx, rowTargetCount
	jge done2
	
	cmp Mask2[4*ecx], 1
	jne skip2
	mov ebx, [esi]
	mov bufferdd9, ebx
	mov ebx, [esi+4]
	mov bufferdd10, ebx
	mov ebx, [esi+8]
	mov bufferdd11, ebx
	mov ebx, [esi+12]
	mov bufferdd12, ebx
	mov ebx, 0
	ballTargetCollision ball, bufferdd9, bufferdd10, bufferdd11, bufferdd12
	cmp ebx, 1
	jne skip2
	mov Mask2[4*ecx], 0
	jmp done
skip2:
	add esi, 20
	inc ecx
	jmp lp2
done2:

	mov esi, offset Row3
	mov ecx, 0
lp3:
	cmp ecx, rowTargetCount
	jge done3
	
	cmp Mask3[4*ecx], 1
	jne skip3
	mov ebx, [esi]
	mov bufferdd9, ebx
	mov ebx, [esi+4]
	mov bufferdd10, ebx
	mov ebx, [esi+8]
	mov bufferdd11, ebx
	mov ebx, [esi+12]
	mov bufferdd12, ebx
	mov ebx, 0
	ballTargetCollision ball, bufferdd9, bufferdd10, bufferdd11, bufferdd12
	cmp ebx, 1
	jne skip3
	mov Mask3[4*ecx], 0
	jmp done
	
skip3:
	add esi, 20
	inc ecx
	jmp lp3
done3:

	mov esi, offset Row4
	mov ecx, 0
lp4:
	cmp ecx, rowTargetCount
	jge done4
	
	cmp Mask4[4*ecx], 1
	jne skip4
	mov ebx, [esi]
	mov bufferdd9, ebx
	mov ebx, [esi+4]
	mov bufferdd10, ebx
	mov ebx, [esi+8]
	mov bufferdd11, ebx
	mov ebx, [esi+12]
	mov bufferdd12, ebx
	mov ebx, 0
	ballTargetCollision ball, bufferdd9, bufferdd10, bufferdd11, bufferdd12
	cmp ebx, 1
	jne skip4
	mov Mask4[4*ecx], 0
	jmp done
	
skip4:
	add esi, 20
	inc ecx
	jmp lp4
done4:

done:
endm

bonusUpdate proc
	push ebp
	mov ebp, esp
	pushad
	finit
	; They don't travel side to side so we don't update X coord, useless
	
	cmp bonusGrowVisible, 1
	jne shrinkvis
	;grow here
	fild BonusGrow.centerY
	fld BonusGrow.directionY
	fadd
	frndint
	fistp dword ptr [BonusGrow.centerY]
	
	ballDraw BonusGrow, 4dfa7ch
	

shrinkvis:
	cmp bonusShrinkVisible, 1
	jne spdupvis
	fild BonusShrink.centerY
	fld BonusShrink.directionY
	fadd
	frndint
	fistp dword ptr [BonusShrink.centerY]
	
	ballDraw BonusShrink, 174d25h

spdupvis:
	cmp bonusSpeedUpVisible, 1
	jne spddwnvis
	fild BonusSpeedUp.centerY
	fld BonusSpeedUp.directionY
	fadd
	frndint
	fistp dword ptr [BonusSpeedUp.centerY]
	
	ballDraw BonusSpeedUp, 0ebe544h
	
spddwnvis:
	cmp bonusSpeedDownVisible, 1
	jne splitvis
	fild BonusSpeedDown.centerY
	fld BonusSpeedDown.directionY
	fadd
	frndint
	fistp dword ptr [BonusSpeedDown.centerY]
	
	ballDraw BonusSpeedDown, 878427h
	
splitvis:
	cmp bonusSplitBallVisible, 1
	jne donevis
	fild BonusSplitBall.centerY
	fld BonusSplitBall.directionY
	fadd
	frndint
	fistp dword ptr [BonusSplitBall.centerY]
	
	ballDraw BonusSplitBall, 0ea18edh
	
donevis:
	popad
	mov esp, ebp
	pop ebp
	ret
bonusUpdate endp

bonusCollision macro player
local done, growoutbnd, shrinkoutbnd, spdupoutbnd, spddwnoutbnd, ballsplitoutbnd, shk, spu, spd, spl

	;Grow bonus collision
	mov eax, player.pY
	mov ebx, BonusGrow.centerY
	add ebx, BonusGrow.radius
	cmp eax, ebx
	jg shk
	
	mov eax, player.pX
	mov ebx, BonusGrow.centerX
	add ebx, BonusGrow.radius
	cmp eax, ebx
	jg growoutbnd
	
	mov eax, player.pX
	add eax, player.pWidth
	mov ebx, BonusGrow.centerX
	sub ebx, BonusGrow.radius
	cmp eax, ebx
	jb growoutbnd
	
	;Collision, set active
	mov bonusGrowActive, 1
	mov edx, counter
	mov bonusGrowBuffer, edx
	
growoutbnd:
	mov bonusGrowVisible, 0
	mov BonusGrow.centerX, 0
	mov BonusGrow.centerY, 0
	
shk:
	;Shrink bonus collision
	mov eax, player.pY
	mov ebx, BonusShrink.centerY
	add ebx, BonusShrink.radius
	cmp eax, ebx
	jg spu
	
	mov eax, player.pX
	mov ebx, BonusShrink.centerX
	add ebx, BonusShrink.radius
	cmp eax, ebx
	jg shrinkoutbnd
	
	mov eax, player.pX
	add eax, player.pWidth
	mov ebx, BonusShrink.centerX
	sub ebx, BonusShrink.radius
	cmp eax, ebx
	jb shrinkoutbnd
	
	;Collision, set active
	mov bonusShrinkActive, 1
	mov edx, counter
	mov bonusShrinkBuffer, edx

shrinkoutbnd:
	mov bonusShrinkVisible, 0
	mov BonusShrink.centerX, 0
	mov BonusShrink.centerY, 0
	
spu:
	;Speed Up
	mov eax, player.pY
	mov ebx, BonusSpeedUp.centerY
	add ebx, BonusSpeedUp.radius
	cmp eax, ebx
	jg spd
	
	mov eax, player.pX
	mov ebx, BonusSpeedUp.centerX
	add ebx, BonusSpeedUp.radius
	cmp eax, ebx
	jg spdupoutbnd
	
	mov eax, player.pX
	add eax, player.pWidth
	mov ebx, BonusSpeedUp.centerX
	sub ebx, BonusSpeedUp.radius
	cmp eax, ebx
	jb spdupoutbnd
	
	;Collision, set active
	mov bonusSpeedUpActive, 1
	mov edx, counter
	mov bonusSpeedUpBuffer, edx
	
spdupoutbnd:
	mov bonusSpeedUpVisible, 0
	mov BonusSpeedUp.centerX, 0
	mov BonusSpeedUp.centerY, 0
	
spd:
	;Speed down
	mov eax, player.pY
	mov ebx, BonusSpeedDown.centerY
	add ebx, BonusSpeedDown.radius
	cmp eax, ebx
	jg spl
	
	mov eax, player.pX
	mov ebx, BonusSpeedDown.centerX
	add ebx, BonusSpeedDown.radius
	cmp eax, ebx
	jg spddwnoutbnd
	
	mov eax, player.pX
	add eax, player.pWidth
	mov ebx, BonusSpeedDown.centerX
	sub ebx, BonusSpeedDown.radius
	cmp eax, ebx
	jb spddwnoutbnd
	
	;Collision, set active
	mov bonusSpeedDownActive, 1
	mov edx, counter
	mov bonusSpeedDownBuffer, edx

spddwnoutbnd:
	mov bonusSpeedDownVisible, 0
	mov BonusSpeedDown.centerX, 0
	mov BonusSpeedDown.centerY, 0
	
spl:
	;Split Ball
	mov eax, player.pY
	mov ebx, BonusSplitBall.centerY
	add ebx, BonusSplitBall.radius
	cmp eax, ebx
	jg done
	
	mov eax, player.pX
	mov ebx, BonusSplitBall.centerX
	add ebx, BonusSplitBall.radius
	cmp eax, ebx
	jg ballsplitoutbnd
	
	mov eax, player.pX
	add eax, player.pWidth
	mov ebx, BonusSplitBall.centerX
	sub ebx, BonusSplitBall.radius
	cmp eax, ebx
	jb ballsplitoutbnd
	
	;Collision, set active
	mov bonusSplitBallActive, 1
	mov edx, counter
	mov bonusSplitBallBuffer, edx

ballsplitoutbnd:
	mov bonusSplitBallVisible, 0
	mov BonusSplitBall.centerX, 0
	mov BonusSplitBall.centerY, 0
	
	
done:
endm

bonusBallCheckBounds macro ball
local notop, noleft, done, noloss
	;Check loss condition 
	mov eax, ball.centerY
	add eax, ball.radius
	add eax, ball.radius
	cmp eax, areaHeight
	jl noloss
	mov ball.centerX, 0
	mov ball.centerY, 0
	mov ball.radius, 0
	finit 
	fldz
	fstp real8 ptr [ball.directionX]
	fldz
	fstp real8 ptr [ball.directionY]
	fldz
	fstp real8 ptr [ball.velocity]
	jmp done
noloss:
	;Check top collision
	mov eax, ball.centerY
	sub eax, ball.radius
	cmp eax, 0
	jg notop	
	
	; Reposition ball so it's not outside
	mov ball.centerY, 10
	finit 
	fld ball.directionX
	fld ball.directionY
	fdiv
	mov bufferdd1, eax
	fild bufferdd1
	fabs
	fmul
	fild ball.centerX
	fadd
	frndint
	fistp dword ptr [ball.centerX]
	
	
	;flip y direction 
	finit
	fld ball.directionY
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	;frndint
	fstp real8 ptr [ball.directionY]
	;mov eax, bufferdd1
	;mov real8 ptr [ball.directionY], eax
	
notop:
	;Check left side collision
	mov eax, ball.centerX
	sub eax, ball.radius
	cmp eax, 0 ; Check left side
	jg noleft
	
	; Reposition ball so it's not outside
	mov ball.centerX, 11
	finit 
	fld ball.directionY
	fld ball.directionX
	fdiv
	mov bufferdd1, eax
	fild bufferdd1
	fabs
	fmul
	fild ball.centerY
	fadd
	frndint
	fistp dword ptr [ball.centerY]	

	;flip x direction
	finit
	fld ball.directionX
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	;frndint
	fstp real8 ptr [ball.directionX]
	;mov eax, bufferdd1
	;mov real8 ptr [ball.directionX], eax
noleft:
	;Check right side collision
	mov eax, ball.centerX
	add eax, ball.radius
	cmp eax, areaWidth
	jl done
	
	mov ebx, areaWidth
	sub ebx, 11
	mov ball.centerX, ebx
	finit 
	fld ball.directionY
	fld ball.directionX
	fdiv
	mov ebx, areaWidth
	sub ebx, ball.radius
	sub ebx, ball.centerX
	mov bufferdd1, ebx
	fild bufferdd1
	fabs
	fmul
	fild ball.centerY
	fadd
	frndint
	fistp dword ptr [ball.centerY]
	
	finit
	fld ball.directionX
	mov bufferdd1, -1
	fild bufferdd1
	fmul
	;frndint
	fstp real8 ptr [ball.directionX]
	;mov eax, bufferdd1
	;mov real8 ptr [ball.directionX], eax
	
done:
endm

bonusTimerGrow proc
	push ebp
	mov ebp, esp
	pushad
	
	mov eax, counter
	sub eax, bonusGrowBuffer
	cmp eax, bonusDuration
	jg nogrow
	
	cmp eax, 400 
	jb noblink
	
	push eax
	mov ebx, 50
	div ebx
	pop eax
	cmp edx, 25
	jbe normal
	mov Player1.color, 336148h
	jmp noblink
normal:
	mov Player1.color, 4c7ecfh
	
noblink:
	
	mov eax, bonusShrinkActive
	cmp eax, 1
	jne noconflict
	
	mov Player1.pWidth, 80
	jmp done
noconflict:
	mov Player1.pWidth, 110
	;sub Player1.pX, 15
	jmp done
		
nogrow:
	mov bonusGrowActive, 0
	sub Player1.pWidth, 30
	;add Player1.pX, 15
	mov bonusGrowBuffer, 0
done:
	popad
	mov esp, ebp
	pop ebp
	ret
bonusTimerGrow endp

bonusTimerShrink proc
	push ebp
	mov ebp, esp
	pushad
	
	mov eax, counter
	sub eax, bonusShrinkBuffer
	cmp eax, bonusDuration
	jg nogrow
	
	cmp eax, 400 
	jb noblink
	
	push eax
	mov ebx, 50
	div ebx
	pop eax
	cmp edx, 25
	jbe normal
	mov Player1.color, 336148h
	jmp noblink
normal:
	mov Player1.color, 4c7ecfh
	
noblink:
	
	mov eax, bonusGrowActive
	cmp eax, 1
	jne noconflict
	
	mov Player1.pWidth, 80
	jmp done
noconflict:
	mov Player1.pWidth, 50
	;add Player1.pX, 15 ;it's in a loop, uncool
	jmp done
		
nogrow:
	mov bonusShrinkActive, 0
	add Player1.pWidth, 30
	;sub Player1.pX, 15
	mov bonusShrinkBuffer, 0
done:
	popad
	mov esp, ebp
	pop ebp
	ret
bonusTimerShrink endp

bonusTimerSpeedUp proc
	push ebp
	mov ebp, esp
	pushad
	
	mov eax, counter
	sub eax, bonusSpeedUpBuffer
	cmp eax, bonusDuration
	jg nogrow
	
	cmp eax, 400 
	jb noblink
	
	push eax
	mov ebx, 50
	div ebx
	pop eax
	cmp edx, 25
	jbe normal
	mov Player1.color, 696916h
	jmp noblink
normal:
	mov Player1.color, 4c7ecfh
	
noblink:
	
	mov eax, bonusSpeedDownActive
	cmp eax, 1
	jne noconflict
	
	finit
	fld playerBaseVelocity
	fstp real8 ptr [Player1.velocity]
	
noconflict:
	finit
	fld playerMaxVelocity
	fstp real8 ptr [Player1.velocity]
	jmp done
		
nogrow:
	mov bonusSpeedUpActive, 0
	finit
	; Need a 5
	fld1
	fld1
	fadd
	fld1
	fadd
	fld1
	fadd
	fld1
	fadd
	fld Player1.velocity
	fsub
	fstp real8 ptr [Player1.velocity]
	mov bonusSpeedUpBuffer, 0
done:
	popad
	mov esp, ebp
	pop ebp
	ret
bonusTimerSpeedUp endp

bonusTimerSpeedDown proc
	push ebp
	mov ebp, esp
	pushad
	
	mov eax, counter
	sub eax, bonusSpeedDownBuffer
	cmp eax, bonusDuration
	jg nogrow
	
	cmp eax, 400 
	jb noblink
	
	push eax
	mov ebx, 50
	div ebx
	pop eax
	cmp edx, 25
	jbe normal
	mov Player1.color, 696916h
	jmp noblink
normal:
	mov Player1.color, 4c7ecfh
	
noblink:
	
	mov eax, bonusSpeedUpActive
	cmp eax, 1
	jne noconflict
	
	finit
	fld playerBaseVelocity
	fstp real8 ptr [Player1.velocity]
	
noconflict:
	finit
	fld playerMinVelocity
	fstp real8 ptr [Player1.velocity]
	jmp done
		
nogrow:
	mov bonusSpeedDownActive, 0
	finit
	fld NINEFD
	fld1
	fsub
	fld Player1.velocity
	fadd
	fstp real8 ptr [Player1.velocity]
	mov bonusSpeedDownBuffer, 0
done:
	popad
	mov esp, ebp
	pop ebp
	ret
bonusTimerSpeedDown endp

bonusTimerSplitBall proc
	push ebp
	mov ebp, esp
	pushad
	
	mov eax, counter
	sub eax, bonusSplitBallBuffer
	cmp eax, bonusDuration
	jg nogrow
	
	cmp eax, 400 
	jb noblink
	
	push eax
	mov ebx, 50
	div ebx
	pop eax
	cmp edx, 25
	jbe normal
	mov Player1.color, 962991h
	jmp noblink
normal:
	mov Player1.color, 4c7ecfh
	
noblink:
	; COPY GAMEBALL DATA AND CHANGE THE DIRECTION VECTOR SLIGHTLY
	mov eax, counter
	mov ebx, bonusSplitBallBuffer
	add ebx, 1
	cmp eax, ebx
	jne upds
		
	mov eax, GameBall.centerX
	mov GameBallS1.centerX, eax
	mov eax, GameBall.centerY
	mov GameBallS1.centerY, eax
	mov eax, GameBall.radius
	mov GameBallS1.radius, eax
	finit 
	fld GameBall.directionX
	fld bonusSplitBallAngleAdd
	fadd
	fld bonusSplitBallAngleMultiplier
	fmul
	fstp real8 ptr [GameBallS1.directionX]
	fld GameBall.directionY
	fstp real8 ptr [GameBallS1.directionY]
	fld GameBall.velocity
	fstp real8 ptr [GameBallS1.velocity]
	
	push offset GameBallS1.directionX
	push offset GameBallS1.directionY
	call normalizeVector
	add esp, 8
	
	mov eax, GameBall.centerX
	mov GameBallS2.centerX, eax
	mov eax, GameBall.centerY
	mov GameBallS2.centerY, eax
	mov eax, GameBall.radius
	mov GameBallS2.radius, eax
	finit 
	fld GameBall.directionX
	fld bonusSplitBallAngleAdd
	fsub
	fld bonusSplitBallAngleMultiplier
	fmul
	fstp real8 ptr [GameBallS2.directionX]
	fld GameBall.directionY
	fstp real8 ptr [GameBallS2.directionY]
	fld GameBall.velocity
	fstp real8 ptr [GameBallS2.velocity]
	
	push offset GameBallS2.directionX
	push offset GameBallS2.directionY
	call normalizeVector
	add esp, 8
	
	
upds:
	pushad
	ballUpdate GameBallS1
	bonusBallCheckBounds GameBallS1
	ballTargetsCollision GameBallS1
	ballPlayerCollision GameBallS1, Player1
	popad
	ballUpdate GameBallS2
	bonusBallCheckBounds GameBallS2
	ballTargetsCollision GameBallS2
	ballPlayerCollision GameBallS2, Player1
	ballDraw GameBallS1, 878787h
	ballDraw GameBallS2, 878787h
	jmp done
		
nogrow:
	mov bonusSplitBallActive, 0
	mov bonusSplitBallBuffer, 0
	mov GameBallS1.centerX, 0
	mov GameBallS1.centerY, 0
	mov GameBallS1.radius, 0
	finit 
	fldz
	fstp real8 ptr [GameBallS1.directionX]
	fldz
	fstp real8 ptr [GameBallS1.directionY]
	fldz
	fstp real8 ptr [GameBallS1.velocity]
	mov GameBallS2.centerX, 0
	mov GameBallS2.centerY, 0
	mov GameBallS2.radius, 0
	finit 
	fldz
	fstp real8 ptr [GameBallS2.directionX]
	fldz
	fstp real8 ptr [GameBallS2.directionY]
	fldz
	fstp real8 ptr [GameBallS2.velocity]
	
done:
	popad
	mov esp, ebp
	pop ebp
	ret
bonusTimerSplitBall endp



; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click, 3 - s-a apasat o tasta)
; arg2 - x (in cazul apasarii unei taste, x contine codul ascii al tastei care a fost apasata)
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 3
	jz keyEvent ; key event
	cmp eax, 1
	jz clickEvent ; if clicked
	cmp eax, 2
	jz timerEvent ; no action, game loop

	;begin init
	mov eax, areaWidth
	mov ebx, areaHeight
	mul ebx
	shl eax, 2
	push eax
	push 0
	push area
	call memset
	add esp, 12

	push offset GameBall.directionX
	push offset GameBall.directionY
	call normalizeVector
	add esp, 8
	
	jmp afisare_litere
	
	
keyEvent:
	;Check if space is pressed (to start a game)
	mov eax, 20h
	cmp [ebp+arg2], eax
	jne playerUpd
	mov isGame, 1
playerUpd:
	playerUpdateVelocity Player1, [ebp+arg2]
	mov ebx, [ebp+arg2]
	cmp ebx, 25h
	jne interm
	playerUpdatePosition Player1
	jmp afisare_litere
interm:
	mov ebx, [ebp+arg2]
	cmp ebx, 27h
	jne clickEvent
	playerUpdatePosition Player1
	jmp afisare_litere
	
clickEvent:
	
timerEvent:
	inc counter
	
	mov eax, areaWidth
	mov ebx, areaHeight
	mul ebx
	shl eax, 2
	push eax
	push 0
	push area
	call memset
	add esp, 12
	
	;Check for win condition and stay in event for a while before going to new game event
	mov eax, isWin
	cmp eax, 1
	jne checkLoss
	
	mov eax, counter
	sub eax, counterBuffer
	cmp eax, eventDuration
	jge winFinish
	
	xor edx, edx
	mov eax, counter
	mov ecx, timerDuration
	div ecx
	mov ebx, timerDuration
	shr ebx, 1
	cmp edx, ebx
	jbe afisare_litere
	
	; YOU WON
	
	;draw text
	drawText 'Y', area, areaWidth/2-35, areaHeight/2-10
	drawText 'O', area, areaWidth/2-25, areaHeight/2-10
	drawText 'U', area, areaWidth/2-15, areaHeight/2-10
	drawText ' ', area, areaWidth/2-5, areaHeight/2-10
	drawText 'W', area, areaWidth/2+5, areaHeight/2-10
	drawText 'O', area, areaWidth/2+15, areaHeight/2-10
	drawText 'N', area, areaWidth/2+25, areaHeight/2-10
	
	jmp afisare_litere
	
winFinish:
	mov isLoss, 0
	mov isGame, 0
	mov isWin, 0
	mov bonusGrowActive, 0
	mov bonusShrinkActive, 0
	mov bonusSpeedUpActive, 0
	mov bonusSpeedDownActive, 0
	mov bonusSplitBallActive, 0
	call bonusTimerGrow
	call bonusTimerShrink
	call bonusTimerSpeedDown
	call bonusTimerSpeedUp
	call bonusTimerSplitBall
	finit
	fld playerBaseVelocity
	fstp real8 ptr [Player1.velocity]
	mov Player1.pWidth, 80
	mov Player1.color, 4c7ecfh
	
checkLoss:
	
	;Check for loss condition and stay in event for a while before going to new game event`
	mov eax, isLoss
	cmp eax, 1
	jne earlyTargetDraw
		
	mov eax, counter
	sub eax, counterBuffer
	cmp eax, eventDuration
	jge lossFinish
	;       YOU LOST
	; TARGETS DESTROYED XX
	
	xor edx, edx
	mov eax, counter
	mov ecx, timerDuration
	div ecx
	mov ebx, timerDuration
	shr ebx, 1
	cmp edx, ebx
	jbe afisare_litere

	drawText 'Y', area, areaWidth/2-40, areaHeight/2-20
	drawText 'O', area, areaWidth/2-30, areaHeight/2-20
	drawText 'U', area, areaWidth/2-20, areaHeight/2-20
	drawText ' ', area, areaWidth/2-10, areaHeight/2-20
	drawText 'L', area, areaWidth/2, areaHeight/2-20
	drawText 'O', area, areaWidth/2+10, areaHeight/2-20
	drawText 'S', area, areaWidth/2+20, areaHeight/2-20
	drawText 'T', area, areaWidth/2+30, areaHeight/2-20
	
	drawText 'T', area, areaWidth/2-100, areaHeight/2
	drawText 'A', area, areaWidth/2-90, areaHeight/2
	drawText 'R', area, areaWidth/2-80, areaHeight/2
	drawText 'G', area, areaWidth/2-70, areaHeight/2
	drawText 'E', area, areaWidth/2-60, areaHeight/2
	drawText 'T', area, areaWidth/2-50, areaHeight/2
	drawText 'S', area, areaWidth/2-40, areaHeight/2
	drawText ' ', area, areaWidth/2-30, areaHeight/2
	drawText 'D', area, areaWidth/2-20, areaHeight/2
	drawText 'E', area, areaWidth/2-10, areaHeight/2
	drawText 'S', area, areaWidth/2, areaHeight/2
	drawText 'T', area, areaWidth/2+10, areaHeight/2
	drawText 'R', area, areaWidth/2+20, areaHeight/2
	drawText 'O', area, areaWidth/2+30, areaHeight/2
	drawText 'Y', area, areaWidth/2+40, areaHeight/2
	drawText 'E', area, areaWidth/2+50, areaHeight/2
	drawText 'D', area, areaWidth/2+60, areaHeight/2
	drawText ' ', area, areaWidth/2+70, areaHeight/2
	
	mov ebx, 10
	mov eax, targetDestroyedCounter

	mov edx, 0
	div ebx
	add edx, '0'
	drawText edx, area, areaWidth/2+90, areaHeight/2

	mov edx, 0
	div ebx
	add edx, '0'
	drawText edx, area, areaWidth/2+80, areaHeight/2

	jmp afisare_litere
	
lossFinish:
	mov isLoss, 0
	mov isGame, 0
	mov isWin, 0
	mov bonusGrowActive, 0
	mov bonusShrinkActive, 0
	mov bonusSpeedUpActive, 0
	mov bonusSpeedDownActive, 0
	mov bonusSplitBallActive, 0
	call bonusTimerGrow
	call bonusTimerShrink
	call bonusTimerSpeedDown
	call bonusTimerSpeedUp
	call bonusTimerSplitBall
	finit
	fld playerBaseVelocity
	fstp real8 ptr [Player1.velocity]
	mov Player1.pWidth, 80
	mov Player1.color, 4c7ecfh
	
	
earlyTargetDraw:
	; Draw early due to collision deleting targets
	targetsDraw
	
	;Check if we're in a game; if not, ball goes on the pad and waits input to start
	mov eax, isGame
	cmp eax, 0
	jne ingame
	mov targetDestroyedCounter, 0
	
	xor edx, edx
	mov eax, counter
	mov ecx, timerDuration
	div ecx
	mov ebx, timerDuration
	shr ebx, 1
	cmp edx, ebx
	jbe ballInit
	drawText 'P', area, areaWidth/2-55, areaHeight/2-20
	drawText 'R', area, areaWidth/2-45, areaHeight/2-20
	drawText 'E', area, areaWidth/2-35, areaHeight/2-20
	drawText 'S', area, areaWidth/2-25, areaHeight/2-20
	drawText 'S', area, areaWidth/2-15, areaHeight/2-20
	drawText ' ', area, areaWidth/2-5, areaHeight/2-20
	drawText 'S', area, areaWidth/2+5, areaHeight/2-20
	drawText 'P', area, areaWidth/2+15, areaHeight/2-20
	drawText 'A', area, areaWidth/2+25, areaHeight/2-20
	drawText 'C', area, areaWidth/2+35, areaHeight/2-20
	drawText 'E', area, areaWidth/2+45, areaHeight/2-20
	;Offset 15px for 2nd row
	drawText 'T', area, areaWidth/2-40, areaHeight/2
	drawText 'O', area, areaWidth/2-30, areaHeight/2
	drawText ' ', area, areaWidth/2-20, areaHeight/2
	drawText 'S', area, areaWidth/2-10, areaHeight/2
	drawText 'T', area, areaWidth/2, areaHeight/2
	drawText 'A', area, areaWidth/2+10, areaHeight/2
	drawText 'R', area, areaWidth/2+20, areaHeight/2
	drawText 'T', area, areaWidth/2+30, areaHeight/2

ballInit:
	;Initialize direction vector to be straight up
	finit
	fldz
	fstp real8 ptr [GameBall.directionX]
	fld minimumVelocity
	fstp real8 ptr [GameBall.directionY]
	push offset GameBall.directionX
	push offset GameBall.directionY
	call normalizeVector
	add esp, 8
	
	; Set X coord of ball to the center of the player
	mov eax, Player1.pWidth
	shr eax, 1
	add eax, Player1.pX
	mov GameBall.centerX, eax
	; Set Y coord
	mov ebx, GameBall.radius
	mov eax, Player1.pY
	sub eax, ebx
	mov GameBall.centerY, eax
	
targetInit:
	mov ecx, 0
trr1:
	mov Mask1[ecx*4], 1
	inc ecx
	cmp ecx, rowTargetCount
	jb trr1
	
	mov ecx, 0
trr2:
	mov Mask2[ecx*4], 1
	inc ecx
	cmp ecx, rowTargetCount
	jne trr2
	
	mov ecx, 0
trr3:
	mov Mask3[ecx*4], 1
	inc ecx
	cmp ecx, rowTargetCount
	jne trr3
	
	mov ecx, 0
trr4:
	mov Mask4[ecx*4], 1
	inc ecx
	cmp ecx, rowTargetCount
	jne trr4
	
	
	jmp collisions
	
ingame:
	cmp bonusGrowActive, 1
	jne nogr
	call bonusTimerGrow
nogr:
	cmp bonusShrinkActive, 1
	jne nosh
	call bonusTimerShrink
nosh:
	cmp bonusSpeedUpActive, 1
	jne nospdup
	call bonusTimerSpeedUp
nospdup:
	cmp bonusSpeedDownActive, 1
	jne nospddwn
	call bonusTimerSpeedDown
nospddwn:
	cmp bonusSplitBallActive, 1
	jne nosplitball
	call bonusTimerSplitBall
nosplitball:

updates:
	
	ballUpdate GameBall
	call bonusUpdate
	ballCheckBounds GameBall
collisions:
	ballTargetsCollision GameBall
	ballPlayerCollision GameBall, Player1
	bonusCollision Player1
drawing:
	ballDraw GameBall, 0FFFFFFh
	playerDraw Player1
		
afisare_litere:


final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, areaWidth
	mov ebx, areaHeight
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push areaHeight
	push areaWidth
	push offset windowTitle
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
