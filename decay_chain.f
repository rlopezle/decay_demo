PROGRAM decay_chain

implicit none

! gfortran -o decay_chain decay_chain.f -ffree-form
integer, parameter :: max_size = 2000
integer, parameter :: output = 7
integer :: i
real :: hl_1,hl_2
real :: lambda_1,lambda_2
real :: N_0
real :: time(max_size)
real :: N_1_pop(max_size)
real :: N_2_pop(max_size)
real :: N_3_pop(max_size)
real, dimension(max_size,4) :: results

write (*,*) 'Enter half lives of parent and daughter nuclei (in days): '
read (*,*) hl_1, hl_2

write (*,*) 'The half lives are: ', hl_1, ' days and ', hl_2, ' days'

N_0 = 1E6
lambda_1 = log(2.)/(hl_1*24.*60.*60.)
lambda_2 = log(2.)/(hl_2*24.*60.*60.)

!here
do i = 1, max_size
	time(i) = (i-1)*3600.
end do

do i = 1, max_size
	N_1_pop(i) = N_0 * exp(-1.*lambda_1*time(i))
end do

do i = 1, max_size
	N_2_pop(i) = ((lambda_1*N_0)/(lambda_2 - lambda_1)) * (exp(-1.*lambda_1*time(i)) - exp(-1.*lambda_2*time(i)))
end do

do i = 1, max_size
	N_3_pop(i) = (N_0/(lambda_2 - lambda_1)) * ((lambda_2*(1. - exp(-1.*lambda_1*time(i)))) &
	-(lambda_1 *(1. - exp(-1.*lambda_2*time(i)))))
end do

results(:,1) = time(:)
results(:,2) = N_1_pop(:)
results(:,3) = N_2_pop(:)
results(:,4) = N_3_pop(:)

open(unit=output,file='OUTPUT.csv')
write(output, '(a12,",",a17,",",a19,",",a24)') 'Time_(hours)', 'Parent_Population', 'Daughter_Population', &
     'Granddaughter_Population'

do i = 1, max_size
    write(output, '(f0.0,",",f0.4,",",f0.4,",",f0.4)') results(i,1)/3600., results(i,2), results(i,3), results(i,4)
end do

close (output)

END PROGRAM decay_chain