
% 画像読み込み
list=textread('urllist_ramen.txt','%s');
OUTDIR='imgdir_ramen_interesting';
mkdir(OUTDIR);
for i=1:size(list,1)
  fname=strcat(OUTDIR,'/',num2str(i,'%04d'),'.jpg')
  websave(fname,list{i});
end

% turtle画像配列作成
DIR = strcat('imgdir','/')
urllist_turtle= [];
% DIR内のすべてのフォルダのアドレス取得
W=dir(DIR);
% '.', '..'を除外
Wdash = W(~ismember({W.name}, {'.', '..'}))

    for j=1:size(Wdash)
      if (strfind(Wdash(j).name,'.jpg'))
        fn=strcat(DIR,Wdash(j).name);
        urllist_turtle = [urllist_turtle, convertCharsToStrings(fn)]; 
      end
    end



    
% frog画像配列作成
DIR = strcat('imgdir_frog','/')
urllist_frog= [];
% DIR内のすべてのフォルダのアドレス取得
W=dir(DIR);
% '.', '..'を除外
Wdash = W(~ismember({W.name}, {'.', '..'}))

    for j=1:size(Wdash)
      if (strfind(Wdash(j).name,'.jpg'))
        fn=strcat(DIR,Wdash(j).name);
        urllist_frog = [urllist_frog, convertCharsToStrings(fn)]; 
      end
    end

% cheetah画像配列作成
DIR = strcat('imgdir_cheetah','/')
urllist_cheetah= [];
% DIR内のすべてのフォルダのアドレス取得
W=dir(DIR);
% '.', '..'を除外
Wdash = W(~ismember({W.name}, {'.', '..'}))

    for j=1:size(Wdash)
      if (strfind(Wdash(j).name,'.jpg'))
        fn=strcat(DIR,Wdash(j).name);
        urllist_cheetah = [urllist_cheetah, convertCharsToStrings(fn)]; 
      end
    end

% other画像配列作成
DIR = strcat('bgimg','/')
urllist_other= [];
% DIR内のすべてのフォルダのアドレス取得
W=dir(DIR);
% '.', '..'を除外
Wdash = W(~ismember({W.name}, {'.', '..'}))

    for j=1:size(Wdash)
      if (strfind(Wdash(j).name,'.jpg'))
        fn=strcat(DIR,Wdash(j).name);
        urllist_other = [urllist_other, convertCharsToStrings(fn)]; 
      end
    end

% other画像から、Negative画像としてランダムで200枚選びURLの配列とする。(課題1用)
urllist_negative = urllist_other(randperm(length(urllist_other),200))

% other画像から、Negative画像としてランダムで200枚選びURLの配列とする。(課題2用)
urllist_negative2 = urllist_other(randperm(length(urllist_other),1000))


% ramen画像配列作成
DIR = strcat('imgdir_ramen_rebalance','/')
urllist_ramen_rebalance25 = [];
% DIR内のすべてのフォルダのアドレス取得
W=dir(DIR);
% '.', '..'を除外
Wdash = W(~ismember({W.name}, {'.', '..'}))

    for j=1:size(Wdash)
      if (strfind(Wdash(j).name,'.jpg'))
        fn=strcat(DIR,Wdash(j).name);
        urllist_ramen_rebalance25 = [urllist_ramen_rebalance25, convertCharsToStrings(fn)]; 
      end
    end

% ramen画像配列作成(interesting)
DIR = strcat('imgdir_ramen_interesting','/')
urllist_ramen_interesting= [];
% DIR内のすべてのフォルダのアドレス取得
W=dir(DIR);
% '.', '..'を除外
Wdash = W(~ismember({W.name}, {'.', '..'}))

    for j=1:size(Wdash)
      if (strfind(Wdash(j).name,'.jpg'))
        fn=strcat(DIR,Wdash(j).name);
        urllist_ramen_interesting = [urllist_ramen_interesting, convertCharsToStrings(fn)]; 
      end
    end