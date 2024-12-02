import math

def test(x, y, precision=0.001):
    cth_x = math.cosh(x) / math.sinh(x)  # coth(x) = cosh(x) / sinh(x)
    in_range = y * (1 - precision) <= cth_x <= y * (1 + precision)
    result = "TRUE" if in_range else "FALSE"
    print(f"{x} , {y} - {result} , CTH(X) = {round(cth_x, 7)}")

test(2.0, 1.5)  # false, CTH(2.0) = 1.0373147
test(1.0, 1.313035)  # true, CTH(1.0) = 1.3130353
test(0.5, 2.1639534)  # true, CTH(0.5) = 2.1639534
test(0.1, 10.016686)  # false, CTH(0.1) = 10.033311
test(1.5, 1.0)  # false, CTH(1.5) = 1.104791
test(3.0, 1.0049698)  # true, CTH(3.0) = 1.0049698
test(3.0, 1.1)  # false, CTH(3.0) = 1.0049698
test(4.0, 1.0003354)  # true, CTH(4.0) = 1.000671
test(0.2, 5.033489)  # false, CTH(0.2) = 5.066489
test(0.2, 5.5)  # false, CTH(0.2) = 5.0664895