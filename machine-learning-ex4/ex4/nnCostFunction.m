function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
% y = 5000x1
% X = 5000x400
% theta1 = 25 x401
% theta2 = 10x26
y_vector = (1:num_labels)==y;
%display(y_vector);
X_temp = [ones(size(X,1),1) X];
g2 = X_temp * Theta1';
a2 = sigmoid(g2);
X_temp = [ones(size(a2,1),1) a2];
g3 = X_temp * Theta2';
a3 = sigmoid(g3);
J = sum(sum(-y_vector.*log(a3) - (1-y_vector).*log(1-a3)))/(m);
regu = sum(sum(Theta1(:,2:input_layer_size+1).*Theta1(:,2:input_layer_size+1)));
regu = (regu + sum(sum(Theta2(:,2:hidden_layer_size+1).*Theta2(:,2:hidden_layer_size+1))))*(lambda/(2*m));
J+=regu;
delta3 = (a3 - y_vector);
delta2 = (delta3 * Theta2).*sigmoidGradient([ones(size(g2,1),1) g2]);
delta2 = delta2(:,2:end);
Theta1_grad = (1/m)*(delta2' * [ones(size(X,1),1) X]);
Theta2_grad = (1/m)*(delta3' * [ones(size(a2,1),1) a2]);
Theta1_grad(:,2:end)=Theta1_grad(:,2:end) .+ Theta1(:,2:end)*(lambda/m);
Theta2_grad(:,2:end)=Theta2_grad(:,2:end) .+ Theta2(:,2:end)*(lambda/m);





% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
