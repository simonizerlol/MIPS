#NAME: SIMON HSU
#ID: 260610820
#COMP273 A4 Q1
# -----------------   findRoot  ----------------------------- 

#  arguments:
#  a       in $f12
#  c       in $f13
#  epsilon in $f14
#  the root returns result in $f0

# returns a root of a given polynomial p(x) in a given interval [a,c] 
# with precision EPSILON the absolute difference between of the returned
# value from the true root must be at most EPSILON
findRoot:
#may call the helper function evaluate.
#the evaluate has access to the names POLYORDER, COREFFICIENTS
#findRoot DOESNT HAVE THE ACCESS TO THE NAMES
#findRoot passes arguments a, c, and epsilon
sub $sp, $sp, 24 ##allocate stack space
sw $s0, 0($sp)
s.s $f20 , 4($sp)
s.s $f20 , 8($sp)
s.s $f22 , 12($sp)
s.s $f23 , 16($sp)
sw $ra, 20($sp)

#addi $t0, $zero, 0 #save zero as a FP value
mov.s $f22, $f12	#f22 is a
mov.s $f23, $f13	#f23 is c

add.s $f20, $f22, $f23 #f4 is a+c

addi $t0, $zero, 2
mtc1 $t0, $f4
cvt.s.w $f4, $f4 #f5 = 2.0
div.s $f20, $f20, $f4 #b=(a/c)/2 

#evaluate the function p(b)
mov.s $f12, $f20 #move b to $f12 to be evaluated by the function
jal evaluate 

mov.s $f21, $f0 #save the result in a register

addi $t0, $zero, 0
mtc1 $t0, $f5
cvt.s.w $f5, $f5 #f5 = 0.0
c.eq.s $f21, $f5 #compare p(b) and zero
bc1f rootAtb #if false then go to cont

#else if ( abs(a - c) < epsilon)
sub.s $f4, $f22, $f23 #f6=a-c
addi $t0, $zero, 0
mtc1 $t0, $f5
c.lt.s $f4, $f5
bc1f elif #if false then go to elif
abs.s $f4, $f4 #f6=abs(a - c)

elif:
l.s $f5, EPSILON #f14 is EPSILON
c.lt.s $f4, $f5 #if |a-b| < EPSILON
bc1f rootAtb #if false then go to rootAtb

mov.s $f12, $f22 #p(b) is in $f0
jal evaluate

#else if ( p(a)*p(b) > 0 )
mul.s $f4, $f0, $f21 #f8 = p(a)*p(b)
addi $t0, $zero, 0
mtc1 $t0, $f5
cvt.s.w $f5, $f5
c.lt.s $f5, $f4 #if p(a)*p(b) > 0
bc1t recall #if false then go to recall

mov.s $f12, $f22
mov.s $f13, $f20 #reload a in arguments register
jal findRoot
j end

recall:
mov.s $f12, $f20 #recall a in arguments register
mov.s $f13, $f23 #a=c
jal findRoot
j end

rootAtb:
mov.s $f0, $f20 #return b
j end

end:
lw $s0 , 0($sp)
l.s $f20 , 4($sp)
l.s $f20 , 8($sp)
l.s $f22 , 12($sp)
l.s $f23 , 16($sp)
lw $ra, 20($sp)
add $sp, $sp,  24 #allocate stack space back
jr $ra #return







