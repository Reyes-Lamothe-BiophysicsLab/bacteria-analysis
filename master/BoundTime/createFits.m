function [fitresult, gof] = createFits(fx, fy)
%CREATEFITS(FX,FY)
%  Create fits.
%
%  Data for 'exp1' fit:
%      X Input : fx
%      Y Output: fy
%  Data for 'exp2' fit:
%      X Input : fx
%      Y Output: fy
%  Output:
%      fitresult : a cell-array of fit objects representing the fits.
%      gof : structure array with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 13-Feb-2020 16:02:41

%% Initialization.

% Initialize arrays to store fits and goodness-of-fit.
fitresult = cell( 2, 1 );
gof = struct( 'sse', cell( 2, 1 ), ...
    'rsquare', [], 'dfe', [], 'adjrsquare', [], 'rmse', [] );
figure

%% Fit: 'exp1'.
[xData, yData] = prepareCurveData( fx, fy );

% Set up fittype and options.
ft = fittype( 'exp1' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.408282198596655 -2.06546061360589];

% Fit model to data.
[fitresult{1}, gof(1)] = fit( xData, yData, ft, opts );

% Plot fit with data.
subplot(2,1,1)
h = plot( fitresult{1}, xData, yData );
legend( h, 'exp1', 'Location', 'NorthEast');
% Label axes
xlabel( 'fx' );
ylabel( 'fy' );
grid off

%% Fit: 'exp2'.
[xData, yData] = prepareCurveData( fx, fy );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [-0.474186297299017 -1.61116478333358 1.10986395371001 -2.16666152880251];

% Fit model to data.
[fitresult{2}, gof(2)] = fit( xData, yData, ft, opts );

% Plot fit with data.
subplot(2,1,2)
h = plot( fitresult{2}, xData, yData );
legend( h, 'exp2', 'Location', 'NorthEast');
% Label axes
xlabel( 'fx');
ylabel( 'fy');
grid off


