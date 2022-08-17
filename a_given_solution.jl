#####################################
# a given solution 
#####################################

using GLPK, JuMP
using DataFrames
m = Model(GLPK.Optimizer)

I = 4
J = 6
f = [10 10 10 10]
p = [60 60 60 60 60 60]

c = [
    10 12 8  6  5  14;
    8  5  10 15 9  12;
    7  14 4  11 15 8 ;
    5  8  12 10 10 10
]

ξ = [
    4 4 5 3 3 8;
    5 2 4 8 5 6;
    2 8 3 4 7 5;
    3 5 6 4 6 5
]

d = [8 4 6 3 5 8]

#@variable(m, z[1:I], Bin)
#@variable(m, x[1:I , 1:J], Bin)
z = [0 1 0 0]

x= [0  0  0  0  0  0;
    1  1  1  1  1  1;
    0  0  0  0  0  0;
    0  0  0  0  0  0]

@variable(m, y[1:J], Bin)

@objective(m, Min, sum( f[i] * z[i] for i in 1:I) + 
                   sum( c[i,j] * x[i,j] for i in 1:I for j in 1:J ) +
                   sum( p[j] * y[j] for j in 1:J ) 
            )
                   
@constraint(m, c1[j in 1:J], sum( ξ[i,j] * x[i,j] for i in 1:I ) + d[j] * y[j] ≥ d[j] )
@constraint(m, c2[i in 1:I , j in 1:J], x[i,j] ≤ z[i] )

optimize!(m)

objective_value(m)

value(sum( p[j] * y[j] for j in 1:J ) )

println( "cost of opening the facility : ", value( sum(f[i] * z[i] for i in 1:I) )  )

println("cost of transportation = " , value(sum( c[i,j] * x[i,j] for i in 1:I for j in 1:J ) ) )
