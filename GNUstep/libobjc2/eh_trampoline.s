	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 12, 0
	.private_extern	__Z13eh_trampolinev     ## -- Begin function _Z13eh_trampolinev
	.globl	__Z13eh_trampolinev
	.p2align	4, 0x90
__Z13eh_trampolinev:                    ## @_Z13eh_trampolinev
Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 155, _test_eh_personality
	.cfi_lsda 16, Lexception0
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
Ltmp0:
	callq	__Z9cxx_throwv
Ltmp1:
	jmp	LBB0_1
LBB0_1:
	leaq	-8(%rbp), %rdi
	callq	__ZZ13eh_trampolinevEN1XD1Ev
	xorl	%eax, %eax
	addq	$32, %rsp
	popq	%rbp
	retq
LBB0_2:
Ltmp2:
                                        ## kill: def $edx killed $edx killed $rdx
	movq	%rax, -16(%rbp)
	movl	%edx, -20(%rbp)
Ltmp3:
	leaq	-8(%rbp), %rdi
	callq	__ZZ13eh_trampolinevEN1XD1Ev
Ltmp4:
	jmp	LBB0_3
LBB0_3:
	jmp	LBB0_4
LBB0_4:
	movq	-16(%rbp), %rdi
	callq	__Unwind_Resume
	ud2
LBB0_5:
Ltmp5:
	movq	%rax, %rdi
	movq	%rdx, -32(%rbp)                 ## 8-byte Spill
	callq	___clang_call_terminate
Lfunc_end0:
	.cfi_endproc
	.section	__TEXT,__gcc_except_tab
	.p2align	2
GCC_except_table0:
Lexception0:
	.byte	255                             ## @LPStart Encoding = omit
	.byte	155                             ## @TType Encoding = indirect pcrel sdata4
	.uleb128 Lttbase0-Lttbaseref0
Lttbaseref0:
	.byte	1                               ## Call site Encoding = uleb128
	.uleb128 Lcst_end0-Lcst_begin0
Lcst_begin0:
	.uleb128 Ltmp0-Lfunc_begin0             ## >> Call Site 1 <<
	.uleb128 Ltmp1-Ltmp0                    ##   Call between Ltmp0 and Ltmp1
	.uleb128 Ltmp2-Lfunc_begin0             ##     jumps to Ltmp2
	.byte	0                               ##   On action: cleanup
	.uleb128 Ltmp1-Lfunc_begin0             ## >> Call Site 2 <<
	.uleb128 Ltmp3-Ltmp1                    ##   Call between Ltmp1 and Ltmp3
	.byte	0                               ##     has no landing pad
	.byte	0                               ##   On action: cleanup
	.uleb128 Ltmp3-Lfunc_begin0             ## >> Call Site 3 <<
	.uleb128 Ltmp4-Ltmp3                    ##   Call between Ltmp3 and Ltmp4
	.uleb128 Ltmp5-Lfunc_begin0             ##     jumps to Ltmp5
	.byte	1                               ##   On action: 1
	.uleb128 Ltmp4-Lfunc_begin0             ## >> Call Site 4 <<
	.uleb128 Lfunc_end0-Ltmp4               ##   Call between Ltmp4 and Lfunc_end0
	.byte	0                               ##     has no landing pad
	.byte	0                               ##   On action: cleanup
Lcst_end0:
	.byte	1                               ## >> Action Record 1 <<
                                        ##   Catch TypeInfo 1
	.byte	0                               ##   No further actions
	.p2align	2
                                        ## >> Catch TypeInfos <<
	.long	0                               ## TypeInfo 1
Lttbase0:
	.p2align	2
                                        ## -- End function
	.section	__TEXT,__text,regular,pure_instructions
	.p2align	4, 0x90                         ## -- Begin function _ZZ13eh_trampolinevEN1XD1Ev
__ZZ13eh_trampolinevEN1XD1Ev:           ## @_ZZ13eh_trampolinevEN1XD1Ev
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rdi
	callq	__ZZ13eh_trampolinevEN1XD2Ev
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.private_extern	___clang_call_terminate ## -- Begin function __clang_call_terminate
	.globl	___clang_call_terminate
	.weak_definition	___clang_call_terminate
	.p2align	4, 0x90
___clang_call_terminate:                ## @__clang_call_terminate
## %bb.0:
	pushq	%rax
	callq	___cxa_begin_catch
	movq	%rax, (%rsp)                    ## 8-byte Spill
	callq	__ZSt9terminatev
                                        ## -- End function
	.p2align	4, 0x90                         ## -- Begin function _ZZ13eh_trampolinevEN1XD2Ev
__ZZ13eh_trampolinevEN1XD2Ev:           ## @_ZZ13eh_trampolinevEN1XD2Ev
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movq	%rdi, -8(%rbp)
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
.subsections_via_symbols
