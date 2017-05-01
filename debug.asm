
CODE 0	; 0
;program exit point
	halt 0


DATA d	; 0
dump 0 
dump 0 

CODE d	; 8
	proc	; OnGameModeInit
	; line 3f
	; line 40
	break	; c
	push.c 8
	;$par
	push.c 4
	sysreq.c 0	; funcidx
	stack 8
	const.alt ffffffff
	neq
	stor.pri 0
	;$exp
	; line 41
	break	; 44
	push.c 68
	;$par
	push.c 4
	sysreq.c 0	; funcidx
	stack 8
	const.alt ffffffff
	neq
	stor.pri 4
	;$exp
	; line 42
	break	; 7c
	push.c cc
	;$par
	push.c 4
	sysreq.c 0	; funcidx
	stack 8
	const.alt ffffffff
	jeq 0
	;$exp
	; line 44
	break	; b0
	push.c 16c
	;$par
	push.c 11c
	;$par
	push.c 8
	sysreq.c 1	; CallLocalFunction
	stack c
	retn
l.0		; e0
	; line 46
	break	; e0
	const.pri 1
	retn


DATA d	; 8
dump 4f 6e 50 6c 61 79 65 72 43 6f 6d 6d 61 6e 64 52 
dump 65 63 65 69 76 65 64 0 4f 6e 50 6c 61 79 65 72 
dump 43 6f 6d 6d 61 6e 64 50 65 72 66 6f 72 6d 65 64 
dump 0 7a 63 6d 64 5f 4f 6e 47 61 6d 65 4d 6f 64 65 
dump 49 6e 69 74 0 7a 63 6d 64 5f 4f 6e 47 61 6d 65 
dump 4d 6f 64 65 49 6e 69 74 0 0 

CODE d	; f0
	proc	; OnPlayerCommandText
	; line 54
	;$lcl cmdtext 10
	;$lcl playerid c
	; line 55
	break	; f4
	load.pri 0
	jzer 2
	push.s 10
	;$par
	push.adr c
	;$par
	push.c 1d0
	;$par
	push.c 170
	;$par
	push.c 10
	sysreq.c 1	; CallLocalFunction
	stack 14
	not
	jzer 2
	const.pri 1
	jump 3
l.2
	zero.pri
l.3
	jzer 1
	;$exp
	; line 57
	break	; 168
	const.pri 1
	retn
l.1		; 178
	; line 59
	break	; 178
	;$lcl pos fffffffc
	push.c 0
	;$exp
	;$lcl funcname ffffff7c
	stack ffffff80
	zero.pri
	addr.alt ffffff7c
	fill 80
	; line 5c
	break	; 1a0
l.4		; 1a4
	; line 5c
	break	; 1a4
	load.s.pri 10
	push.pri
	inc.s fffffffc
	load.s.pri fffffffc
	pop.alt
	idxaddr
	load.i
	const.alt 20
	jsleq 5
	;$exp
	; line 5e
	break	; 1e0
	addr.pri ffffff7c
	push.pri
	load.s.pri fffffffc
	add.c -1
	bounds 1f
	pop.alt
	idxaddr
	push.pri
	load.s.pri fffffffc
	load.s.alt 10
	idxaddr
	load.i
	push.pri
	;$par
	push.c 4
	sysreq.c 2	; tolower
	stack 8
	pop.alt
	stor.i
	;$exp
	jump 4
l.5		; 258
	; line 60
	break	; 258
	push.adr ffffff7c
	;$par
	push.c 1dc
	;$par
	push.c 20
	;$par
	push.adr ffffff7c
	;$par
	push.c 10
	sysreq.c 3	; format
	stack 14
	;$exp
	; line 61
	break	; 294
l.6		; 298
	; line 61
	break	; 298
	load.s.pri fffffffc
	load.s.alt 10
	idxaddr
	load.i
	eq.c.pri 20
	jzer 7
	;$exp
	; line 61
	break	; 2c4
	inc.s fffffffc
	;$exp
	jump 6
l.7		; 2d8
	; line 62
	break	; 2d8
	load.s.pri fffffffc
	load.s.alt 10
	idxaddr
	load.i
	not
	jzer 8
	;$exp
	; line 64
	break	; 300
	load.pri 4
	jzer 9
	;$exp
	; line 66
	break	; 314
	push.c 278
	;$par
	push.adr c
	;$par
	push.c 26c
	;$par
	push.adr ffffff7c
	;$par
	push.c 10
	sysreq.c 1	; CallLocalFunction
	stack 14
	heap 4
	stor.i
	push.alt
	;$par
	push.s 10
	;$par
	push.adr c
	;$par
	push.c 25c
	;$par
	push.c 1f8
	;$par
	push.c 14
	sysreq.c 1	; CallLocalFunction
	stack 18
	heap fffffffc
	stack 84
	retn
l.9		; 3ac
	; line 68
	break	; 3ac
	push.c 28c
	;$par
	push.adr c
	;$par
	push.c 280
	;$par
	push.adr ffffff7c
	;$par
	push.c 10
	sysreq.c 1	; CallLocalFunction
	stack 14
	stack 84
	retn
l.8		; 3f4
	; line 6a
	break	; 3f4
	load.pri 4
	jzer a
	;$exp
	; line 6c
	break	; 408
	load.s.pri fffffffc
	load.s.alt 10
	idxaddr
	push.pri
	;$par
	push.adr c
	;$par
	push.c 308
	;$par
	push.adr ffffff7c
	;$par
	push.c 10
	sysreq.c 1	; CallLocalFunction
	stack 14
	heap 4
	stor.i
	push.alt
	;$par
	push.s 10
	;$par
	push.adr c
	;$par
	push.c 2f8
	;$par
	push.c 294
	;$par
	push.c 14
	sysreq.c 1	; CallLocalFunction
	stack 18
	heap fffffffc
	stack 84
	retn
l.a		; 4b0
	; line 6e
	break	; 4b0
	load.s.pri fffffffc
	load.s.alt 10
	idxaddr
	push.pri
	;$par
	push.adr c
	;$par
	push.c 314
	;$par
	push.adr ffffff7c
	;$par
	push.c 10
	sysreq.c 1	; CallLocalFunction
	stack 14
	stack 84
	retn


DATA d	; 170
dump 4f 6e 50 6c 61 79 65 72 43 6f 6d 6d 61 6e 64 52 
dump 65 63 65 69 76 65 64 0 69 73 0 63 6d 64 5f 25 
dump 73 0 4f 6e 50 6c 61 79 65 72 43 6f 6d 6d 61 6e 
dump 64 50 65 72 66 6f 72 6d 65 64 0 69 73 69 0 69 
dump 73 0 1 0 69 73 0 1 0 4f 6e 50 6c 61 79 65 
dump 72 43 6f 6d 6d 61 6e 64 50 65 72 66 6f 72 6d 65 
dump 64 0 69 73 69 0 69 73 0 69 73 0 

DATA 0	; 320
dump 1 
dump 4 0 4c 6f 67 69 63 0 0 0 0 0 0 0 0 0 
dump 0 0 0 0 0 0 0 0 0 0 
dump 4 0 44 61 72 69 79 6f 6e 0 0 0 0 0 0 0 
dump 0 0 0 0 0 0 0 0 0 0 

CODE 0	; 508
	proc	; OnFilterScriptInit
	; line 1c
	; line 1e
	break	; 50c
	push.c 0
	call test
	;$exp
	; line 21
	break	; 520
	const.pri 1
	retn

	proc	; test
	; line 25
	; line 27
	break	; 534
	;$lcl str ffffffa0
	stack ffffffa0
	zero.pri
	addr.alt ffffffa0
	fill 60
	; line 29
	break	; 554
	load.pri 320
	const.alt 2
	jsless b
	const.pri 324
	move.alt
	load.i
	add
	add.c 4
	load.i
	jump c
l.b
	const.pri 38c
	push.pri
	const.pri 324
	move.alt
	load.i
	add
	load.i
	bounds 0
	pop.alt
	idxaddr
	move.alt
	load.i
	add
	add.c 4
	load.i
l.c
	heap 4
	stor.i
	push.alt
	;$par
	push.c 3f4
	;$par
	push.c 18
	;$par
	push.adr ffffffa0
	;$par
	push.c 10
	sysreq.c 3	; format
	stack 14
	heap fffffffc
	;$exp
	; line 30
	break	; 62c
	push.adr ffffffa0
	;$par
	push.c 4
	sysreq.c 4	; print
	stack 8
	;$exp
	stack 60
	zero.pri
	retn


DATA 0	; 3f4
dump 25 73 0 

STKSIZE 1000
