for p in ${baseInputs}; do
    if [ -d "${p}/bin" ]; then
        export PATH=${p}/bin${PATH:+:}${PATH}
    fi
done

let sum=0

for num in ${elements}; do
    let sum=sum+num
done

mkdir -p ${out}

echo ${sum} > ${out}/result.txt
