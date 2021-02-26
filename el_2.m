

% 使用画像のURL一覧(結合)
urllist = [urllist_turtle, urllist_negative];

% URLlistから画像配列読み込み
% カラーヒストグラム作成
histgrams = [];
for i = 1:numel(urllist)
    img = imread(urllist(i));
    X64_vec = reshape(img,1,numel(img));
    h=double(histc(X64_vec,[0:63])) / numel(X64_vec);
    histgrams = [histgrams; h];
end

% 5-cross varidationでのカラーヒストグラム＋最近傍分類の評価
url_pos = urllist_turtle;
url_neg = urllist_negative;
% 学習画像(最近傍に用いる画像)のラベル
trainLabel = [zeros(numel(url_pos) * 4 / 5, 1); ones(numel(url_neg) * 4 / 5, 1)];

% 評価画像の正解ラベル
correctLabel = [zeros(numel(url_pos) / 5, 1); ones(numel(url_neg) / 5, 1)];

% 認識率
evalRate = zeros(5, 1);

% 検証用 : 認識ラベル
evalLabel = zeros(40, 5);

idx = [1:size(histgrams, 1)];

% 画像リストの認識結果一覧取得用
img_result = zeros(numel(urllist), 1);

for i = 1:5
    % 学習データ、評価データを選定(8割を学習データ、2割を評価データに)
    trainData = histgrams(find(mod(idx, 5)~=(i-1)), :)
    evalData = histgrams(find(mod(idx, 5)==(i-1)), :)
    
    % img_result登録用
    if i==1
        tmpI = 5;
    else
        tmpI = i-1;
    end
    
    %最近傍法により、最も近い画像をtrainData内から見つける
    for j = 1:size(evalData, 1)
        %初期最近傍データ設定
        nearestIdx = 1
        nearestSim = sum(min(evalData(j, :), trainData(1, :)))
        for k = 1:size(trainData, 1)
            % ヒストグラムインターセクションが暫定最近傍画像より大きければ更新
            sim = sum(min(evalData(j, :), trainData(k, :)))
            if sim >= nearestSim
                nearestIdx = k
                nearestSim = sim
            end
        end
        evalLabel(j, i) = nearestIdx
        % 最近傍画像のラベルが画像の正しいラベルと等しいかジャッジ(画像認識結果をimg_resultに保存)
        if trainLabel(nearestIdx) == correctLabel(j)
            evalRate(i, 1) = evalRate(i, 1) + 1
            if correctLabel(j) == 0
                img_result(5*(j-1) + tmpI) = 1;
            else
                img_result(5*(j-1) + tmpI) = 3;
            end
        else
            if correctLabel(j) == 0
                img_result(5*(j-1) + tmpI) = 2;
            else
                img_result(5*(j-1) + tmpI) = 4;
            end
        end
    end
end
% サンプル数で割って平均を算出
    evalRate = evalRate / (size(histgrams, 1) / 5)
    
% 全体の平均の精度
    totalAcc = mean(evalRate)
    
    
%認識結果画像配列出力
save('color_negative_result.mat', 'img_result');