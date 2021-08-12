echo "copy to docs start"
rm -rf ../../docs
cp -Rp public ../../
mv ../../public ../../docs
echo "copy to docs success"

echo "start to git"
git checkout master
git ../../docs
git commit -m "update blog"
git push

echo "git ok"




