%BoF+非線形SVM(ランダムポイント)

% BoF用の全ての画像を用いたコードブック作成

% 使用するすべての画像の配列
url_pos = urllist_turtle;
url_neg = urllist_cheetah;
url_all = [url_pos, url_neg]


% 特徴量を保存する配列
Features = [];

% 特徴量抽出(SURF特徴によるポイントでの特徴を使用(DoG))
for i = 1:numel(url_all)
    I = rgb2gray(imread(url_all{i}));
    p = createRandomPoints(I, 300);
    [f,p2]=extractFeatures(I, p);
    Features = [Features; f];
end

% 特徴点数を絞る
if size(Features, 1) > 50000
   Features=Features(randperm(size(Features,1),50000),:);
end

% k-means法により代表ベクトルを決定
[idx,CODEBOOK]=kmeans(Features, 1000);
 save('codebook_turtle_other.mat','CODEBOOK');

% コードブックを用いて使用画像のBoFベクトル抽出
load('codebook_turtle_cheetah.mat');
% 全ての画像のBoFベクトルを保存
bof = zeros(numel(url_all), 1000);

for i = 1 : numel(url_all)
    
    %特徴抽出
    I = rgb2gray(imread(url_all{i}));
    p = createRandomPoints(I, 3000);
    [f,p2]=extractFeatures(I,p);
    
    for j = 1:size(p2, 1)
        tmpTable = repmat(f(j, :), 1000,1);
        %codebook内ベクトルと抽出した特徴量とのユークリッド距離算出
        euclidDistance = sum(((CODEBOOK - tmpTable) .^ 2), 2);
        %最小ユークリッド距離のインデックス取得
        [M, minIndex] = min(euclidDistance);
        
        %最も近いBoFベクトルをカウント
        bof(i, minIndex) = bof(i,minIndex) + 1;
    end
end

%カウントした特徴を一括で正規化
bof = bof ./ sum(bof,2); 

% BoFベクトルを用いた非線形SVMによる分類
%pos=1, neg=-1としたときの正解ラベル
training_label = [ones(numel(url_pos)*4/5,1); ones(numel(url_neg)*4/5,1)*(-1)];

%分類の正解ラベル
correct_label = [ones(numel(url_pos)/5,1); ones(numel(url_neg)/5,1)*(-1)];

% 認識率
evalRate = zeros(5, 1);

% 画像リストの認識結果一覧取得用
img_result = zeros(numel(url_all), 1);


% 5-fold cross validationによる分類評価
idx = [1:numel(url_all)]
for i = 1:5
    % 8割を学習用、2割を分類用に
    bof_learn = bof(find(mod(idx, 5)~=(i-1)), :)
    bof_eval = bof(find(mod(idx, 5)==(i-1)), :)
    %学習
    %非線形
    model = fitcsvm(bof_learn, training_label, 'KernelFunction','rbf','KernelScale','auto');

    %分類(今回は学習に用いたすべての画像を分類)
    [predicted_label, scores] = predict(model, bof_eval);

    %分類率導出
    evalRate(i) = numel(find(correct_label == predicted_label)) / numel(correct_label);
    
    %画像認識結果リスト作成
    if i==1
        tmpI = 5;
    else
        tmpI = i-1;
    end
    
    for j = 1:numel(url_all)/5
        if correct_label(j) == 1
            if predicted_label(j) == correct_label(j)
                img_result(5*(j-1) + tmpI) = 1;
            else
                img_result(5*(j-1) + tmpI) = 2;
            end
        else
            if predicted_label(j) == correct_label(j)
                img_result(5*(j-1) + tmpI) = 3;
            else
                img_result(5*(j-1) + tmpI) = 4;
            end
        end
    end
end

% 各回の分類率
evalRate

% 全体の平均
totalAcc = mean(evalRate)

%認識結果画像配列出力
save('Bof_cheetah_result.mat', 'img_result');
