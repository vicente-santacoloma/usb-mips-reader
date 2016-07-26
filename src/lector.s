# lector.s
# Programa capaz de leer y mostrar por consola un programa 
# cargado en memoria escrito con un conjunto reducido de 
# instrucciones MIPS
######################################################
# Planificacion de registro
######################################################
# $t0 Codigo de Operacion Actual
# $t1 RS / Temporal Hexa 
# $t2 RT / Temporal Hexa
# $t3 RD / Temporal Hexa
# $t4 Funcion de Tipos R
# $t5 Contador del arreglo de registro
# $t6 Inmediato para tipo I
# $t7 Variable de Espacio del Arreglo
# $t8 Target (Direccion de memoria Tipo-J)
# $t9 Carga Registros del Arreglo
# $s0 Contador de Direccion de Memoria
# $s1 Codigo de Ensamblado Actual
# $s2 Direccion del PC
# $s3 Direccion de inicializacion de memoria
# $s4 Auxiliar para casos de Lw y Sw
# $s5 Numero de operaciones Tipo-R /Auxiliar
# $s6 Numero de operaciones Tipo-I
# $s7 Numero de operaciones Tipo-J
######################################################

	.data
	
	.align 2
	arreglo:	.space 12
	cadena1:	.asciiz "lw "
	cadena2:	.asciiz "sw "
	cadena3:	.asciiz "addi "
	cadena4:	.asciiz "beq "
	cadena5:	.asciiz "bne "
	cadena6:	.asciiz "blez "
	cadena7:	.asciiz "bgtz "
	cadena8:	.asciiz "add "
	cadena9:	.asciiz "addu "
	cadena10:	.asciiz "sub "
	cadena11:	.asciiz "subu "
	cadena12:	.asciiz "and "
	cadena13:	.asciiz "or "
	cadena14:	.asciiz "xor "
	cadena15:	.asciiz "nor " 
	cadena16:	.asciiz "j "
	cadena17:	.asciiz "jal "
	cadena18:	.asciiz "li "
	A:			.asciiz "A"
	B:			.asciiz "B"
	C:			.asciiz "C"
	D:			.asciiz "D"
	E:			.asciiz "E"
	F:			.asciiz "F"
	regzero:	.asciiz "$zero"
	regat:		.asciiz "$at"
	regv:		.asciiz "$v"
	rega:		.asciiz "$a"
	regt:		.asciiz "$t"
	regs:		.asciiz "$s"
	regk:		.asciiz "$k"
	reggp:		.asciiz "$gp"
	regsp:		.asciiz "$sp"
	regfp:		.asciiz "$fp"
	regra:		.asciiz "$ra"
	resultadoR:	.asciiz "Operaciones Tipo-R: "
	resultadoI:	.asciiz "Operaciones Tipo-I: "
	resultadoJ:	.asciiz "Operaciones Tipo-J: "
	signo:		.asciiz ", "
	corchete1:	.asciiz "[0x"
	corchete2:	.asciiz "]"
	paren1:     .asciiz "("
	paren2:     .asciiz ")"
	space:		.asciiz "\n\n"

	.text
	
main:	lw $v0, 0x00400024 + 0($s0)	#Carga la direccion del programa a leer
		la $s2, 0x00400024 + 0($s0)	#Guarda direccion actual del PC
		move $s1, $v0
		move $t0, $v0
		beq $v0, 0x0d, fin	#Condicion de finalizacion
		srl $t0, $t0, 26
		beq $t0, 0x00, R	#Verificacion del codigo de operacion Tipo-R
		beq $t0, 0x02, J	#Verificacion del codigo de operacion Tipo-J
		beq $t0, 0x03, J	#Verificacion del codigo de operacion Tipo-J
		b I	#Salto a operaciones Tipo-I
		
condicional: 	beq $t0, 0x00, espacio	
				b immediate
			
R:		li $t1, 0
		li $t2, 0
		li $t3, 0
		li $t4, 0
		li $t5, 0
		addi $s5, $s5, 1
		and $t1, $s1, 0x03e00000	#Extraccion de RS
		srl $t1, $t1, 21
		and $t2, $s1, 0x001f0000	#Extraccion de RT
		srl $t2, $t2, 16
		and $t3, $s1, 0x0000f800	#Extraccion de RD
		srl $t3, $t3, 11
		and $t4, $s1, 0x0000003f	#Extraccion de la funcion
		sw $t3, arreglo + 0($t5)	
		sw $t1, arreglo + 4($t5)
		sw $t2, arreglo + 8($t5)
		beq $t4, 0x20, funcAdd		#Verificacion de la funcion
		beq $t4, 0x21, funcAddu
		beq $t4, 0x22, funcSub
		beq $t4, 0x23, funcSubu
		beq $t4, 0x24, funcAnd
		beq $t4, 0x25, funcOr
		beq $t4, 0x26, funcXor
		beq $t4, 0x27, funcNor
		
funcAdd:	li $v0, 4
			la $a0, cadena8
			syscall
			li $t7, 12
			b registro
			
funcAddu:	li $v0, 4
			la $a0, cadena9
			syscall
			li $t7, 12
			b registro

funcSub:	li $v0, 4
			la $a0, cadena10
			syscall
			li $t7, 12
			b registro

funcSubu:	li $v0, 4
			la $a0, cadena11
			syscall
			li $t7, 12
			b registro

funcAnd:	li $v0, 4
			la $a0, cadena12
			syscall
			li $t7, 12
			b registro
	
funcOr:		li $v0, 4
			la $a0, cadena13
			syscall
			li $t7, 12
			b registro
			
funcXor:	li $v0, 4
			la $a0, cadena14
			syscall
			li $t7, 12
			b registro

funcNor:	li $v0, 4
			la $a0, cadena15
			syscall
			li $t7, 12
			b registro
		
I: 		li $t1, 0
		li $t2, 0
		li $t5, 0
		li $t6, 0
		addi $s6, $s6, 1
		and $t1, $s1, 0x03e00000	#Extraccion de RS
		srl $t1, $t1, 21
		and $t2, $s1, 0x001f0000	#Extraccion de RT
		srl $t2, $t2, 16
		and $t6, $s1, 0x0000ffff	#Extraccion del campo inmediato
		li $t7, 4
		beq $t0, 0x0F, loadupperimm
		sw $t2, arreglo + 0($t5)	#Almaceno la cantidad de registros
		beq $t0, 0x23, loadword
		beq $t0, 0x2B, saveword
		beq $t0, 0x0d, loadimm
		li $t7, 8
		sw $t2, arreglo + 0($t5)
		sw $t1, arreglo + 4($t5)
		beq $t0, 0x08, addimm
		sw $t1, arreglo + 0($t5)
		sw $t2, arreglo + 4($t5)
		beq $t0, 0x04, brancheq
		beq $t0, 0x05, branchne
		li $t7, 4
		sw $t1, arreglo + 0($t5)
		beq $t0, 0x06, branchlez
		beq $t0, 0x07, branchgtz
			
loadword:	li $v0, 4
			la $a0, cadena1
			syscall
			b registro

saveword:	li $v0, 4
			la $a0, cadena2
			syscall
			b registro
			
loadupperimm:	and $s3, $s1, 0x0000ffff	#Extraccion de inicializacion
				sll $s3, $s3, 16
				addi $s0, 4		#Aumento del contador de direccion de memoria
				addi $s2, 4		#Aumento del direccion del PC
				lw $s1, 0($s2)
				and $t2, $s1, 0x001f0000	#Extraccion del RT
				srl $t2, $t2, 16
				and $t6, $s1, 0x0000ffff	#Extraccion del inmediato Tipo-I
				li $t5, 0
				sw $t2, arreglo + 0($t5)
				srl $s1, $s1, 26
				li $s4, 2
				beq $s1, 0x23, loadword 
				beq $s1, 0x2b, saveword
				b addunsigned 	#Salto en caso de Etiqueta+registro para Lw/Sw
				
addunsigned:	lw $s1, 0($s2)
				and $t1, $s1, 0x001f0000	#Extraccion de RS
				srl $t1, $t1, 16
				addi $s0, 4
				addi $s2, 4
				lw $s1, 0($s2)
				and $t2, $s1, 0x001f0000	#Extraccion de RT
				srl $t2, $t2, 16
				and $t6, $s1, 0x0000ffff	#Extraccion de inmediato para Tipo-I
				li $t5, 0
				sw $t2, arreglo + 0($t5)
				srl $s1, $s1, 26
				li $s4, 3
				beq $s1, 0x23, loadword 
				beq $s1, 0x2b, saveword
			
loadimm:	li $v0, 4
			la $a0, cadena18
			syscall
			b registro

addimm:		li $v0, 4
			la $a0, cadena3
			syscall
			b registro
			
brancheq:	li $v0, 4
			la $a0, cadena4
			syscall
			b registro

branchne:	li $v0, 4
			la $a0, cadena5
			syscall
			b registro

branchlez:	li $v0, 4
			la $a0, cadena6
			syscall
			b registro

branchgtz:	li $v0, 4
			la $a0, cadena7
			syscall
			b registro
			
immediate:  beq $t0, 0x23, address
			beq $t0, 0x2b, address
			beq $t0, 0x08, imm
			beq $t0, 0x0d, imm
			b immlabel
			
imm:	li $v0, 4		#Etiqueta para imprimir inmediato
		la $a0, signo
		syscall
		li $v0, 1
		move $a0, $t6
		syscall
		b espacio
			
immlabel:	li $v0, 4		#Etiqueta para imprimir direccion de memoria
			la $a0, signo
			syscall
			sll $t6, $t6, 16
			sra $t6, $t6, 16  
			sll $t6, $t6, 0x02
			add $t6, $t6, $s2
			move $a0, $t6	#Pasaje de parametro a la rutina Hexaprologo
			jal hexaprologo
			b espacio
		
J:		li $t8, 0
		addi $s7, $s7, 1
		and $t8, $t8, 0x03ffffff	#Extraccion del campo target
		beq $t0, 0x02, jump
		beq $t0, 0x03, jumpl
		
jump:	li $v0, 4
		la $a0, cadena16
		syscall
		move $a0, $s1	#Pasaje de parametros a la rutina Targetprologo
		jal targetprologo	#Llamada a la rutina
		b espacio

jumpl:	li $v0, 4
		la $a0, cadena17
		syscall
		move $a0, $s1
		jal targetprologo
		b espacio
		
registro:	lw $t9, arreglo + 0($t5)	#Carga los registros a imprimir
			beq $t9, 0, rzero
			beq $t9, 1, rat
			ble $t9, 3, rv
			ble $t9, 7, ra
			ble $t9, 15, rt
			ble $t9, 23, rs
			ble $t9, 25, rtt
			ble $t9, 27, rk
			beq $t9, 28, rgp
			beq $t9, 29, rsp
			beq $t9, 30, rfp
			beq $t9, 31, rra				

rzero:	li $v0, 4
		la $a0, regzero
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rat:	li $v0, 4
		la $a0, regat
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rv:		li $v0, 4
		la $a0, regv
		syscall
		addi $t9, $t9, -2
		li $v0, 1
		move $a0, $t9
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

ra:		li $v0, 4
		la $a0, rega
		syscall
		addi $t9, $t9, -4
		li $v0, 1
		move $a0, $t9
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rt:		li $v0, 4
		la $a0, regt
		syscall
		addi $t9, $t9, -8
		li $v0, 1
		move $a0, $t9
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rs:		li $v0, 4
		la $a0, regs
		syscall
		addi $t9, $t9, -16
		li $v0, 1
		move $a0, $t9
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rtt:	li $v0, 4
		la $a0, regt
		syscall
		addi $t9, $t9, -16
		li $v0, 1
		move $a0, $t9
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rk:		li $v0, 4
		la $a0, regk
		syscall
		addi $t9, $t9, -26
		li $v0, 1
		move $a0, $t9
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rgp:	li $v0, 4
		la $a0, reggp
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rsp:	li $v0, 4
		la $a0, regsp
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rfp:	li $v0, 4
		la $a0, regfp
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro

rra:	li $v0, 4
		la $a0, regra
		syscall
		beq $s4, 1, addressend1
		beq $s4, 2, addressend2
		beq $s4, 3, addressend2
		addi $t5, $t5, 4
		beq $t5, $t7, condicional
		li $v0, 4
		la $a0, signo
		syscall
		blt $t5, $t7, registro	
			
# Rutina para obtener el target de las operaciones tipo J
# Planificacion de registros
# $a0 Parametro de entrada que contiene el codigo de ensamblaje
# $t1 Parametro local que contiene la direccion de la etiqueta	
			
targetprologo:	subu $sp, $sp, 8	#Reservar espacio para la pila
				sw $fp, 8($sp)	#Empilar FP
				sw $ra, 4($sp)	#Empilar RA
				addu $fp, $sp, 8
				move $t1, $a0
				b target
			
target:		sll $t1, $t1, 6
			srl $t1, $t1, 4
			move $a0, $t1
			jal hexaprologo
			lw $fp, 8($sp)
			lw $ra, 4($sp)
			addu $sp, $sp, 8
			jr $ra
			
address:	li $v0, 4			#Etiqueta para imprimir direccion de memoria 
			la $a0, signo
			syscall
			li $v0, 1
			move $a0, $t6
			syscall
			li $v0, 4
			la $a0, paren1
			syscall
			li $t5, 0
			sw $t1, arreglo + 0($t5)	#Guardar registro a imprimir 
			li $s4, 1
			b registro
			
addressend1: 	li $s4, 0	#Etiqueta para caso Registro en Lw/Sw
				li $v0, 4
				la $a0, paren2	#Imprimir parentesis
				syscall
				b espacio
			
addressend2:	li $v0, 4	#Etiqueta para caso Etiqueta en Lw/Sw
				la $a0, signo
				syscall
				add  $s3, $s3, $t6
				move $a0, $s3	#Pasaje de parametro a la rutina Hexaprologo
				move $s3, $t1	#Respaldo el contenido en un registro
				jal hexaprologo
				beq $s4, 3, addressend3
				li $s4, 0
				b espacio
				
addressend3:	li $v0, 4	#Etiqueta para caso Etiqueta+Registro en Lw/Sw
				la $a0, paren1	#Imprimir parentesis
				syscall
				li $t5, 0
				sw $s3, arreglo + 0($t5)	#Guardar registro en un arreglo
				li $s4, 1
				b registro

espacio:	li $v0, 4
			la $a0, space
			syscall
			addi $s0, $s0, 4
			b main
			
# Rutina para imprimir direccion en hexadecimal
# Planificacion de registros
# $a0 Parametro de entrada que contiene la direccion
# $t1 Parametro local que almacena el digito a imprimir
# $t2 Parametro local (contador)	
# $t3 Parametro local que contiene la direccion de entrada		
			
hexaprologo:	subu $sp, $sp, 8	#Reservar espacio para la pila
				sw $fp, 8($sp)	#Empilar FP
				sw $ra, 4($sp)	#Empilar RA
				addu $fp, $sp, 8
				move $t3, $a0
				li $t2, 0
				li $v0, 4
				la $a0, corchete1	#Imprimir corchete de inicio
				syscall
				b hexa
			
hexa:	and $t1, $t3, 0xf0000000
		beq $t2, 32, hexafin	#Condicion de finalizacion de impresion
		addi $t2, $t2, 4
		srl $t1, $t1, 28
		sll $t3, $t3, 4
		beq $t1, 0xA, hexaA
		beq $t1, 0xB, hexaB
		beq $t1, 0xC, hexaC
		beq $t1, 0xD, hexaD
		beq $t1, 0xE, hexaE
		beq $t1, 0xF, hexaF
		b hexanum
			
hexanum:	li $v0, 1
			move $a0, $t1
			syscall
			b hexa
	
hexaA:	li $v0, 4
		la $a0, A
		syscall
		b hexa

hexaB:	li $v0, 4
		la $a0, B
		syscall
		b hexa

hexaC:	li $v0, 4
		la $a0, C
		syscall
		b hexa

hexaD:	li $v0, 4
		la $a0, D
		syscall
		b hexa

hexaE:	li $v0, 4
		la $a0, E
		syscall
		b hexa

hexaF:	li $v0, 4
		la $a0, F
		syscall
		b hexa
			
hexafin:	li $v0, 4
			la $a0, corchete2	#Imprimir corchete para cerrar 
			syscall
			lw $fp, 8($sp)	#Restaurar valores 
			lw $ra, 4($sp)
			addu $sp, $sp, 8
			jr $ra

fin:	li $v0, 4
		la $a0, resultadoR	#Imprimir
		syscall
		li $v0, 1
		move $a0, $s5
		syscall
		li $v0, 4
		la $a0, space
		syscall
		li $v0, 4
		la $a0, resultadoI	#Imprimir
		syscall
		li $v0, 1
		move $a0, $s6
		syscall
		li $v0, 4
		la $a0, space
		syscall
		li $v0, 4
		la $a0, resultadoJ	#Imprimir
		syscall
		li $v0, 1
		move $a0, $s7
		syscall
		li $v0, 4
		la $a0, space
		syscall
		li $v0, 10
		syscall