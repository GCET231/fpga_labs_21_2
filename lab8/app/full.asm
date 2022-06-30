#############################################################################################
#
# João Carlos Bittencourt
# GCET231: Processador RISC231-M1 (Single-Cycle)
# Nov 07, 2019
#
# Este é um programa MIPS usado para testar o processador RISC231.
#
# No MARS, por favor selecione: Settings ==> Memory Configuration ==> Default.
#
# NOTE: TAMANHOS DAS MEMÓRIAS.
#
# Memória de instruções: Este programa possui 59 instruções (depois da montagem, 
# um conjunto de instruções -- lw "a" e sw "a_sql" -- expande para três instruções cada).
# Então, vamos fazer uma memória de instruções com 64 posições.
#
# Memória de Dados: Faça a memória de dados possuir 64 posições. Esse programa usa apenas 
# duas posiçoes para dados, e algumas mais para a pilha. O topo da pilha é definido no 
# endereço [0x10010100], levando a um total de 64 posições para dados e pilha. 
# Se você necessitar de uma memória maior que 64 palavras, você deve mover o topo da 
# pilha para um endereço mais alto.
#
#############################################################################################

.data 0x10010000 			# Início da memória de dados
a_sqr:	.space 4
a:	.word 3

.text 0x00400000			# Início da memória de instruções
main:
	lui	$sp, 0x1001		# Inicializa o ponteiro da pilha para a posição 64 acima do dado
	ori 	$sp, $sp, 0x0100	# O topo da pilha é a palavra no endereço [0x100100fc - 0x100100ff]
	
	
	################################
	# TESTA TODAS AS 25 INSTRUÇÕES #
	################################

	lui	$t0, 0xffff
	ori	$t0, $t0, 0xffff 	# $t0 = -1
	addi	$t1, $0, -1		# $t1 = -1
	bne	$t0, $t1, end
	sll	$t0, $t0, 24		# $t0 = 0xff00_0000
	ori 	$t0, $t0, 0xf000	# $t0 = 0xff00_f000
	sra	$t0, $t0, 8		# $t0 = 0xffff_00f0
	srl	$t0, $t0, 4		# $t0 = 0x0fff_f00f
	ori	$t2, $0, 3		# $t2 = 3
	sub	$t2, $t2, $t1 		# $t2 = 3 - (-1) = 4
	sllv	$t0, $t0, $t2 		# $t0 = 0xffff_00f0
	
	slt 	$t3, $t0, $t2 		# 0xffff_00f0 < 4 ?  (signed)  YES
	sltu 	$t3, $t0, $t2 		# 0xffff_00f0 < 4 ?  (unsigned)  NO
	addi 	$t0, $0, 5		# $t0 = 5
	slti	$t3, $t0, 10		# 5 < 10?  YES
	sltiu	$t3, $t0, 4		# 5 < 4?   NO
	addi 	$t0, $0, -5		# $t0 = -5
	sltiu	$t3, $t0, 5		# -5 < 5?  NO -- por que -5 unsigned é um número maior
	addi	$t0, $0, 20		# $t0 = 20
	sltiu	$t3, $t0, -1		# 20 < -1?  YES -- por que -1 é sign-extended e então quando considerado unsigned é um número maior
	
		
			

	
	lui 	$t3, 0x1010
	ori	$t3, $t3, 0x1010	# $t3 = 0x1010_1010
	lui 	$t4, 0x0101
	addi	$t4, $t4, 0x1010	# $t4 = 0x0101_1010
	andi	$t5, $t4, 0xFFFF	# $t5 = 0x0000_1010
	xori	$t5, $t5, 0xFFFF	# $t5 = 0x0000_EFEF	
	and	$t5, $t3, $t4		# $t5 = 0x0000_1010 
	or	$t5, $t3, $t4		# $t5 = 0x1111_1010
	xor	$t5, $t3, $t4		# $t5 = 0x1111_0000
	nor	$t5, $t3, $t4		# $t5 = 0xEEEE_EFEF
     	
	###################################################
	# TESTE chamada a procedimentos, pilha e recursão #
	###################################################

	lw	$a0, a($0) 		# carrega a no registrador $a0
	addi	$a0, $a0, 2
	addiu	$a0, $a0, 0xfffffffe 	# -2
	jal   	sqr			# calcula sqr(a)
	sw	$v0, a_sqr($0)		# armazena o resultado dentro de a_sqr     

			
					
	###############################
	# FIM usando loop infinito    #
	###############################
end:
	j	end          	# loop infinito é uma "trap" por que nós não temos chamadas syscall para sair


######## FIM DA MAIN #################################################################################


######## PROCEDIMENTOS CHAMADOS ABAIXO #####################################################################



	#################################
	# sqr() procedimento recursivo  #
	#################################

sqr:
	addi	$sp, $sp, -8
	sw	$ra, 4($sp)
	sw	$a0, 0($sp)
	slti	$t0, $a0, 2
	beq	$t0, $0, then
	add	$v0, $0, $a0
	j	rtn	
then:
	addi	$a0, $a0, -1
	jal	sqr
	lw	$a0, 0($sp)
	add	$v0, $v0, $a0
	addu	$v0, $v0, $a0
	addi	$v0, $v0, -1
	bne	$0, $0, then 		# branch deve ser not taken
rtn:
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
	

######## FIM DO CÓDIGO #################################################################################
