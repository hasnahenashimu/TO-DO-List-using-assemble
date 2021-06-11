INCLUDE "EMU8086.INC"
.MODEL SMALL
.STACK 100H
.DATA
 
    EVENT DB "Event.txt",0
    A DB 100 DUP('$')
    B DB 100 DUP('$')
    EVENT_HANDEL DW ?
    CHAR DB ?
    CK DB 0
 
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS,AX
   
    MOV AH,3DH                     
    MOV AL,0        
    LEA DX, EVENT  
    INT 21H          
    MOV EVENT_HANDEL, AX
   
    INPUT_STARTS:
    MOV SI,0
    IN1:
    MOV AH,3FH                 
    MOV BX,EVENT_HANDEL              
    MOV CX,1
    LEA DX,CHAR
    INT 21H
      
    CMP AX,0                  
    JE EXIT
     
    MOV AL,CHAR      
     
    CMP AL,10
    JE INPUT_ENDS
    MOV B[SI],AL
    INC SI
    JMP IN1
       
    INPUT_ENDS:
    MOV B[SI],'$'
    MOV AH,9
    LEA DX,B
    INT 21H
         
    NEW_LINE:  
    MOV SI,0
    IN2:
    MOV AH,3FH                 
    MOV BX,EVENT_HANDEL
    MOV CX,1
    LEA DX,CHAR
    INT 21H
     
    CMP AX,0
    JE EXIT
     
    MOV AL,CHAR
     
    CMP AL,10
    JE COMPARE
    MOV A[SI],AL
    INC SI
    JMP IN2
       
    COMPARE:
    MOV A[SI],'$'
        
    MOV SI,0
         
    L2:
    MOV AL,A[SI]        
    MOV BL,B[SI]
    CMP AL,BL
    JNE NEW_LINE          
    CMP AL,'$'
    JE SAME
    INC SI
    JMP L2
         
    SAME:
    MOV AL,1
    MOV CK,AL
    PRINTN
    PRINT "EVENTS ON THIS DAY:"
    PRINTN
    PRINT_EVENTS:          
    MOV SI,0
    OUT1:
    MOV AH,3FH         
    MOV BX,EVENT_HANDEL
    MOV CX,1
    LEA DX,CHAR
    INT 21H
     
    CMP AX,0           
    JE EXIT
     
    MOV AL,CHAR
    
    CMP AL,10
    JE PRINT_VAL
    MOV A[SI],AL
    INC SI
    JMP OUT1
               
    PRINT_VAL:            
    MOV A[SI],'$'
            
    MOV SI,2
    MOV AL,A[SI]     
    CMP AL,'-'
    JNE PR:
               
    MOV SI,5
    MOV AL,A[SI]
    CMP AL,'-'
    JNE PR:
    JMP EXIT
    PR:
    PRINTN           
    MOV AH,9
    LEA DX,A
    INT 21H
    JMP PRINT_EVENTS
              
 
    EXIT:
    MOV AL,CK
    CMP AL,0
    JNE ENDD                     
    PRINTN
    PRINT "NO EVENT ON THIS DAY"
    ENDD:
    MOV AH,3EH                    
    MOV BX,EVENT_HANDEL
    INT 21H
    MOV AH,4CH
    INT 21H
  ENDP MAIN
END MAIN  