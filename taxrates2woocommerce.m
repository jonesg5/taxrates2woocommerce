function taxrates2woocommerce
%TAXRATES2WOOCOMMERCE Summary of this function goes here
%   Detailed explanation goes here

[inputName,inputDir] = uigetfile('*.csv','Select file to convert');
inputPath = fullfile(inputDir,inputName);
[State,ZipCode,TaxRegionName,TaxRegionCode,StateRate,CountyRate,CityRate,SpecialRate] = importfile(inputPath);

Rate = (CountyRate + CityRate + SpecialRate) .* 100;

[uniqueTaxRegionCode,idx1,~]= unique(TaxRegionCode);
uniqueTaxRegionName = TaxRegionName(idx1);

% Initialize output variables
CountryCode = 'US';
StateCode = State{1};
City = '*';
Priority = '2';
Compound = '0';
Shipping = '1';
TaxClass = '';
out = dataset;

% Create header row
j = 1; % independent counter
out.CountryCode(j,1) = {'Country Code'};
out.State(j,1) = {'State Code'};
out.Zip(j,1) = {'ZIP/Postcode'};
out.City(j,1) = {'City'};
out.Rate(j,1) = {'Rate %'};
out.TaxName(j,1) = {'Tax Name'};
out.Priority(j,1) = {'Priority'};
out.Compound(j,1) = {'Compound'};
out.Shipping(j,1) = {'Shipping'};
out.TaxClass(j,1) = {'Tax Class'};

for i1 = 1:length(uniqueTaxRegionCode)
    idx2 = strcmp(TaxRegionCode,uniqueTaxRegionCode{i1});
    uniqueRate = unique(Rate(idx2));
    for i2 = 1:length(uniqueRate)
        idx3 = Rate == uniqueRate(i2);
        idx4 = idx2 & idx3;
        
        j = j+1;
        out.CountryCode(j,1) = {CountryCode};
        out.State(j,1) = {StateCode};
        tempZip1 = cell2mat(ZipCode(idx4));
        semicolons = repmat('; ',length(ZipCode(idx4)),1);
        tempZip2 = [tempZip1,semicolons];
        out.Zip(j,1) = {reshape(tempZip2',1,[])};
        out.City(j,1) = {City};
        out.Rate(j,1) = {num2str(uniqueRate(i2))};
        out.TaxName(j,1) = {['Local Tax (',uniqueTaxRegionCode{i1},')']};
        out.Priority(j,1) = {Priority};
        out.Compound(j,1) = {Compound};
        out.Shipping(j,1) = {Shipping};
        out.TaxClass(j,1) = {TaxClass};
    end
end

export(out,'file','taxRates.csv','Delimiter',',','WriteVarNames',false,'WriteObsNames',false);

end

