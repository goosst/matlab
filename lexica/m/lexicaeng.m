close all; clear all;   
randn('state',0); %reset the random number generator

%load data (dataset must define 'datacell')
run('choose');

%number of stimuli types (wordtype-speaker pairs)
types = length(datacell);

%number of simulations
simN = 5000;

%preallocate arrays
lemstds = zeros(simN,types);
ccmstds = zeros(simN,types);
remstds = zeros(simN,types);
lems = zeros(simN,types);
ccms = zeros(simN,types);
rems = zeros(simN,types);


%main loop
for count=1:simN
    permd=datacell(randperm(types)); %shuffles datacell
    cumulator=[]; %empty starting cumulator array
    for lexicon=1:types 
        for place=1:lexicon
            cumulator=cat(2,cumulator,cell2mat(permd(place))); 
        end;
        summed=sum(cumulator,2);
        [h w]=size(cumulator);
        avg=summed/w;
        avgLEM=avg(1); 
        avgCCM=avg(2); 
        avgREM=avg(3);
        stdLEM=std(cumulator(1,:));
        stdCCM=std(cumulator(2,:));
        stdREM=std(cumulator(3,:));
        rsdLEM=stdLEM/avgLEM;
        rsdCCM=stdCCM/avgCCM;
        rsdREM=stdREM/avgREM;
        lems(count,lexicon)=rsdLEM;
        ccms(count,lexicon)=rsdCCM;
        rems(count,lexicon)=rsdREM;
        lemstds(count,lexicon)=stdLEM;
        ccmstds(count,lexicon)=stdCCM;
        remstds(count,lexicon)=stdREM;
        cumulator=[]; %resets cumulator
        clear h w;
    end;
end; %end main loop

%averaging sims
lemstdarray = sum(lemstds,1)/simN;
ccmstdarray = sum(ccmstds,1)/simN;
remstdarray = sum(remstds,1)/simN;
lemarray = sum(lems,1)/simN;
ccmarray = sum(ccms,1)/simN;
remarray = sum(rems,1)/simN;

%graph
x=ccmstdarray;
plot(x, remarray, 'ro', x, ccmarray, 'ks', x, lemarray, 'bd');
axis([0 90 0 .295]);
lsline;