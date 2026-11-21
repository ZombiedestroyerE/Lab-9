.section .data

  msg_she:
    .byte 0x79, 0x76, 0x6D #0x79 for E, ox76 for H and 0x6D for S

.section .text
.global _start

_start:

  movb $0b1000000, %al
  movw $0x643, %dx
  outb %al, %dx
  movw $0, %si
  movw, $1, %bp

scroll:
  movw $50, %di

refresh_loop:
  movw $0, %cx

digit_check:
  movb $0x00, %bl
  cmpw %si, %cx
  jl blank_digit
  pushw %si
  movw %ax, %si
  movb msg_she(%si), %bl
  popw %si

blank_digit:
  movb $0xFF, %al 
  movw $0x640, %dx
  outb %al, %dx
  movb %bl, %al
  movw $0x640, %dx
  outb %al, %dx
  movb $0x01, %al
  shlb %cl, %al
  notb %al
  movw $0x640, %dx
  outb %al, %dx 
  pushw, %cx
  movw $0x0200, %cx

delay:
  nop
  loop delay
  popw %cx
  incw %cx
  cmpw $8, %cx
  jl digit_check
  decw %di
  jnz refresh_loop
  addw %bp, %si
  cmpw $5, %si
  jl check_right_edge
  movw $-1, %bp
  jmp scroll_step

check_right_edge:
  cmpw $0, %si
  jg scroll_step
  movw $1, %bp
  jmp scroll_step
