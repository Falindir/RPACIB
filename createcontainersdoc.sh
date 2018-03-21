

path_containers="/home/jimmy/jimmy/git/containers/"

rm container.yaml
exec 3<> tmp.yaml

echo "containers: [" >&3

index=1

for dir in `ls -d $path_containers*/`;
do
    name=`basename $dir`;
    f="Dockerfile"

    docker="$dir$f";

    #on exclue les dossiers qui ne sont pas des outils 
    if [ ! -f $docker ]; then   

        #on liste les versions de l'outils
        for subdir in `ls -d $dir*/`;
        do
            version=`basename $subdir`;
            finddocker="$subdir$f";
            #on verifie qu'il existe un Dockerfile
            if [ -e $finddocker ]; then
                
                #echo $finddocker;

                description=$(grep -m1 'description' $finddocker | cut -d'=' -f 2-)
                #echo $description;

                documentation=$(grep -m1 'documentation' $finddocker | cut -d'=' -f 2-)
                
                if [ ${#description} == 0 ]; then
                    description="\"\""
                fi

                if [ ${#documentation} == 0 ]; then            
                    documentation="\"\""                                   
                fi
                
                install="[]"                

                if [ $index != 1 ]; then
                    echo ",{ name: \"$name\", version: \"$version\", description: $description, documentation: $documentation, install: $install }" >&3
                else
                    echo "{name: \"$name\", version: \"$version\", description: $description, documentation: $documentation, install: $install }" >&3
                fi

                let index+=1
            fi
        done
    fi


done

echo "]" >&3

exec 3>&-



tr -d '\r' < tmp.yaml > container.yaml
rm tmp.yaml


