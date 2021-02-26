% 2クラス分類の指定した結果群のうち9枚をランダムで表示
function n = imageShow(imgurllist, resultFile)
    % img_result読み込み
    load(resultFile, 'img_result');
    
    % それぞれの結果表示
    for num = 1:4
        figure(num);
        list = imgurllist(find(img_result==num));
        numel(img_result)
        numel(list)
        % 9枚より多ければランダムで9枚選ぶ
        if numel(list) > 9
            list = list(randperm(length(list),9));
        end
    
        % 表示
        for i = 1 : min(numel(list), 9)
            subplot(3,3,i);
            imshow(list(i));
        end
        n = numel(list);
    end
end

