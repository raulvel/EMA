clear all
% load your data file here
load('proj_fit_13');
% plot data to get an idea of how the function looks; it's best to use the "structured"
% representation for this
mesh(id.X{1}, id.X{2}, id.Y');  
% note the transpose in Y, this is because of the way that mesh expects to receive the data

% the RBF approximator creation takes as inputs: 
% a) the limits of the domain as an input; one way to compute the limits from the ID data is:
limx = minmax(id.Xflat);
% (the validation data will stay within the same limits for the examples in the lab) 
% b) the number of basis functions on each dimension
% say we want 6 RBFs on each dimension (all examples are two-dimensional)
N = [10 10];
    
app = rbfapprox(limx, N);
    
% you need to create a matrix of regressors (RBF values) and a vector of output values, see the lecture

% to get the vector of RBF values at input point k, you can write:
for k=1:id.dims(1)*id.dims(2)
phi(k,:) = app.phi(app, id.Xflat(:, k));
end
% once you have the regressors matrix and the output vector, solve the linear system using \
theta=phi\id.Yflat';
% assuming your parameter vector is called theta, you can now evaluate the approximator at any
% validation point
% e.g. using the "flat" representation at point k:
for k=1:val.dims(1)*val.dims(2)
Yhat(k) = app.eval(app, val.Xflat(:, k), theta);
end
% or using the "structured" representation at point (i, j):
    
% now compute an MSE, plot the approximate values, and compare them on the graph with the true
% function values
MSE=1/val.dims(1)/val.dims(2)*sum(val.Yflat-Yhat)^2
% if you have computed a flat vector of approximate outputs Yhat for the validation data, the
% following instruction gets it into an appropriate shape for using mesh
mesh(val.X{1}, val.X{2}, val.Y);  
figure
Yhat = reshape(Yhat, val.dims); 
mesh(val.X{1}, val.X{2}, Yhat);  % val.dims stores the "structured" size of the data