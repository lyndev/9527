echo "copy to docs start"
rm -rf ../../docs
cp -Rp public ../../
mv ../../public ../../docs
echo "copy to docs success"

