% 2クラス分類の指定した結果群のうち9枚をランダムで表示
function n = imageShow2(urllist, resultFile, num)
    load(resultFile);
    for i = 1:num/25
        figure(i);
        for j = 1:25
            subplot(5, 5, j);
            title(""+sorted_score(j+(i-1)*25));
            imshow(urllist(sorted_idx(j+(i-1)*25)));
        end
    end

end