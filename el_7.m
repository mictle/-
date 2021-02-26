% 今回は学習済みネットワークとしてvgg16を使用
net = vgg16;

% 使用するすべての画像の配列
url_pos = urllist_ramen_rebalance25;
url_neg = urllist_negative2;
url_all = [url_pos, url_neg];

% 画像読み込み、サイズ変更、dcnn特徴抽出(学習用)
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
training_label = [ones(numel(url_pos),1); ones(numel(url_neg),1)*(-1)];

%学習
%線形
model = fitcsvm(features, training_label, 'KernelFunction','linear','KernelScale','auto','Standardize',true);

% 画像読み込み、サイズ変更、dcnn特徴抽出(分類用)
features2 = [];
for i = 1:numel(urllist_ramen_interesting)
    img = imread(urllist_ramen_interesting(i));
    reimg = imresize(img,net.Layers(1).InputSize(1:2));
    
    %dcnnf特徴量抽出
    dcnnf = activations(net, reimg, 'fc7');
    
    %ベクトル化
    dcnnf = squeeze(dcnnf);
    
    %正規化
    dcnnf = dcnnf/norm(dcnnf);
        
    features2 = [features2, dcnnf];
end

%転置
features2 = features2.';

% 分類
[label,score] = predict(model, features2);

% 降順 ('descent') でソートして，ソートした値とソートインデックスを取得
[sorted_score,sorted_idx] = sort(score(:,2),'descend');

% sorted_score[i](=score[sorted_idx[i],2])の値を出力します．
for i=1:numel(sorted_idx)
  fprintf('%s %f\n',urllist_ramen_interesting(sorted_idx(i)),sorted_score(i));
end

% 結果保存
save('rank_result_25.mat', 'sorted_idx', 'sorted_score');
