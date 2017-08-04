% Task 1: import temperature data: DONE
% Task 2: import Google Trends data
% Task 3: correlations between time series from Task 1 and 2
% (without any reliability rankings)

% Task 4: come up with a reliability ranking method
% Task 5: repeat Task 3 using the ranking method from Task 4
%% load temperature data
tempData = csvread('delhitemp/acqWeather.csv',1,0);
Year = tempData(:,1);
Month = tempData(:,2);
Day = tempData(:,3);
Temp = tempData(:,4);

for j = 2010:2016
for i = 1:12
    avgs(i,j-2009) = mean(Temp(Year == j & Month == i));
end
end

avgTemp = reshape(avgs,1,84);
plot(avgTemp)

%% import Google Trends data


%% correlations

%% ranking method
%% implement ranking method