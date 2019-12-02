import stroop
import scipy.optimize as opt

res = opt.minimize(stroop.jim_model_error, [1.5],
                  method='nelder-mead',
                  options={'disp':True})