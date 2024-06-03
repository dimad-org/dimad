mkdir -p results/

for demo in demos/*.d; do
  echo "* Testing $demo..."
  outfn=$(basename ${demo//.*}.out)
  cp $demo fort.15
  timeout 15 ./dimad
  cp fort.16 results/${outfn}
  diff demos/${outfn} results/${outfn}
done
