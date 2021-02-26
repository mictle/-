% 今回は学習済みネットワークとしてvgg16を使用
net = vgg16;

% 使用するすべての画像の配列
url_pos = urllist_turtle;
url_neg = urllist_negative;
url_all = [url_pos, url_neg];

% 画像読み込み、サイズ変更、dcnn特徴抽出
features = [];
for i = 1:numel(url_all)
    img = imread(url_all(i));
    reimg = imresize(img,net.Layers(1).InputSize(1:2));
    
    %dcnnf特徴量抽出
    dcnnf = activations(net, reimg, 'fc7');
    
    %ベクトル化
    dcnnf = squeeze(dcnnf);
    
    %正規化
    dcnnf = dcnnf/norm(dcnnf);
        
    features = [features, dcnnf];
end

% 転置
features = features.';

%pos=1, neg=-1としたときの正解ラベル
training_label = [ones(numel(url_pos)*4/5,1); ones(numel(url_neg)*4/5,1)*(-1)];

%分類の正解ラベル
correct_label = [ones(numel(url_pos)/5,1); ones(numel(url_neg)/5,1)*(-1)];

% 認識率
evalRate = zeros(5, 1);

% 5-fold cross validationによる学習・分類評価
idx = [1:numel(url_all)];

% 画像リストの認識結果一覧取得用
img_result = zeros(numel(url_all), 1);

for i = 1:5
    % 8割を学習用、2割を分類用に
    dcnn_learn = features(find(mod(idx, 5)~=(i-1)), :);
    dcnn_eval = features(find(mod(idx, 5)==(i-1)), :);
    
    %学習
    %線形
    model = fitcsvm(dcnn_learn, training_label, 'KernelFunction','linear','KernelScale','auto','Standardize',true);
    
    %分類(今回は学習に用いたすべての画像を分類)
    [predicted_label, scores] = predict(model, dcnn_eval);
    
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
    
    %分類率導出
    evalRate(i) = numel(find(correct_label == predicted_label)) / numel(correct_label);

end

% 各回の分類率
evalRate

% 全体の平均
totalAcc = mean(evalRate)

%認識結果画像配列出力
save('dcnn_other_result.mat', 'img_result');
