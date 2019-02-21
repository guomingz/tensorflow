for row in $(curl -s https://api.github.com/search/issues?q=is:pr%20label:comp:mkl%20repo:tensorflow/tensorflow | jq '.items[] | select(.state | contains("open"))' | jq '.html_url') ; do
{
  patch_url=${row:1:${#row}-2}'.diff'
  echo "Applying "$patch_url
  rm -rf /tmp/patch.$$
  curl -o /tmp/patch.$$ -L $patch_url
  git clean -f
  git apply --ignore-space-change --ignore-whitespace --3way /tmp/patch.$$
  if [[ "$?" == "1" ]]; then
      echo "Patch $patch_url failed!"
      continue 
  fi
}
done
