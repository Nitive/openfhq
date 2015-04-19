git checkout master
git branch -D public
git checkout -b public
gulp product
git add -f public/
git commit -a --allow-empty-message -m ''
git push -f heroku public:master
git checkout master
