function img = my_translate(img)
    rng('default');
    rng('default');
    r = rand(2);
    x = 6 * r(1,1) - 3;
    y = 6 * r(1,2) - 3;
    img = imtranslate(img, [x, y]);
end
