 
brush db 'p'
color db 0Fh 


 
    START:

    	mov al,13h
    	mov ah,0   ;graphical mode
    	int 10h
    
   
    
    
    	mov ax, 1
	int 33h   ; show mouse pointer.
	
	 mov dx,10
   red1:
   mov cx,300
    red2:
	mov al, 0Ch
        mov ah,0ch
        int 10h
        inc cx
			; Draw the red square
        cmp cx,308
        jnz red2
    inc dx
    cmp dx,18
    jnz red1



   mov dx,25
   blue1:
   mov cx,300
    blue2:
	mov al, 01h
        mov ah,0ch
        int 10h
        inc cx
			; Draw the blue square
        cmp cx,308
        jnz blue2
    inc dx
    cmp dx,33
    jnz blue1
       
       
        
    mov dx,39
   green1:
   mov cx,300
    green2:
	mov al, 02h
        mov ah,0ch
        int 10h
        inc cx
			; Draw the green square
        cmp cx,308
        jnz green2
    inc dx
    cmp dx,47
    jnz green1
	
mov cx,2	
mov dl,300/8
    star1:

	mov dh,60/8
	mov  ah, 02h  ;SetCursorPosition        
	int  10h				
						
	mov al,'*'				
	mov ah,0Eh			
	int 10h
	mov dh,68/8
	mov  ah, 02h  ;SetCursorPosition       ------->   Draw Star
	int  10h
	
	mov al,'*'
	mov ah,0Eh
	int 10h
	mov dl,308/8
	loop star1
	
	
mov cx,2	
mov dl,300/8
    slash1:

	mov dh,80/8
	mov  ah, 02h  ;SetCursorPosition        
	int  10h				
						
	mov al,'\'				
	mov ah,0Eh			
	int 10h
	mov dh,88/8
	mov  ah, 02h  ;SetCursorPosition       ------->   Draw Slash
	int  10h
	
	mov al,'\'
	mov ah,0Eh
	int 10h
	mov dl,308/8
	loop slash1
	
	

    
    waiting: 
    	
    	mov AH,01h 
    	INT 16h   ;check for keystroke in the keyboard buffer
    
    
    	cmp al,72h
    	jz RedColor
    
    	cmp al,79h
    	jz YellowColor
    
    	cmp al,77h
    	jz WhiteColor
    
    	cmp al,62h
    	jz BlueColor
    
    	cmp al,67h
    	jz GreenColor
    
	cmp al,70h
	jz pixelBrush

    
    
    continue:
    	mov ah,0ch
    	mov al,0  ;  flush the keyboard buffer
    	int 21h 
    
    
    	mov ax,3
    	int 33h    ; get mouse position and status of its buttons	
	
	shr cx,1 ; "the value of CX is doubled" --> we need to divide it on 2 by shifting 
    
    
	cmp bx,1
	pushf
	
	cmp cx,300
	jb blue
	cmp cx,308
	ja blue
	cmp dx,10
	jb blue		; check if the user clicked on the red square
	cmp dx,18
	ja blue
	jmp RedColor
	
	blue:
	cmp cx,300
	jb green
	cmp cx,308
	ja green
	cmp dx,25
	jb green		; check if the user clicked on the blue square
	cmp dx,33
	ja green
	jmp BlueColor
	
	
	green:
	cmp cx,300
	jb star
	cmp cx,308
	ja star
	cmp dx,39
	jb star		; check if the user clicked on the green square
	cmp dx,47
	ja star
	jmp GreenColor
	
	
	star:
	cmp cx,300
	jb slash
	cmp cx,308
	ja slash
	cmp dx,60    	; check if the user clicked on the star square
	jb slash
	cmp dx,68
	ja slash
	jmp starBrush
	
	slash:
	cmp cx,300
	jb tools
	cmp cx,308
	ja tools
	cmp dx,80    	; check if the user clicked on the slash square
	jb tools
	cmp dx,88
	ja tools
	jmp slashBrush
	
	tools:
	cmp cx,292
	jb false
	cmp dx,0    	; check if the user clicked on the tools bar
	jb false
	jmp waiting 
	
	false:
	popf
	
	
    	jnz con ; jump if leftclick down 
    	
    	cmp brush , '*'
    	jz DrawStar
    	cmp brush , 'p'
    	jz DrawPixel
    	cmp brush , '\'
    	jz DrawSlash
    	con:
    	jmp waiting
     
     
     
     
     
    DrawPixel:
        mov al, color
        mov ah,0ch
        int 10h
        jmp waiting
    
    DrawStar:
    	mov bl, color
  	row db 0
  	column db 0
  	
  	shr cx, 3
  	shr dx, 3
  	
  	mov column , cl
  	mov row , dl
  	
    	
    	mov  dh, row   ;Row
    	mov  dl, column  ;Column
	mov  ah, 02h  ;SetCursorPosition
	int  10h
	
	
    	mov  al, '*'
    	mov cx,1
	mov  ah, 09h  ;write character and attribute at cursor position
	int  10h
	jmp waiting
	
    DrawSlash:
    	mov bl, color
  	
  	shr cx, 3
  	shr dx, 3
  	
  	mov column , cl
  	mov row , dl
  	
    	
    	mov  dh, row   ;Row
    	mov  dl, column  ;Column
	mov  ah, 02h  ;SetCursorPosition
	int  10h
	
	
    	mov  al, '\'
    	mov cx,1
	mov  ah, 09h  ;write character and attribute at cursor position
	int  10h
	jmp waiting
	
    RedColor:
        mov color, 0Ch
    	jmp continue
    YellowColor:
    	mov color,0Eh
    	jmp continue
    WhiteColor:
    	mov color,0Fh
    	jmp continue
    BlueColor:
    	mov color,01h
    	jmp continue
    GreenColor:
    	mov color,02h
    	jmp continue
    starBrush:
    	mov brush,'*'
    	jmp continue
    pixelBrush:
    	mov brush,'p'
    	jmp continue
    slashBrush:
    	mov brush,'\'
    	jmp continue
    
    

END START