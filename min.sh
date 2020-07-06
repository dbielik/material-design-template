
for file in `cd ./www/css;ls -1 *.css`; do
  echo "$file"
  minify ./www/css/"$file" > ./www/css/"${file%.*}".min.css
done
